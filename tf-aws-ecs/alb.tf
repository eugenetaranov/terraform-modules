resource "aws_alb" "ecs" {
  name            = "${var.ecs_name}"
  internal        = false
  security_groups = ["${aws_security_group.load_balancer.id}"]
  subnets         = ["${var.vpc_subnets_elb}"]

  enable_deletion_protection = false

  tags {
    Name = "${var.ecs_name}"
  }
}
