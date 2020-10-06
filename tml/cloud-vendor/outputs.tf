
output "name" {
  value = var.vendor_name
}

output "pwho" {
  value = var.vendor_pwho
}

output "labels" {
  value = {
    vendor_name = var.vendor_name
    vendor_pwho = var.vendor_pwho
  }
}
