variable "runmode" {
  type    = string
  default = "production"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-c"
}

variable "top_domain" {
  type = string
}

variable "autoscaling_min_size" {
  default = 1
}

variable "autoscaling_max_size" {
  default = 2
}

variable "service_account_email" {
  type    = string
  default = ""
}

variable "autoscaling_cpu_utilization" {
  type    = number
  default = 0.6
}

variable "machine_type" {
  type    = string
  default = "e2-micro"
}

variable "database_password" {
    type = string
}