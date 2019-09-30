resource "docker_container" "k3s_worker" {
  count      = var.worker_nodes_count
  name       = format(local.worker_name, count.index + 1)
  image      = docker_image.k3s.name
  hostname   = "${format(local.worker_name, count.index + 1)}${local.domain}"
  privileged = true

  command = [
    "agent",
  ]

  env = [
    "K3S_CLUSTER_SECRET=${random_uuid.k3s_cluster_secret.result}",
    "K3S_URL=https://${local.master_name}${local.domain}:${var.kubernetes_https_port}",
  ]

  # TODO: https://github.com/terraform-providers/terraform-provider-docker/issues/184
  networks = [
    docker_network.default.id,
  ]

  dynamic "mounts" {
    for_each = local.worker_mounts

    content {
      source = lookup(mounts.value, "source", null)
      target = lookup(mounts.value, "target", null)
      type   = lookup(mounts.value, "type", null)
    }
  }
}
