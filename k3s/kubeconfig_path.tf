resource "null_resource" "k3s_bootstrap" {
  depends_on = [
    docker_container.k3s_server,
    docker_container.k3s_worker,
  ]

  triggers = {
    server_id = docker_container.k3s_server.id
    worker_id = join(",", docker_container.k3s_worker.*.id)
  }

  provisioner "local-exec" {
    command = <<-EOF
      set -ex
      while [ ! -f ${local.kubeconfig_path} ]; do sleep 1; done
      export KUBECONFIG=${local.kubeconfig_path}
      kubectl --namespace kube-system rollout status deploy/coredns
    EOF
  }
}

data "external" "kubeconfig_path" {
  depends_on = [
    null_resource.k3s_bootstrap,
  ]

  program = [
    "sh", "-c",
    <<-EOF
      echo "{\"path\": \"${local.kubeconfig_path}\"}"
    EOF
  ]
}
