# Terraform modules for Docker

## Terraform modules

* [k3s](k3s/README.md) - Manages an [k3s](https://k3s.io) cluster in Docker
(similar to Rancher's [k3d](https://github.com/rancher/k3d)).

## Reporting Issues

Issues can be reported by using [GitHub Issues](/../../issues). Full details on
how to report issues can be found in the [Contribution Guidelines](CONTRIBUTING.md).

## Contributing

Please read the [Contribution Guidelines](CONTRIBUTING.md), and ensure you are
signing all your commits with
[DCO sign-off](CONTRIBUTING.md#developer-certification-of-origin-dco).

### Install dependencies

Install [Docker for Desktop](https://www.docker.com/products/docker-desktop) or
obtain access to existing Docker server.

On Apple macOS, install the [Homebrew](https://brew.sh) package manager and
the following packages:
```bash
brew install pre-commit
brew install terraform
brew install terraform-docs
```
On other platforms, install the appropriate packages.

### Download source code

Clone the GitHub repository into your working directory:
```bash
git clone https://github.com/iBossOrg/Mk
git clone https://github.com/iBossOrg/terraform-docker
cd terraform-docker
```

### Usage

In the root directory, use the following commands:
```bash
make init             # Initialize Git hooks
make pre-commit       # Run Git pre-commit checks manually
```

In the module's test directories, use the following commands:
```bash
make init             # Init Terraform
make plan             # Show Terraform plan
make apply            # Create resources in Docker
make output           # Show Terraform output variables
make destroy          # Destroy resources in Docker
make forget           # Remove Terraform state file
make clean            # Remove all generated files
```

## Authors

* [Petr Řehoř](https://github.com/prehor) - Initial work.

See also the list of [contributors](/../../contributors) who have participated
in this project.

## License

This project is licensed under the Apache License, Version 2.0 - see the
[LICENSE](LICENSE) file for details.
