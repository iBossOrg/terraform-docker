variable "registry" {
  description = "k3s docker image registry"
  type        = string
  default     = null
}

variable "image_name" {
  description = "k3s docker image repository"
  type        = string
  default     = "rancher/k3s"
}

variable "image_tag" {
  description = "k3s docker image tag"
  type        = string
  default     = "latest"
}

variable "kubeconfig_dir" {
  description = "The path to the directory where kubeconfig.yaml will be stored"
  type        = string
  default     = "."
}

variable "kubernetes_api_port" {
  description = "Kubernetes API port"
  type        = number
  default     = 6443
}

variable "cluster_name" {
  description = "Kubernetes cluster name"
  type        = string
  default     = "k3s-default"
}

variable "master_name" {
  description = "Kubernetes master node name"
  type        = string
  default     = "server"
}

variable "worker_name" {
  description = "Kubernetes worker nodes name"
  type        = string
  default     = "worker"
}

variable "domain" {
  description = "Master and worker domain (e.q. 'local')"
  type        = string
  default     = null
}

variable "worker_nodes_count" {
  description = "Number of worker nodes. If not defined, single-node cluster will be created"
  type        = number
  default     = 0
}
