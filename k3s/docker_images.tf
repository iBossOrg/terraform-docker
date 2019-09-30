data "docker_registry_image" "k3s" {
  name = "${var.registry == null ? "" : "${var.registry}/"}${var.image_name}:${var.image_tag}"
}
resource "docker_image" "k3s" {
  depends_on    = [module.dependencies]
  name          = data.docker_registry_image.k3s.name
  pull_triggers = [data.docker_registry_image.k3s.sha256_digest]
}
