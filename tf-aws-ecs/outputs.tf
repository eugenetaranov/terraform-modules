output "ecs_security_group" {
  value = "${aws_security_group.ecs.id}"
}

output "alb_dns_name" {
  value = "${aws_alb.ecs.dns_name}"
}
