resource "google_sql_database_instance" "serverpod" {
  name             = "serverpod-${var.runmode}-database"
  database_version = "POSTGRES_14"
  region           = var.region

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"

    # depends_on = [google_service_networking_connection.private-vpc-connection]

    ip_configuration {
      ipv4_enabled                                  = true
      private_network                               = google_compute_network.serverpod.id

    #   enable_private_path_for_google_cloud_services = true
    }
  }

  deletion_protection = false
}

resource "google_sql_database" "serverpod" {
  name     = "examplepod"
  instance = google_sql_database_instance.serverpod.name
}

resource "google_sql_user" "serverpod" {
  name     = "postgres"
  password = var.database_password
  instance = google_sql_database_instance.serverpod.name
}


