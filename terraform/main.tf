terraform {
  backend "gcs" {
    bucket = "spedroza-tf-state"
    prefix = "sandbox/test-1"
  }
}

locals {
  project_id = "spedroza-sandbox"
  region     = "us-central1"
  env        = "sandbox"
  resource_labels = {
    terraform   = "true"
    cost-center = "training"
    env         = "sandbox"
  }
}

provider "google" {
  project = local.project_id
  region  = local.region
}

module "core" {
  source = "git::https://github.com/sylvioneto/terraform_gcp.git//modules/core"
  region = local.region
  labels = local.resource_labels
}
