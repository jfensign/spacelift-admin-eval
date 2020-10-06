
output "name" {
  value = var.account_name
}

output "group_name" {
  value = var.account_group_name
}

output "group_id" {
  value = var.account_group_id
}

output "pwho" {
  value = var.account_pwho
}

output "id" {
  value = var.account_id
}

output "cloud_id" {
  value = var.account_cloud_id
}

output "labels" {
  value = merge(var.account_default_labels, {
    cloud = var.account_cloud_id
    group_id = var.account_group_id
    group_name = var.account_group_name
    account_id = var.account_id
    account_pwho = var.account_pwho
    account_name = var.account_name
    sla = var.account_environment
  })
}
