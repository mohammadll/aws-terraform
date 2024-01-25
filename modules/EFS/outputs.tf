output "az_names" {
  value = data.aws_availability_zones.available_zones.names
}

output "default_vpc" {
  value = data.aws_vpc.default_vpc.id
}

output "subnets_ids" {
  value = data.aws_subnets.subnets_ids.ids
}
