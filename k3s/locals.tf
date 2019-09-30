locals {
  master_name = "${var.cluster_name}-${var.master_name}"
  worker_name = "${var.cluster_name}-${var.worker_name}%d"
  domain      = var.domain == null ? "" : ".${var.domain}"

  kubeconfig_path = "${abspath(var.kubeconfig_dir)}/kubeconfig.yaml"

  ingress_ports = concat(
    var.ingress_ports == null ? [] : var.ingress_ports,
    [
      {
        internal = var.kubernetes_http_port
        external = var.kubernetes_http_port
        protocol = "tcp"
      },
      {
        internal = var.kubernetes_https_port
        external = var.kubernetes_https_port
        protocol = "tcp"
      },
    ],
  )

  server_mounts = concat(
    local.worker_mounts,
    [
      {
        source = docker_volume.server_db.name
        target = "/var/lib/rancher/k3s"
        type   = "volume"
      },
    ]
  )

  worker_mounts = [
    {
      source = docker_volume.images.name
      target = "/images"
      type   = "volume"
    },
    {
      target = "/run"
      type   = "tmpfs"
    },
    {
      target = "/var/run"
      type   = "tmpfs"
    },
  ]

}
