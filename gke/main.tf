locals {
  project_id = "myname-sandbox"
  region     = "us-central1"
}

provider "google" {
  project = local.project_id
  region  = local.region
  version = "3.41.0"
}
