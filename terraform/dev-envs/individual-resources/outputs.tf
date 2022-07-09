output "backend_update_command" {
  value       = module.main.backend_update_command
  description = "Command for running database migrations use run-task"
}

output "ecs_exec_command" {
  value = module.main.ecs_exec_command
}
