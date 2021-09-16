# infrastructure

The repository that contains the [Terraform](https://www.terraform.io/) configuration for the infrastructure that is used to run IRON.

## Usage

```shell
# first install terraform
% brew install terraform

# ensure you have a billing account associated in GCP
# https://console.cloud.google.com/billing/linkedaccount

# now initialize, create the S3 bucket we will store our terraform state in and create the terraform service account to be used
% make init create-state-bucket create-terraform-account