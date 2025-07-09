output "instance_ids" {
  value = { for k, inst in aws_instance.apps : k => inst.id }
}
