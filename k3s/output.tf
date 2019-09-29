output "id" {
  description = "Docker k3s master node container ids"
  value       = docker_container.k3s_master.id
}

output "kubeconfig_path" {
  description = "Path to kubeconfig.yaml"
  value       = "${abspath(var.kubeconfig_dir)}/kubeconfig.yaml"
}
