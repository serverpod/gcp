resource "google_cloud_run_service" "api" {
  name     = "serverpod-${var.runmode}-api"
  location = var.region

  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project}/serverpod-production-container/serverpod"

        env {
            name  = "runmode"
            value = var.runmode
        }

        ports {
        container_port = 8080
    }
      }
      service_account_name = var.service_account_email
    }

    
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_binding" "api" {
    project = var.project
  location = google_cloud_run_service.api.location
  service  = google_cloud_run_service.api.name
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
}