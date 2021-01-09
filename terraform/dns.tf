resource "google_compute_global_address" "ingress_external_ip" {
  name         = "ingress-nginx-${var.cluster_name}"
  description  = "NGINX Load balancer IP for ${var.cluster_name}"
  address_type = "EXTERNAL"
}

resource "google_dns_managed_zone" "public" {
  name = "public"

  dns_name    = "${var.dns_name}."
  description = "Public zone"
  visibility  = "public"
  labels      = var.resource_labels
}

resource "google_dns_record_set" "root" {
  name = "${var.dns_name}."
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.public.name
  rrdatas      = [google_compute_global_address.ingress_external_ip.address]
}
