################################################
# Variables read from terraform_remote_state
#
# https://registry.terraform.io/modules/briancaffey/ad-hoc-environments/aws/latest
#
# https://github.com/briancaffey/terraform-aws-ad-hoc-environments
#
# Shared resources
#################################################

variable "shared_resources_workspace" {
  type = string
}

# VPC

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

# Security Groups

variable "ecs_sg_id" {
  type        = string
  description = "ECS Security Group ID"
}

# Load balancer

variable "listener_arn" {
  type = string
}

variable "alb_dns_name" {
  type        = string
  description = "DNS name of the shared ALB"
}

# Service Discovery

variable "service_discovery_namespace_id" {
  type = string
}

# IAM

variable "task_role_arn" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

# RDS

variable "rds_address" {
  type = string
}

# alb_default_tg_arn
variable "alb_default_tg_arn" {
  type        = string
  description = "default target group ARN"
}


##############################################################################
# AWS
##############################################################################

variable "region" {
  default = "us-east-1"
}


################################################
# Per-environment variables
#
# These variables can be accept custom values
# per ad hoc environment
#################################################

# Application

##############################################################################
# Route 53
##############################################################################

variable "domain_name" {
  description = "Domain name to be used for Route 53 records (e.g. example.com)"
  type        = string
}

variable "ecr_be_repo_url" {
  description = "URL of the ECR repository that contains the backend image. Take from output value of bootstrap"
}

variable "be_image_tag" {
  description = "Image tag to use in backend container definitions"
  default     = "latest"
}


##############################################################################
# Application Services - Gunicorn, Celery, Beat, frontend SPA, etc.
##############################################################################

# Shared

variable "extra_env_vars" {
  description = "User-defined environment variables to pass to the backend service and task containers (api, worker, migrate, etc.)"
  type        = list(object({ name = string, value = string }))
  default     = []
}

variable "s3_bucket_name" {
  default     = "s3-bucket-dev"
  description = "S3 bucket name for backend assets (media and static assets)"
}

variable "django_settings_module" {
  description = "Django settings module"
  default     = "backend.settings.production"
}


# api

variable "api_command" {
  description = "Command used to start backend API container"
  default     = ["gunicorn", "-t", "1000", "-b", "0.0.0.0:8000", "--log-level", "info", "password_generator.wsgi"]
  type        = list(string)
}

variable "api_cpu" {
  default     = 1024
  description = "CPU to allocate to container"
  type        = number
}

variable "api_memory" {
  default     = 2048
  description = "Amount (in MiB) of memory used by the task"
  type        = number
}

# backend_update commands (migrate, collectstatic)

variable "backend_update_command" {
  description = "Command used to run database migrations and collectstatic"
  default     = ["python", "manage.py", "migrate"]
  type        = list(string)
}

variable "backend_update_cpu" {
  default     = 1024
  description = "CPU to allocate to container"
  type        = number
}

variable "backend_update_memory" {
  default     = 2048
  description = "Amount (in MiB) of memory used by the task"
  type        = number
}

##############################################################################
# S3
##############################################################################

variable "force_destroy" {
  description = "Force destroy of S3 bucket"
  default     = true
  type        = bool
}
