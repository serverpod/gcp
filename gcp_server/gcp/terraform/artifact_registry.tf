resource "google_artifact_registry_repository" "containers" {
  location      = var.region
  repository_id = "serverpod-containers"
  format        = "DOCKER"
}
