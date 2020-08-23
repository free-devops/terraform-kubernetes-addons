locals {
  pusher_wave = merge(
    {
      enabled                   = false
    },
    var.pusher_wave
  )
}

resource "kubectl_manifest" "pusher_wave" {
  count = local.pusher_wave["enabled"] ? 1 : 0
  yaml_body = templatefile("${path.module}/templates/pusher-wave.yaml", {
//    pusher_wave_version       = local.pusher_wave["version"] # Passing variable example
  })
}