locals {
  project_id = "spedroza-sandbox"
  region     = "us-central1"
}

provider "google" {
  project = local.project_id
  region  = local.region
}
