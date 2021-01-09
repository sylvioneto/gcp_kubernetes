
region                   = "us-central1"
vpc                      = "tests-gke-vpc"
cluster_name             = "cluster-1"
remove_default_node_pool = false

ip_allocation_ranges = {
  pods     = "10.1.0.0/22",
  services = "10.1.4.0/24",
  master   = "10.1.5.0/28",
  nodes    = "10.1.6.0/24",
}

resource_labels = {
  terraform   = "true"
  cost-center = "training"
  env         = "sandbox"
}
