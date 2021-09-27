# infrastructure

This repository contains the [Terraform](https://www.terraform.io/) configuration that steers the infrastructure that is used to run the IRON platform.

## Authentication

For [Cloudflare](https://cloudflare.com/) and [GitHub](https://github.com/), we rely on scoped authentication tokens as a GitHub Action secret.

For Google Cloud, we rely on identity federation by using the [Google Auth GitHub Action](https://github.com/google-github-actions/auth#setup) which scopes a Google Cloud service account to this repository nicely.

## Usage

```shell
# first install terraform
% brew install terraform

# create a development file with your secrets
% vim dev.env
# export TF_VAR_cf_email=""
# export TF_VAR_cf_api_key=""
# export TF_VAR_github_token=""

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
