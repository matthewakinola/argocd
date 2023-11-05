resource "google_compute_router" "router" {
  name = "django-k8s-router"
  region = var.region
  network = google_compute_network.main.id
}