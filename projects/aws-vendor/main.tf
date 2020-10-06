variable "vendor_pwho" {}
variable "vendor_name" {}

module "vendor" {
  source = "../../tml/cloud-vendor"
  vendor_pwho = var.vendor_pwho
  vendor_name = var.vendor_name
}

output "name" {
  value = module.vendor.name
}

output "pwho" {
  value = module.vendor.pwho
}

output "labels" {
  value = module.vendor.labels
}
