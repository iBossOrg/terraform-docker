################################################################################

module "k3s_single" {
  source              = "../"
  master_name         = "k3s-single"
  kubeconfig_dir      = "k3s-single"
  kubernetes_api_port = 6442
}

output "k3s_single_kubeconfig_path" {
  value = module.k3s_single.kubeconfig_path
}

################################################################################

module k3s_cluster {
  source             = "../"
  worker_nodes_count = 3
  kubeconfig_dir     = "k3s-cluster"
}

output "k3s_cluster_kubeconfig_path" {
  value = module.k3s_single.kubeconfig_path
}

################################################################################
