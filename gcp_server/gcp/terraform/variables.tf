variable "project" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-c"
}

variable "autoscaling_min_size" {
  type    = number
  default = 1
}

variable "autoscaling_max_size" {
  type    = number
  default = 1
}

variable "service_account_email" {
  type    = string
  default = ""
}

variable "enable_staging" {
  type    = bool
  default = false
}

# Database

variable "DATABASE_PASSWORD_PRODUCTION" {
  description = "The production database password, you can find it in the config/passwords.yaml file."
  type        = string
}

variable "DATABASE_PASSWORD_STAGING" {
  description = "The staging database password, you can find it in the config/passwords.yaml file (no need to specify if you aren't deployning a staging environment)."
  type        = string
}