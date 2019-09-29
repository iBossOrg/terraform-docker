################################################################################

module "k3s_single" {
  source              = "../"
  cluster_name        = "k3s-single"
  kubeconfig_dir      = "k3s-single"
  kubernetes_api_port = 6442
}

output "k3s_single_id" {
  value = module.k3s_single.id
}

output "k3s_single_kubeconfig_path" {
  value = module.k3s_single.kubeconfig_path
}

################################################################################

module k3s_cluster {
  source             = "../"
  cluster_name       = "k3s-cluster"
  kubeconfig_dir     = "k3s-cluster"
  worker_nodes_count = 3
}

output "k3s_cluster_id" {
  value = module.k3s_cluster.id
}

output "k3s_cluster_kubeconfig_path" {
  value = module.k3s_single.kubeconfig_path
}

################################################################################
