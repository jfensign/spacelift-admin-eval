variable "environment_name" {}

module "environment" {
  source = "../../tml/cloud-environment"
  environment_name = var.environment_name
}

output "name" {
  value = module.environment.name
}

output "labels" {
  value = module.environment.labels
}
