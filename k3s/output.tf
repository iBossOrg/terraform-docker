output "kubeconfig_path" {
  value = "${abspath(var.kubeconfig_dir)}/kubeconfig.yaml"
}
