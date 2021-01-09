module "gke_cluster" {
  source                   = "git::https://github.com/sylvioneto/terraform_gcp.git//modules/gke"
  name                     = "cluster-1"
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
}
