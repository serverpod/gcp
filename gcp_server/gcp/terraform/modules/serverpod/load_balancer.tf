# resource "google_compute_global_forwarding_rule" "serverpod" {
#   name                  = "serverpod-${var.runmode}-forwarding"
#   ip_protocol           = "TCP"
#   load_balancing_scheme = "EXTERNAL"
#   port_range            = "443"
#   target                = google_compute_target_https_proxy.serverpod.self_link
# }

# resource "google_compute_target_https_proxy" "serverpod" {
#   name    = "serverpod-${var.runmode}-proxy"
#   url_map = google_compute_url_map.serverpod.id
#   ssl_certificates = [google_compute_managed_ssl_certificate.api.id]
# }

resource "google_compute_global_forwarding_rule" "api" {
  name                  = "serverpod-${var.runmode}-api"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.api.self_link
}

resource "google_compute_target_http_proxy" "api" {
  name    = "serverpod-${var.runmode}-proxy-api"
  url_map = google_compute_url_map.serverpod.id
  # ssl_certificates = [google_compute_managed_ssl_certificate.api.id]
}

resource "google_compute_global_forwarding_rule" "insights" {
  name                  = "serverpod-${var.runmode}-insights"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.api.self_link
}

resource "google_compute_target_http_proxy" "insights" {
  name    = "serverpod-${var.runmode}-proxy-insights"
  url_map = google_compute_url_map.serverpod.id
  # ssl_certificates = [google_compute_managed_ssl_certificate.api.id]
}

resource "google_compute_global_forwarding_rule" "web" {
  name                  = "serverpod-${var.runmode}-web"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.api.self_link
}

resource "google_compute_target_http_proxy" "web" {
  name    = "serverpod-${var.runmode}-proxy-web"
  url_map = google_compute_url_map.serverpod.id
  # ssl_certificates = [google_compute_managed_ssl_certificate.api.id]
}

resource "google_compute_global_forwarding_rule" "storage" {
  name                  = "serverpod-${var.runmode}-storage"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.storage.self_link
}

resource "google_compute_target_http_proxy" "storage" {
  name    = "serverpod-${var.runmode}-proxy-storage"
  url_map = google_compute_url_map.serverpod.id
  # ssl_certificates = [google_compute_managed_ssl_certificate.api.id]
}

resource "google_compute_url_map" "serverpod" {
  name            = "serverpod-${var.runmode}-balancer"
  default_service = google_compute_backend_service.web.id

  host_rule {
    hosts        = ["api.${var.top_domain}"]
    path_matcher = "api"
  }

  path_matcher {
    name            = "api"
    default_service = google_compute_backend_service.api.id
  }

  host_rule {
    hosts        = ["insights.${var.top_domain}"]
    path_matcher = "insights"
  }

  path_matcher {
    name            = "insights"
    default_service = google_compute_backend_service.insights.id
  }

  host_rule {
    hosts        = ["storage.${var.top_domain}"]
    path_matcher = "storage"
  }

  path_matcher {
    name            = "storage"
    default_service = google_compute_backend_bucket.storage.id
  }
}

resource "google_compute_backend_service" "api" {
  name     = "serverpod-${var.runmode}-backend-api"
  protocol = "HTTP"

  backend {
    group           = google_compute_instance_group_manager.serverpod.instance_group
    balancing_mode  = "UTILIZATION"
    max_utilization = 1.0
    capacity_scaler = 1.0
  }

  health_checks = [google_compute_health_check.serverpod-balancer.id]

  port_name = "api"
}

resource "google_compute_backend_service" "insights" {
  name     = "serverpod-${var.runmode}-backend-insights"
  protocol = "HTTP"

  backend {
    group           = google_compute_instance_group_manager.serverpod.instance_group
    balancing_mode  = "UTILIZATION"
    max_utilization = 1.0
    capacity_scaler = 1.0
  }

  health_checks = [google_compute_health_check.serverpod-balancer.id]

  port_name = "insights"
}

resource "google_compute_backend_service" "web" {
  name     = "serverpod-${var.runmode}-backend-web"
  protocol = "HTTP"

  backend {
    group           = google_compute_instance_group_manager.serverpod.instance_group
    balancing_mode  = "UTILIZATION"
    max_utilization = 1.0
    capacity_scaler = 1.0
  }

  health_checks = [google_compute_health_check.serverpod-balancer.id]

  port_name = "web"
}

resource "google_compute_backend_bucket" "storage" {
  name        = "serverpod-${var.runmode}-backend-storage"
  bucket_name = google_storage_bucket.public.name
  enable_cdn  = false
}

resource "google_compute_health_check" "serverpod-balancer" {
  name               = "serverpod-${var.runmode}-health-check"
  timeout_sec        = 5
  check_interval_sec = 5

  tcp_health_check {
    port = "8080"
  }
}