# infrastructure

This repository contains the [Terraform](https://www.terraform.io/) configuration that steers the infrastructure that is used to run the IRON platform.

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

# for local development, a terraform-sa.json credential will be stored on your local filesystem
# in your CI/CD, we rely on the Google Auth GitHub Action identity federation

# and now we can finally bring up our infrastructure!
% make init validate plan apply
```

## Overview

- `cloudflare/`: the configuration for our Cloudflare DNS service.
- `github/`: the configuration for our GitHub repositories, teams and memberships.
- `google/`: the configuration for our Google Cloud Platform resources, including GKE.
- `kubernetes/`: the configuration for the administrative resources for our Kubernetes clusters such as namespaces.
- `helm/`: the configuration for the actual workload Helm deployments on our Kubernetes clusters.

## RBAC

We rely on the [Google Groups GKE RBAC](https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control) feature to re-use Google Workspace Groups to grant access to our Kubernetes cluster. This provides us with a single source of truth.

## Authentication

### GitHub

Create a developer token in your [GitHub](https://github.com/) profile and set it as an export in `dev.env` or in GitHub Actions.

### Cloudflare

Create a scoped [Cloudflare](https://cloudflare.com/) API key in your Cloudflare account and set it as an export in `dev.env`  or in GitHub Actions.

### Google Cloud

Setup the [Google Auth GitHub Action](https://github.com/google-github-actions/auth#setup) for GCP identity federation for CI/CD.

Local development access to Google Cloud is done through `gcloud`, so make sure you went through a `gcloud login` flow.

For Google Cloud, we rely on identity federation by using the  which scopes a Google Cloud service account to this repository nicely.
Any authentication performed against any private workloads on GKE should be done over either IAP or Cloudflare Access.

### Kubernetes

Access to the Kubernetes API is done over the `gcloud` command and the actual Kubernetes API is kept private.
This allows us to re-use regular Google Cloud authentication & authorization for our Kubernetes cluster at all times.
