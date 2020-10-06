
output "name" {
  value = var.tenant_name
}

output "group_id" {
  value = var.tenant_group_id
}

output "labels" {
  value = merge(var.tenant_default_labels, {
    tenant_name = var.tenant_name
    tenant_group_id = var.tenant_group_id
  })
}
