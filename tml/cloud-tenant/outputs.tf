
output "name" {
  value = var.tenant_name
}

output "group_id" {
  value = var.tenant_group_id
}

terraform {
  required_providers {
    spacelift = {
      source = "spacelift-io/spacelift"
    }
  }
}

provider "spacelift" {}

resource "spacelift_context" "tenant_context" {
  description = "Platform tenant context for ${var.tenant_name}"
  name        = "platform-tenant-${var.tenant_name}"
}

resource "spacelift_environment_variable" "tenant_name" {
  context_id = spacelift_context.tenant_context.id
  name       = "TENANT_NAME"
  value      = var.tenant_name
  write_only = false
}

resource "spacelift_environment_variable" "tenant_group_id" {
  context_id = spacelift_context.tenant_context.id
  name       = "TENANT_GROUP_ID"
  value      = var.tenant_group_id
  write_only = false
}
