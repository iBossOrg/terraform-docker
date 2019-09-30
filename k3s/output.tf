output "id" {
  description = "Docker k3s master node container id"
  value       = docker_container.k3s_server.id
}

output "k3s_cluster_secret" {
  description = "k3s cluster secret"
  sensitive   = true
  value       = random_uuid.k3s_cluster_secret.result
}

output "kubeconfig_path" {
  description = "Path to kubeconfig.yaml"
  value       = data.external.kubeconfig_path.result.path
}
