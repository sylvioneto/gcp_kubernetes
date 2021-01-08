resource "google_service_account" "external_dns" {
  account_id   = "external-dns"
  display_name = "External DNS"
}

resource "google_service_account_iam_member" "workload_identity" {
  service_account_id = google_service_account.external_dns.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${data.google_project.project.project_id}.svc.id.goog[external-dns/external-dns]"
}

resource "google_project_iam_member" "dns_admin" {
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.external_dns.email}"
}
