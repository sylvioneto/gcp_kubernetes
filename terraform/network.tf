# Create VPC
resource "google_compute_network" "vpc" {
  name                    = "${data.google_project.project.project_id}-vpc"
  description             = "VPC managed by terraform"
  auto_create_subnetworks = false
}

# Create NAT and Router
resource "google_compute_router" "nat_router" {
  name    = "${data.google_project.project.project_id}-nat-router"
  network = google_compute_network.vpc.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat_gateway" {
  name                               = "${data.google_project.project.project_id}-nat"
  router                             = google_compute_router.nat_router.name
  region                             = google_compute_router.nat_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# Cluster Subnet
resource "google_compute_subnetwork" "gke_subnet" {
  name                     = var.cluster_name
  ip_cidr_range            = var.ip_allocation_ranges["nodes"]
  region                   = var.region
  network                  = var.vpc
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.ip_allocation_ranges["pods"]
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.ip_allocation_ranges["services"]
  }
}

resource "google_compute_global_address" "google_compute_global_address" {
  name         = "ingress-nginx-${var.cluster_name}"
  description  = "NGINX Load balancer IP for ${var.cluster_name}"
  address_type = "EXTERNAL"
}
