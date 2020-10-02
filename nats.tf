locals {
  nats = merge(
    local.helm_defaults,
    {
      name                      = "nats"
      namespace                 = "nats"
      chart                     = "nats"
      repository                = "https://charts.bitnami.com/bitnami/"
      enabled                   = false
      chart_version             = "4.5.4"
      version                   = "2.1.8-debian-10-r12"
      skip_crds                 = true
      recreate_pods             = false
      auth_enabled              = false
      maxConnections            = 100
      maxControlLine            = 512
      maxPayload                = 10000000
      writeDeadline             = "2s"
      replicaCount              = 1
    },
    var.nats

  )
    values_nats = <<VALUES
image:
  tag: ${local.nats["version"]}
auth:
  enabled: ${local.nats["auth_enabled"]}
maxConnections : ${local.nats["maxConnections"]}
maxControlLine : ${local.nats["maxControlLine"]}
maxPayload: ${local.nats["maxPayload"]}
writeDeadline: ${local.nats["writeDeadline"]}
replicaCount: ${local.nats["replicaCount"]}
VALUES
}

resource "kubernetes_namespace" "nats" {
  count = local.nats["enabled"] ? 1 : 0

  metadata {
    labels = {
      name = local.nats["namespace"]
    }

    name = local.nats["namespace"]
  }
}

resource "helm_release" "nats" {
  count                 = local.nats["enabled"] ? 1 : 0
  repository            = local.nats["repository"]
  name                  = local.nats["name"]
  chart                 = local.nats["chart"]
  version               = local.nats["chart_version"]
  timeout               = local.nats["timeout"]
  force_update          = local.nats["force_update"]
  recreate_pods         = local.nats["recreate_pods"]
  wait                  = local.nats["wait"]
  atomic                = local.nats["atomic"]
  cleanup_on_fail       = local.nats["cleanup_on_fail"]
  dependency_update     = local.nats["dependency_update"]
  disable_crd_hooks     = local.nats["disable_crd_hooks"]
  disable_webhooks      = local.nats["disable_webhooks"]
  render_subchart_notes = local.nats["render_subchart_notes"]
  replace               = local.nats["replace"]
  reset_values          = local.nats["reset_values"]
  reuse_values          = local.nats["reuse_values"]
  skip_crds             = local.nats["skip_crds"]
  verify                = local.nats["verify"]
  values = [
    local.values_nats,
    local.nats["extra_values"]
  ]
  namespace = kubernetes_namespace.nats.*.metadata.0.name[count.index]
}