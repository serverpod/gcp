terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("credentials.json")

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "default" {
  name = "serverpod-network"
}

resource "google_artifact_registry_repository" "my-repo" {
  location      = var.region
  repository_id = "serverpod-containers"
  format        = "DOCKER"
}