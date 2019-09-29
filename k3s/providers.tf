# https://www.terraform.io/docs/configuration/modules.html#providers-within-modules

# At this time it is required to write an explicit proxy configuration block
# even for default (un-aliased) provider configurations when they will be passed
# via an explicit providers block.
provider "docker" {}
