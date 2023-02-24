resource "google_redis_instance" "serverpod" {
    name = "serverpod-${var.runmode}-cache"
    tier = "BASIC"
    memory_size_gb = 1

    authorized_network = google_compute_network.serverpod.id
}