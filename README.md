# infrastructure

This repository contains the [Terraform](https://www.terraform.io/) configuration that steers the infrastructure that is used to run the IRON platform.

## Usage

```shell
# first install terraform
% brew install terraform

# create a development file with your secrets
% vim dev.env
# export TF_VAR_CF_EMAIL=""
# export TF_VAR_CF_API_KEY=""
# export TF_VAR_GITHUB_TOKEN=""

# ensure you have a billing account associated in GCP
# https://console.cloud.google.com/billing/linkedaccount

# now initialize, create the S3 bucket we will store our terraform state in and create the terraform service account to be used
% make init enable-services create-state-bucket create-terraform-account

# and now we can finally bring up our infrastructure!
% make init validate plan apply
```

## Overview

- `cloudflare/`: the configuration for our Cloudflare DNS service.
- `github/`: the configuration for our GitHub repositories, teams and memberships.
- `google/`: the configuration for our Google Cloud Platform resources, including GKE.
- `kubernetes/`: the configuration for the basic resources on our Kubernetes cluster such as namespaces.
- `helm/`: the configuration for our Helm deployments on the Kubernetes cluster.
