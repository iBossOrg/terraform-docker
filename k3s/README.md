# k3s module

Manages an [k3s](https://k3s.io) cluster in Docker (similar to Rancher's
[k3s](https://github.com/rancher/k3s)).

## Prerequisities

Install [Docker for Desktop](https://www.docker.com/products/docker-desktop) or
get access to existing Docker server.

On Apple macOS, install the [Homebrew](https://brew.sh) package manager and
the following packages:
```bash
brew install terraform
```
On other platforms, install the appropriate packages.

## Usage

Copy and paste into your Terraform configuration, insert the variables, and
run `terraform init`:
```hcl
module "k3s" {
  source   = "github.com/iBossOrg/terraform-docker/k3s"
  # Insert optional input variables here
}
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
