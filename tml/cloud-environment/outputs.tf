terraform {
  required_providers {
    spacelift = {
      source = "spacelift-io/spacelift"
    }
  }
}

provider "spacelift" {}

resource "spacelift_context" "environment_context" {
  description = "Platform environment context for ${var.environment_name}"
  name        = "platform-environment-${var.environment_name}"
}

resource "spacelift_environment_variable" "environment_name" {
  context_id = spacelift_context.environment_context.id
  name       = "ENVIRONMENT"
  value      = var.environment_name
  write_only = false
}
