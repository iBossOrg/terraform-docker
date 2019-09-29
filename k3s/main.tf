# Docker image
data "docker_registry_image" "k3s" {
  name = "${var.registry == null ? "" : "/var.registry"}${var.image_name}:${var.image_tag}"
}
resource "docker_image" "k3s" {
  name          = data.docker_registry_image.k3s.name
  pull_triggers = [data.docker_registry_image.k3s.sha256_digest]
}

# Kubernetes cluster secret
resource "random_uuid" "k3s_cluster_secret" {
  keepers = { keep = true }
}

# Default network
resource "docker_network" "k3s_default" {
  name   = "${var.cluster_name}-default"
  driver = "bridge"
}

# Images volume
resource "docker_volume" "k3s_images" {
  name   = "${var.cluster_name}-images"
  driver = "local"
}

# Node names
locals {
  domain      = var.domain == null ? "" : ".${var.domain}"
  master_name = "${var.cluster_name}-${var.master_name}"
  worker_name = "${var.cluster_name}-${var.worker_name}-%d"
}

# Master node
resource "docker_container" "k3s_master" {
  name       = local.master_name
  image      = docker_image.k3s.name
  hostname   = "${local.master_name}${local.domain}"
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

  networks = [
    docker_network.k3s_default.id,
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
    container_path = "/images"
    volume_name    = docker_volume.k3s_images.name
  }

  volumes {
    container_path = "/output"
    host_path      = abspath(var.kubeconfig_dir)
  }

  volumes {
    container_path = "/var/lib/rancher/k3s"
  }
}

# Worker nodes
resource "docker_container" "k3s_worker" {
  name       = format(local.worker_name, count.index + 1)
  image      = docker_image.k3s.name
  hostname   = "${format(local.worker_name, count.index + 1)}${local.domain}"
  privileged = true
  count      = var.worker_nodes_count

  command = [
    "server",
  ]

  env = [
    "K3S_CLUSTER_SECRET=${random_uuid.k3s_cluster_secret.result}",
    "K3S_URL=https://${var.master_name}:${var.kubernetes_api_port}",
  ]

  networks = [
    docker_network.k3s_default.id,
  ]

  mounts {
    target = "/run"
    type   = "tmpfs"
  }

  mounts {
    target = "/var/run"
    type   = "tmpfs"
  }

  volumes {
    container_path = "/images"
    volume_name    = docker_volume.k3s_images.name
  }
}
