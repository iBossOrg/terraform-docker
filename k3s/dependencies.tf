module "dependencies" {
  source       = "github.com/iBossOrg/terraform-common/dependencies"
  dependencies = var.dependencies == null ? [] : var.dependencies
}
