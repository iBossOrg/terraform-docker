resource "docker_network" "default" {
  depends_on = [module.dependencies]
  name       = "${var.cluster_name}"
  driver     = "bridge"
}
