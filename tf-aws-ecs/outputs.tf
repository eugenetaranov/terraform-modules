output "ecs_security_group" {
  value = "${aws_security_group.ecs.id}"
}

output "elb_dns_name" {
  value = "${aws_elb.ecs.dns_name}"
}
