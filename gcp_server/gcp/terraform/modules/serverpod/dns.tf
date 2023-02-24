resource "google_dns_managed_zone" "private-dns" {
  name        = "serverpod-${var.runmode}-private"
  dns_name    = "private-${var.runmode}.${var.top_domain}."

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.serverpod.id
    }
  }
}

resource "google_dns_record_set" "api" {
  name         = "api.${var.top_domain}."
  managed_zone = "examplepod"
  type         = "A"
  ttl          = 60
  rrdatas      = [google_compute_global_forwarding_rule.api.ip_address]
}

resource "google_dns_record_set" "insights" {
  name         = "insights.${var.top_domain}."
  managed_zone = "examplepod"
  type         = "A"
  ttl          = 60
  rrdatas      = [google_compute_global_forwarding_rule.insights.ip_address]
}

resource "google_dns_record_set" "web" {
  name         = "${var.top_domain}."
  managed_zone = "examplepod"
  type         = "A"
  ttl          = 60
  rrdatas      = [google_compute_global_forwarding_rule.web.ip_address]
}

resource "google_dns_record_set" "database" {
  name         = "database.${var.top_domain}."
  managed_zone = "examplepod"
  type         = "A"
  ttl          = 60
  rrdatas      = [google_sql_database_instance.serverpod.public_ip_address]
}

resource "google_dns_record_set" "database-private" {
  name         = "database.private-${var.runmode}.${var.top_domain}."
  managed_zone = "serverpod-${var.runmode}-private"
  type         = "A"
  ttl          = 60
  rrdatas      = [google_sql_database_instance.serverpod.private_ip_address]
}

resource "google_dns_record_set" "redis-private" {
  name         = "redis.private-${var.runmode}.${var.top_domain}."
  managed_zone = "serverpod-${var.runmode}-private"
  type         = "A"
  ttl          = 60
  rrdatas      = [google_redis_instance.serverpod.host]
}