###############################################################################
# ECS
###############################################################################

module "ecs" {
  source = "../../internal/ecs"
}

###############################################################################
# S3 - TODO add S3 bucket resource for app assets
###############################################################################

module "s3" {
  source        = "../../internal/s3"
  bucket_name   = "${replace(var.domain_name, ".", "-")}-${terraform.workspace}-bucket"
  force_destroy = var.force_destroy
}


###############################################################################
# Route 53
###############################################################################

module "route53" {
  source       = "../../internal/route53"
  alb_dns_name = var.alb_dns_name
  domain_name  = var.domain_name
}

###############################################################################
# Common variables for ECS Services and Tasks
###############################################################################

locals {
  env_vars = [
    {
      name  = "REDIS_SERVICE_HOST"
      value = "${terraform.workspace}-redis.${var.shared_resources_workspace}-sd-ns"
    },
    {
      name  = "POSTGRES_SERVICE_HOST"
      value = var.rds_address
    },
    {
      name  = "POSTGRES_NAME"
      value = "${terraform.workspace}-db"
    },
    {
      name  = "DJANGO_SETTINGS_MODULE"
      value = var.django_settings_module
    },
    {
      name  = "S3_BUCKET_NAME"
      value = module.s3.bucket_name
    },
    {
      name  = "DOMAIN_NAME"
      value = var.domain_name
    }
  ]
  be_image  = "${var.ecr_be_repo_url}:${var.be_image_tag}"
  host_name = "${terraform.workspace}.${var.domain_name}"
}

###############################################################################
# Gunicorn ECS Service
###############################################################################

module "api" {
  source             = "../../internal/web"
  name               = "gunicorn"
  ecs_cluster_id     = module.ecs.cluster_id
  task_role_arn      = var.task_role_arn
  execution_role_arn = var.execution_role_arn
  ecs_sg_id          = var.ecs_sg_id
  command            = var.api_command
  env_vars           = concat(local.env_vars, var.extra_env_vars)
  image              = local.be_image
  alb_default_tg_arn = var.alb_default_tg_arn
  log_group_name     = "/ecs/${terraform.workspace}/api"
  log_stream_prefix  = "api"
  region             = var.region
  cpu                = var.api_cpu
  memory             = var.api_memory
  port               = 8000
  path_patterns      = ["/api/*", "/admin/*", "/graphql/*", "/mtv/*"]
  health_check_path  = "/api/health-check/"
  listener_arn       = var.listener_arn
  vpc_id             = var.vpc_id
  private_subnets    = var.private_subnets
  host_name          = local.host_name
}


###############################################################################
# Backend update commands
###############################################################################

module "backend_update" {
  name               = "backend_update"
  source             = "../../internal/app/prod/management_command"
  ecs_cluster_id     = module.ecs.cluster_id
  ecs_sg_id          = var.ecs_sg_id
  task_role_arn      = var.task_role_arn
  execution_role_arn = var.execution_role_arn
  command            = var.backend_update_command
  env_vars           = concat(local.env_vars, var.extra_env_vars)
  image              = local.be_image
  log_group_name     = "/ecs/${terraform.workspace}/backend_update"
  log_stream_prefix  = "backend_update"
  region             = var.region
  cpu                = var.backend_update_cpu
  memory             = var.backend_update_memory
  private_subnets    = var.private_subnets
}
