resource "docker_container" "k3s_server" {
  depends_on = [module.dependencies]
  name       = local.master_name
  image      = docker_image.k3s.name
  hostname   = "${local.master_name}${local.domain}"
  privileged = var.worker_nodes_count == 0

  command = compact([
    "server",
    "--http-listen-port", "${var.kubernetes_http_port}",
    "--https-listen-port", "${var.kubernetes_https_port}",
    "--no-deploy", "traefik",
    var.worker_nodes_count == 0 ? null : "--disable-agent",
  ])

  env = [
    "K3S_CLUSTER_SECRET=${random_uuid.k3s_cluster_secret.result}",
    "K3S_KUBECONFIG_OUTPUT=/output/kubeconfig.yaml",
    "K3S_KUBECONFIG_MODE=640"
  ]

  # TODO: https://github.com/terraform-providers/terraform-provider-docker/issues/184
  networks = [
    docker_network.default.id,
  ]

  dynamic "ports" {
    for_each = local.ingress_ports

    content {
      internal = lookup(ports.value, "internal", null)
      external = lookup(ports.value, "external", null)
      protocol = lookup(ports.value, "protocol", null)
    }
  }

  dynamic "mounts" {
    for_each = local.server_mounts

    content {
      source = lookup(mounts.value, "source", null)
      target = lookup(mounts.value, "target", null)
      type   = lookup(mounts.value, "type", null)
    }
  }

  volumes {
    container_path = "/output"
    host_path      = abspath(var.kubeconfig_dir)
  }

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"
    command    = "set -ex; rm -f ${local.kubeconfig_path}"
  }
}
