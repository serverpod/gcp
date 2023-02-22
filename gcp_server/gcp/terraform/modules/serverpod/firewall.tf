resource "google_compute_firewall" "serverpod-instance" {
  name = "serverpod-${var.runmode}-instance"

#   network       = "default"
  network = google_compute_network.serverpod.name
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["8080-8082"]
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["serverpod-${var.runmode}-instance"]
}
