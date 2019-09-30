resource "docker_volume" "images" {
  depends_on = [module.dependencies]
  name       = "${var.cluster_name}-images"
  driver     = "local"
}

resource "docker_volume" "server_db" {
  depends_on = [module.dependencies]
  name       = "${var.cluster_name}-db"
  driver     = "local"
}
