variable "tenant_name" {}

variable "tenant_group_id" {}

module "tenant" {
  source = "../../tml/cloud-tenant"
  tenant_name = var.tenant_name
  tenant_group_id = var.tenant_group_id
  tenant_default_labels = {}
}

output "group_id" {
  value = module.tenant.group_id
}

output "name" {
  value = module.tenant.name
}

output "labels" {
  value = module.tenant.labels
}
