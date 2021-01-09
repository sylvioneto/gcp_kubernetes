terraform {
  backend "gcs" {
    bucket = "spedroza-terraform"
    prefix = "tests-gke/cluster-1"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
