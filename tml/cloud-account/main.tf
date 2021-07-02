terraform {
  required_providers {
    spacelift = {
      source = "spacelift-io/spacelift"
    }
  }
}

provider "spacelift" {}

data "spacelift_environment_variable" "tenant_name" {
  context_id = "platform-tenant-${var.tenant}"
  name       = "TENANT_NAME"
}

data "spacelift_environment_variable" "tenant_group_id" {
  context_id = "platform-tenant-${var.tenant}"
  name       = "TENANT_GROUP_ID"
}

data "spacelift_environment_variable" "environment" {
  context_id = "platform-environment-${var.environment}"
  name       = "ENVIRONMENT_NAME"
}

data "spacelift_environment_variable" "vendor" {
  context_id = "platform-vendor-${var.vendor}"
  name       = "VENDOR_NAME"
}

resource "spacelift_context" "account_context" {
  description = "Platform vendor account context"
  name        = "platform-account-${data.spacelift_environment_variable.vendor.value}-${data.spacelift_environment_variable.tenant_name.value}-${data.spacelift_environment_variable.environment.value}"
}

resource "spacelift_environment_variable" "account_id" {
  context_id = spacelift_context.account_context.id
  name       = "TF_VAR_account_id"
  value      = var.account_id
  write_only = false
}

resource "spacelift_environment_variable" "account_pwho" {
  context_id = spacelift_context.account_context.id
  name       = "TF_VAR_account_pwho"
  value      = var.account_id
  write_only = false
}

resource "spacelift_environment_variable" "account_labels" {
  context_id = spacelift_context.account_context.id
  name       = "TF_VAR_account_labels"
  value      = jsonencode({
    "account_pwho" = spacelift_environment_variable.account_pwho.value,
    "account_gid"  = data.spacelift_environment_variable.tenant_group_id.value
    "environment"  = data.spacelift_environment_variable.environment.value,
    "bu"           = data.spacelift_environment_variable.tenant_name.value,
  })
  write_only = false
}

