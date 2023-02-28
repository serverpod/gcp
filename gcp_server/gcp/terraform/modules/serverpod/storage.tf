resource "google_storage_bucket" "public" {
  name                        = "storage.${var.top_domain}"
  location                    = "US"
  uniform_bucket_level_access = false

  force_destroy = true

  cors {
    origin          = ["*"]
    method          = ["*"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}

resource "google_storage_bucket_access_control" "public" {
  bucket = google_storage_bucket.public.id
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket" "private" {
  name                        = "private-storage.${var.top_domain}"
  location                    = "US"
  uniform_bucket_level_access = false

  force_destroy = true

  cors {
    origin          = ["*"]
    method          = ["*"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}