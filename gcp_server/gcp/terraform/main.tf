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

module "serverpod_production" {
  source = "./modules/serverpod"

  project = var.project
  runmode = "production"

  region = var.region
  zone   = var.zone

  top_domain = "examplepod.com"

  autoscaling_min_size = var.autoscaling_min_size
  autoscaling_max_size = var.autoscaling_max_size

  service_account_email = var.service_account_email

  database_password = var.DATABASE_PASSWORD_PRODUCTION
}

module "serverpod_staging" {
  source = "./modules/serverpod"
  count  = var.enable_staging ? 1 : 0

  project = var.project
  runmode = "staging"

  region = var.region
  zone   = var.zone

  top_domain = "examplepod.com"

  autoscaling_min_size = var.autoscaling_min_size
  autoscaling_max_size = var.autoscaling_max_size

  service_account_email = var.service_account_email

  database_password = var.DATABASE_PASSWORD_STAGING
}