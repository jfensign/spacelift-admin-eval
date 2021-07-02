terraform {
  required_providers {
    spacelift = {
      source = "spacelift-io/spacelift"
    }
  }
}

provider "spacelift" {}


data "spacelift_environment_variable" "tenant_name" {
  context_id = "context-tenant-${var.tenant}"
  name       = "TF_VAR_tenant_name"
}

data "spacelift_environment_variable" "tenant_group_id" {
  context_id = "context-tenant-${var.tenant}"
  name       = "TF_VAR_tenant_group_id"
}

data "spacelift_environment_variable" "environment" {
  context_id = "context-environment-${var.environment}"
  name       = "TF_VAR_environment_name"
}

data "spacelift_environment_variable" "vendor" {
  context_id = "context-vendor-${var.vendor}"
  name       = "TF_VAR_vendor_name"
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
    "account_gid"  = spacelift_environment_variable.tenant_group_id.value
  })
  write_only = false
}

