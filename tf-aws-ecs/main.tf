resource "aws_iam_role" "ecs_host_role" {
  name               = "ecs_host_role"
  assume_role_policy = "${file("policies/ecs-role.json")}"
}

resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  name   = "ecs_instance_role_policy"
  policy = "${file("policies/ecs-instance-role-policy.json")}"
  role   = "${aws_iam_role.ecs_host_role.id}"
}

resource "aws_iam_role" "ecs_service_role" {
  name               = "ecs_service_role"
  assume_role_policy = "${file("policies/ecs-role.json")}"
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "ecs_service_role_policy"
  policy = "${file("policies/ecs-service-role-policy.json")}"
  role   = "${aws_iam_role.ecs_service_role.id}"
}

resource "aws_iam_instance_profile" "ecs" {
  name  = "ecs-instance-profile"
  path  = "/"
  roles = ["${aws_iam_role.ecs_host_role.name}"]
}

resource "aws_ecs_cluster" "main" {
  name = "${var.ecs_name}"
}

resource "aws_launch_configuration" "ecs" {
  name                        = "${var.ecs_name}"
  image_id                    = "${var.ecs_image}"
  instance_type               = "${var.ecs_instance_type}"
  key_name                    = "${var.ssh_key}"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs.id}"
  security_groups             = ["${aws_security_group.ecs.id}"]
  iam_instance_profile        = "${aws_iam_instance_profile.ecs.name}"
  user_data                   = "#!/bin/bash\necho ECS_CLUSTER=${var.ecs_name} > /etc/ecs/ecs.config"
  associate_public_ip_address = false
}

resource "aws_autoscaling_group" "ecs" {
  name                 = "${var.ecs_name}"
  availability_zones   = ["${var.vpc_az}"]
  launch_configuration = "${aws_launch_configuration.ecs.name}"
  min_size             = "${var.asg_min_size}"
  max_size             = "${var.asg_max_size}"
  desired_capacity     = "${var.asg_desired_capacity}"
  vpc_zone_identifier  = ["${var.vpc_subnets_ecs}"]
  health_check_type    = "EC2"
}

resource "aws_elb" "ecs" {
  name = "${var.ecs_name}"

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${var.ssl_id}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
    target              = "HTTP:80/tracker/s?idsite=2"
    interval            = 30
  }

  access_logs {
    bucket        = "${var.elb_logs_bucket}"
    bucket_prefix = "${var.elb_logs_bucket_prefix}"
    interval      = 5
  }

  tags {
    Name = "${var.ecs_name}"
  }

  subnets = ["${var.vpc_subnets_elb}"]

  security_groups           = ["${aws_security_group.load_balancer.id}"]
  cross_zone_load_balancing = true
  idle_timeout              = 600
}
