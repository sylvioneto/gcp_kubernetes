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
  #source = "git::git@github.com:sylvioneto/terraform_gcp.git//modules/core?ref=v1.1"
  source = "../../modules/core"
  region = local.region
  labels = local.resource_labels
}

module "gke_cluster" {
  #source                   = "git::git@github.com:sylvioneto/terraform_gcp.git//modules/gke?ref=v1.1"
  source                   = "../../modules/gke"
  name                     = "test-1"
  region                   = local.region
  vpc                      = module.core.vpc.self_link
  remove_default_node_pool = false
  ip_allocation_ranges = {
    pods     = "10.1.0.0/22",
    services = "10.1.4.0/24",
    master   = "10.1.5.0/28",
    nodes    = "10.1.6.0/24",
  }
  resource_labels          = local.resource_labels
  tags = ["allow-ext-ssh"]
}
