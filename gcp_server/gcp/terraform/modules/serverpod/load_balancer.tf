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

resource "google_compute_global_forwarding_rule" "serverpod" {
  name                  = "serverpod-${var.runmode}-forwarding"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.serverpod.self_link


}

resource "google_compute_target_http_proxy" "serverpod" {
  name    = "serverpod-${var.runmode}-proxy"
  url_map = google_compute_url_map.serverpod.id
  # ssl_certificates = [google_compute_managed_ssl_certificate.api.id]
}

resource "google_compute_url_map" "serverpod" {
  name            = "serverpod-${var.runmode}-balancer"
  default_service = google_compute_backend_service.serverpod.id

  # host_rule {
  #   hosts        = ["mysite.com"]
  #   path_matcher = "allpaths"
  # }

  # path_matcher {
  #   name            = "allpaths"
  #   default_service = google_compute_region_backend_service.default.id

  #   path_rule {
  #     paths   = ["/*"]
  #     service = google_compute_region_backend_service.default.id
  #   }
  # }
}

resource "google_compute_backend_service" "serverpod" {
  name     = "serverpod-${var.runmode}-backend"
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

resource "google_compute_health_check" "serverpod-balancer" {
  name               = "serverpod-${var.runmode}-health-check"
  timeout_sec        = 5
  check_interval_sec = 5

  tcp_health_check {
    port = "8080"
  }
}