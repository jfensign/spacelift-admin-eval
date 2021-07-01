provider "spacelift" {}

resource "spacelift_context" "vendor_context" {
  description = "Platform vendor context for ${var.vendor_name}"
  name        = "platform-vendor-${var.vendor_name}"
}

resource "spacelift_environment_variable" "vendor_name" {
  context_id = splacelift_context.vendor_context.id
  name       = "VENDOR_NAME"
  value      = var.vendor_name
  write_only = false
}

resource "spacelift_environment_variable" "vendor_pwho" {
  context_id = splacelift_context.vendor_context.id
  name       = "VENDOR_PWHO"
  value      = var.vendor_pwho
  write_only = false
}
