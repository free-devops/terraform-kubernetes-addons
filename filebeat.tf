locals {
  filebeat = merge(
    {
      enabled                   = false
      version                   = "6.7.0"
      namespace                 = "filebeat"
    },
    var.filebeat
  )
}

resource "kubectl_manifest" "filebeat" {
  count = local.filebeat["enabled"] ? 1 : 0
  yaml_body = templatefile("${path.module}/templates/filebeat.yml", {
    ELASTICSEARCH_HOSTS = local.filebeat["es_hosts"]
    version = local.filebeat["version"]
    namespace = local.filebeat["namespace"]
  })
}