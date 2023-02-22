resource "google_dns_record_set" "api" {
  name         = "api.${var.top_domain}."
  managed_zone = "examplepod"
  type         = "A"
  ttl          = 60
  rrdatas      = [google_compute_global_forwarding_rule.serverpod.ip_address]
}

resource "google_dns_record_set" "database" {
  name         = "database.${var.top_domain}."
  managed_zone = "examplepod"
  type         = "A"
  ttl          = 60
  rrdatas      = [google_sql_database_instance.serverpod.public_ip_address]
}

resource "google_dns_record_set" "database-private" {
  name         = "database-${var.runmode}-private.${var.top_domain}."
  managed_zone = "examplepod"
  type         = "A"
  ttl          = 60
  rrdatas      = [google_sql_database_instance.serverpod.private_ip_address]
}