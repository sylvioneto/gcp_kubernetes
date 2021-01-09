resource "google_compute_firewall" "allow_internal_all" {
  name          = "allow-internal-all"
  description   = "Allow all between VPC instances"
  network       = google_compute_network.vpc.self_link
  direction     = "INGRESS"
  source_ranges = [var.vpc_cidr]

  allow {
    protocol = "all"
    ports    = []
  }
}

resource "google_compute_firewall" "allow_external_ssh" {
  name        = "allow-iap-ssh"
  description = "Allow SSH to the instances from external source"
  network     = google_compute_network.vpc.self_link
  direction   = "INGRESS"
  target_tags = ["allow-iap-ssh"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [
    "35.235.240.0/20"
  ]
}

resource "google_compute_firewall" "allow_ingress_http" {
  name          = "allow-http"
  description   = "Allow HTTP ingress traffic from the internet"
  network       = google_compute_network.vpc.self_link
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-http"]

  allow {
    protocol = "tcp"
    ports = [
      "80", "8080", "443"
    ]
  }
}

resource "google_compute_firewall" "allow_google_hc" {
  name          = "allow-google-health-checks"
  description   = "Allow Google Health Checks"
  network       = google_compute_network.vpc.self_link
  direction     = "INGRESS"
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]

  allow {
    protocol = "tcp"
  }
}
