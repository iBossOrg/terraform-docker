# k3s image
data "docker_registry_image" "k3s" {
  name = "${var.registry == null ? "" : "/var.registry"}${var.image_name}:${var.image_tag}"
}
resource "docker_image" "k3s" {
  name          = data.docker_registry_image.k3s.name
  pull_triggers = [data.docker_registry_image.k3s.sha256_digest]
}

# k3s cluster secret
resource "random_uuid" "k3s_cluster_secret" {
  keepers = { keep = true }
}

# k3s master node
resource "docker_container" "k3s_master" {
  name       = var.master_name
  image      = docker_image.k3s.name
  hostname   = "${var.master_name}${var.domain == null ? "" : ".${var.domain}"}"
  privileged = var.worker_nodes_count == 0

  command = compact([
    "server",
    "--https-listen-port", "${var.kubernetes_api_port}",
    "--no-deploy", "traefik",
    var.worker_nodes_count == 0 ? "" : "--disable-agent",
  ])

  env = [
    "K3S_CLUSTER_SECRET=${random_uuid.k3s_cluster_secret.result}",
    "K3S_KUBECONFIG_OUTPUT=/output/kubeconfig.yaml",
    "K3S_KUBECONFIG_MODE=640"
  ]

  ports {
    internal = var.kubernetes_api_port
    external = var.kubernetes_api_port
    protocol = "tcp"
  }

  mounts {
    target = "/run"
    type   = "tmpfs"
  }

  mounts {
    target = "/var/run"
    type   = "tmpfs"
  }

  volumes {
    container_path = "/output"
    host_path      = abspath(var.kubeconfig_dir)
  }

  volumes {
    container_path = "/var/lib/rancher/k3s"
  }
}

# k3s worker nodes
resource "docker_container" "k3s_worker" {
  name       = format(var.worker_name, count.index + 1)
  image      = docker_image.k3s.name
  hostname   = "${format(var.worker_name, count.index + 1)}${var.domain == null ? "" : ".${var.domain}"}"
  privileged = true
  count      = var.worker_nodes_count

  command = [
    "server",
  ]

  env = [
    "K3S_CLUSTER_SECRET=${random_uuid.k3s_cluster_secret.result}",
    "K3S_URL=https://${var.master_name}:${var.kubernetes_api_port}",
  ]

  mounts {
    target = "/run"
    type   = "tmpfs"
  }

  mounts {
    target = "/var/run"
    type   = "tmpfs"
  }
}
