################################################################################

module "k3s_single" {
  source                = "../"
  cluster_name          = "k3s-single"
  kubeconfig_dir        = "k3s-single"
  kubernetes_http_port  = 6440
  kubernetes_https_port = 6441
}

output "k3s_single_id" {
  value = module.k3s_single.id
}

output "k3s_single_kubeconfig_path" {
  value = module.k3s_single.kubeconfig_path
}

################################################################################

resource "null_resource" "k3s_single" {
  depends_on = [module.k3s_single]
  triggers   = { always = uuid() }
  provisioner "local-exec" {
    command = <<-EOF
      set -ex
      export KUBECONFIG=${module.k3s_single.kubeconfig_path}
      kubectl cluster-info
      kubectl get nodes
      kubectl get all --all-namespaces
    EOF
  }
}

################################################################################

module k3s_cluster {
  source             = "../"
  cluster_name       = "k3s-cluster"
  kubeconfig_dir     = "k3s-cluster"
  worker_nodes_count = 3
  master_name        = "master"
  # dependencies       = [module.k3s_single.id]

  ingress_ports = [
    {
      internal = 80,
      external = 80,
    }
  ]
}

output "k3s_cluster_id" {
  value = module.k3s_cluster.id
}

output "k3s_cluster_kubeconfig_path" {
  value = module.k3s_cluster.kubeconfig_path
}

################################################################################

resource "null_resource" "k3s_cluster" {
  depends_on = [module.k3s_cluster]
  triggers   = { always = uuid() }
  provisioner "local-exec" {
    command = <<-EOF
      set -ex
      export KUBECONFIG=${module.k3s_cluster.kubeconfig_path}
      kubectl cluster-info
      kubectl get nodes
      kubectl get all --all-namespaces
    EOF
  }
}

################################################################################
