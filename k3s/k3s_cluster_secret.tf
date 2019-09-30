resource "random_uuid" "k3s_cluster_secret" {
  keepers = { keep = true }
}
