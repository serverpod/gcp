# resource "google_compute_managed_ssl_certificate" "api" {
#   name = "serverpod-${var.runmode}-api-certificate"

#   managed {
#     domains = ["api.${var.top_domain}."]
#   }
# }
