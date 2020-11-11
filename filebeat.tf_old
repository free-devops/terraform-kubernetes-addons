locals {
  filebeat = merge(
    local.helm_defaults,
    {
      name                   = "filebeat"
      namespace              = "filebeat"
      chart                  = "filebeat"
      repository             = "https://helm.elastic.co"
      enabled                = false
      chart_version          = "6.8.12"
      version                = "6.8.0"
      timeout                = 120
    },
    var.filebeat

  )
    values_filebeat = <<VALUES
imageTag: ${local.filebeat["version"]}
extraEnvs:
  - name: ELASTICSEARCH_HOSTS
    value: 172.31.44.105:9200
  - name: ELASTICSEARCH_USERNAME
    value: elastic
  - name: ELASTICSEARCH_PASSWORD
    value: changeme
VALUES
}

resource "kubernetes_namespace" "filebeat" {
  count = local.filebeat["enabled"] ? 1 : 0

  metadata {
    labels = {
      name = local.filebeat["namespace"]
    }

    name = local.filebeat["namespace"]
  }
}

resource "helm_release" "filebeat" {
  count                 = local.filebeat["enabled"] ? 1 : 0
  repository            = local.filebeat["repository"]
  name                  = local.filebeat["name"]
  chart                 = local.filebeat["chart"]
  version               = local.filebeat["chart_version"]
  timeout               = local.filebeat["timeout"]
  force_update          = local.filebeat["force_update"]
  recreate_pods         = local.filebeat["recreate_pods"]
  wait                  = local.filebeat["wait"]
  atomic                = local.filebeat["atomic"]
  cleanup_on_fail       = local.filebeat["cleanup_on_fail"]
  dependency_update     = local.filebeat["dependency_update"]
  disable_crd_hooks     = local.filebeat["disable_crd_hooks"]
  disable_webhooks      = local.filebeat["disable_webhooks"]
  render_subchart_notes = local.filebeat["render_subchart_notes"]
  replace               = local.filebeat["replace"]
  reset_values          = local.filebeat["reset_values"]
  reuse_values          = local.filebeat["reuse_values"]
  skip_crds             = local.filebeat["skip_crds"]
  verify                = local.filebeat["verify"]
  values = [
    local.values_filebeat,
    local.filebeat["extra_values"]
  ]
  namespace = kubernetes_namespace.filebeat.*.metadata.0.name[count.index]
}