
output "name" {
  value = var.environment_name
}

output "labels" {
  value = merge(var.environment_default_labels, {
    environment_name = var.environment_name
  })
}
