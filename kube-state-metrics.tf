locals {
  kube-state-metrics = merge(
    local.helm_defaults,
    {
      name                   = "kube-state-metrics"
      namespace              = "kube-state-metrics"
      chart                  = "kube-state-metrics"
      repository             = "https://charts.helm.sh/stable"
      enabled                = false
      chart_version          = "2.9.2"
      version                = "v1.9.7"
      timeout                = 120
    },
    var.kube-state-metrics

  )
    values_kube-state-metrics = <<VALUES
image:
  tag: ${local.kube-state-metrics["version"]}
VALUES
}

resource "kubernetes_namespace" "kube-state-metrics" {
  count = local.kube-state-metrics["enabled"] ? 1 : 0

  metadata {
    labels = {
      name = local.kube-state-metrics["namespace"]
    }

    name = local.kube-state-metrics["namespace"]
  }
}

resource "helm_release" "kube-state-metrics" {
  count                 = local.kube-state-metrics["enabled"] ? 1 : 0
  repository            = local.kube-state-metrics["repository"]
  name                  = local.kube-state-metrics["name"]
  chart                 = local.kube-state-metrics["chart"]
  version               = local.kube-state-metrics["chart_version"]
  timeout               = local.kube-state-metrics["timeout"]
  force_update          = local.kube-state-metrics["force_update"]
  recreate_pods         = local.kube-state-metrics["recreate_pods"]
  wait                  = local.kube-state-metrics["wait"]
  atomic                = local.kube-state-metrics["atomic"]
  cleanup_on_fail       = local.kube-state-metrics["cleanup_on_fail"]
  dependency_update     = local.kube-state-metrics["dependency_update"]
  disable_crd_hooks     = local.kube-state-metrics["disable_crd_hooks"]
  disable_webhooks      = local.kube-state-metrics["disable_webhooks"]
  render_subchart_notes = local.kube-state-metrics["render_subchart_notes"]
  replace               = local.kube-state-metrics["replace"]
  reset_values          = local.kube-state-metrics["reset_values"]
  reuse_values          = local.kube-state-metrics["reuse_values"]
  skip_crds             = local.kube-state-metrics["skip_crds"]
  verify                = local.kube-state-metrics["verify"]
  values = [
    local.values_kube-state-metrics,
    local.kube-state-metrics["extra_values"]
  ]
  namespace = kubernetes_namespace.kube-state-metrics.*.metadata.0.name[count.index]
}