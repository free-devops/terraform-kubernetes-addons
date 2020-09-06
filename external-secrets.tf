locals {
  externalsecrets = merge(
    local.helm_defaults,
    {
      name                      = "external-secrets"
      namespace                 = "external-secrets"
      chart                     = "kubernetes-external-secrets"
      repository                = "https://godaddy.github.io/kubernetes-external-secrets/"
      service_account_name      = "external-secrets"
      enabled                   = false
      create_iam_resources_irsa = true
      chart_version             = "3.2.0"
      version                   = "3.2.0"
      poller_interval_ms        = 10000
      disable_polling           = false
      timeout                   = 120
      skip_crds                 = true
      recreate_pods             = true
    },
    var.externalsecrets

  )
    values_externalsecrets = <<VALUES
image:
  tag: ${local.externalsecrets["version"]}
env:
  AWS_REGION: ${data.aws_region.current.name}
  POLLER_INTERVAL_MILLISECONDS: ${local.externalsecrets["poller_interval_ms"]}
  DISABLE_POLLING: ${local.externalsecrets["disable_polling"]}
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: ${module.iam_assumable_role_externalsecret.this_iam_role_arn}
  name: ${local.externalsecrets["service_account_name"]}
securityContext:
  fsGroup: 65534
VALUES
}

resource "kubernetes_namespace" "externalsecrets" {
  count = local.externalsecrets["enabled"] ? 1 : 0

  metadata {
    labels = {
      name = local.externalsecrets["namespace"]
    }

    name = local.externalsecrets["namespace"]
  }
}

resource "helm_release" "externalsecrets" {
  count                 = local.externalsecrets["enabled"] ? 1 : 0
  repository            = local.externalsecrets["repository"]
  name                  = local.externalsecrets["name"]
  chart                 = local.externalsecrets["chart"]
  version               = local.externalsecrets["chart_version"]
  timeout               = local.externalsecrets["timeout"]
  force_update          = local.externalsecrets["force_update"]
  recreate_pods         = local.externalsecrets["recreate_pods"]
  wait                  = local.externalsecrets["wait"]
  atomic                = local.externalsecrets["atomic"]
  cleanup_on_fail       = local.externalsecrets["cleanup_on_fail"]
  dependency_update     = local.externalsecrets["dependency_update"]
  disable_crd_hooks     = local.externalsecrets["disable_crd_hooks"]
  disable_webhooks      = local.externalsecrets["disable_webhooks"]
  render_subchart_notes = local.externalsecrets["render_subchart_notes"]
  replace               = local.externalsecrets["replace"]
  reset_values          = local.externalsecrets["reset_values"]
  reuse_values          = local.externalsecrets["reuse_values"]
  skip_crds             = local.externalsecrets["skip_crds"]
  verify                = local.externalsecrets["verify"]
  values = [
    local.values_externalsecrets,
    local.externalsecrets["extra_values"]
  ]
  namespace = kubernetes_namespace.externalsecrets.*.metadata.0.name[count.index]
}


module "iam_assumable_role_externalsecret" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> v2.0"
  create_role                   = local.externalsecrets["enabled"] && local.externalsecrets["create_iam_resources_irsa"]
  role_name                     = "tf-eks-${var.cluster-name}-externalsecrets-irsa"
  provider_url                  = replace(var.eks["cluster_oidc_issuer_url"], "https://", "")
  role_policy_arns              = local.externalsecrets["create_iam_resources_irsa"] ? [aws_iam_policy.externalsecrets[0].arn] : []
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.externalsecrets["namespace"]}:${local.externalsecrets["service_account_name"]}"]
}

resource "aws_iam_policy" "externalsecrets" {
  count  = local.externalsecrets["enabled"] && local.externalsecrets["create_iam_resources_irsa"] ? 1 : 0
  name        = "tf-eks-${var.cluster-name}-externalsecrets"
  path        = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "ssm:DescribeParameters",
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameters",
                "ssm:GetParameter"
            ],
            "Resource": "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.environment}/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetResourcePolicy",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds"
            ],
            "Resource": "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:/${var.environment}/*"
        }
    ]
}
EOF
}