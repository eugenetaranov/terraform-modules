resource "aws_iam_role" "ecs_host_role" {
  name               = "ecs_host_role"
  assume_role_policy = "${path.module}/policies/ecs-role.json"
}

resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  name   = "ecs_instance_role_policy"
  policy = "${path.module}/policies/ecs-instance-role-policy.json"
  role   = "${aws_iam_role.ecs_host_role.id}"
}

resource "aws_iam_role" "ecs_service_role" {
  name               = "ecs_service_role"
  assume_role_policy = "${path.module}/ecs-role.json"
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "ecs_service_role_policy"
  policy = "${path.module}/policies/ecs-service-role-policy.json"
  role   = "${aws_iam_role.ecs_service_role.id}"
}

resource "aws_iam_instance_profile" "ecs" {
  name  = "ecs-instance-profile"
  path  = "/"
  roles = ["${aws_iam_role.ecs_host_role.name}"]
  depends_on = ["aws_iam_role.ecs_host_role", "aws_iam_role_policy.ecs_service_role_policy"]
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
