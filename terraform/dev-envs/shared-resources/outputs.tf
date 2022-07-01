# VPC

output "vpc_id" {
  value = module.ad-hoc-environments.vpc_id
}

output "private_subnets" {
  value = module.ad-hoc-environments.private_subnets
}

output "public_subnets" {
  value = module.ad-hoc-environments.public_subnets
}

# Security groups

output "ecs_sg_id" {
  value = module.ad-hoc-environments.ecs_sg_id
}

# Load balancer

output "listener_arn" {
  value = module.ad-hoc-environments.listener_arn
}

output "alb_default_tg_arn" {
  value = module.ad-hoc-environments.alb_default_tg_arn
}

output "alb_dns_name" {
  value = module.ad-hoc-environments.alb_dns_name
}

# Service Discovery

output "service_discovery_namespace_id" {
  value = module.ad-hoc-environments.service_discovery_namespace_id
}

# IAM

output "task_role_arn" {
  value = module.ad-hoc-environments.task_role_arn
}

output "execution_role_arn" {
  value = module.ad-hoc-environments.execution_role_arn
}

# RDS

output "rds_address" {
  value       = module.ad-hoc-environments.rds_address
  description = "address of the RDS instance"
}

# Bastion

output "bastion_public_ip" {
  value       = module.ad-hoc-environments.bastion_public_ip
  description = "bastion host public ip"
}

output "ssh_command" {
  value = module.ad-hoc-environments.ssh_command
}
