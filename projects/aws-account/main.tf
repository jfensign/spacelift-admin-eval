terraform {
  backend "local" {}
}

data "terraform_remote_state" "tenant" {
  backend = "local"
  config = {
    path = "../aws-tenant/terraform.tfstate"
  }
}

data "terraform_remote_state" "vendor" {
  backend = "local"
  config = {
    path = "../aws-vendor/terraform.tfstate"
  }
}

data "terraform_remote_state" "environment" {
  backend = "local"
  workspace = var.account_environment
  config = {
    workspace_dir = "../aws-environment/terraform.tfstate.d/"
  }
}

variable "account_id" {}

variable "account_pwho" {}

variable "account_environment" {}

module "account" {
  source = "../../tml/cloud-account"
  account_name = "${data.terraform_remote_state.tenant.outputs.name}-${data.terraform_remote_state.environment.outputs.name}"
  account_pwho = var.account_pwho
  account_environment = data.terraform_remote_state.environment.outputs.name
  account_group_id = data.terraform_remote_state.tenant.outputs.group_id
  account_group_name = data.terraform_remote_state.tenant.outputs.name
  account_cloud_id = data.terraform_remote_state.vendor.outputs.name
  account_id = var.account_id
  account_default_labels = merge(
    data.terraform_remote_state.vendor.outputs.labels,
    data.terraform_remote_state.tenant.outputs.labels
  )
}

output "labels" {
  value = module.account.labels
}
