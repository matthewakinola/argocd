resource "google_compute_subnetwork" "private" {
  name       = "private-subnet"
  ip_cidr_range     = "89.0.0.0/18"
  region = var.region
  network = google_compute_network.main.id
  private_ip_google_access = true 

  secondary_ip_range {
    range_name = "k8s-pod-range"
    ip_cidr_range = "89.142.0.0/14"
  }
   secondary_ip_range {
    range_name = "k8s-service-range"
    ip_cidr_range = "89.160.0.0/20"
  }
}