output vpc_id {
  value = module.vpc.vpc_id
}
/*
output "app_ids" {
  value = aws_instance.example.*.id
}*/