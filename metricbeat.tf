locals {
  metricbeat = merge(
    local.helm_defaults,
    {
      name                   = "metricbeat"
      namespace              = "metricbeat"
      chart                  = "metricbeat"
      repository             = "https://helm.elastic.co"
      enabled                = false
      chart_version          = "6.8.12"
      version                = "6.8.0"
      timeout                = 120
    },
    var.metricbeat

  )
    values_metricbeat = <<VALUES
imageTag: ${local.metricbeat["version"]}
VALUES
}

resource "kubernetes_namespace" "metricbeat" {
  count = local.metricbeat["enabled"] ? 1 : 0

  metadata {
    labels = {
      name = local.metricbeat["namespace"]
    }

    name = local.metricbeat["namespace"]
  }
}

resource "helm_release" "metricbeat" {
  count                 = local.metricbeat["enabled"] ? 1 : 0
  repository            = local.metricbeat["repository"]
  name                  = local.metricbeat["name"]
  chart                 = local.metricbeat["chart"]
  version               = local.metricbeat["chart_version"]
  timeout               = local.metricbeat["timeout"]
  force_update          = local.metricbeat["force_update"]
  recreate_pods         = local.metricbeat["recreate_pods"]
  wait                  = local.metricbeat["wait"]
  atomic                = local.metricbeat["atomic"]
  cleanup_on_fail       = local.metricbeat["cleanup_on_fail"]
  dependency_update     = local.metricbeat["dependency_update"]
  disable_crd_hooks     = local.metricbeat["disable_crd_hooks"]
  disable_webhooks      = local.metricbeat["disable_webhooks"]
  render_subchart_notes = local.metricbeat["render_subchart_notes"]
  replace               = local.metricbeat["replace"]
  reset_values          = local.metricbeat["reset_values"]
  reuse_values          = local.metricbeat["reuse_values"]
  skip_crds             = local.metricbeat["skip_crds"]
  verify                = local.metricbeat["verify"]
  values = [
    local.values_metricbeat,
    local.metricbeat["extra_values"]
  ]
  namespace = kubernetes_namespace.metricbeat.*.metadata.0.name[count.index]
}