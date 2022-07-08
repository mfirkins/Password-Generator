output "migrate_command" {
  value       = "cd backend && python manage.py migrate"
  description = "Command for running database migrations use run-task"
}

output "ecs_exec_command" {
  value = module.main.ecs_exec_command
}
