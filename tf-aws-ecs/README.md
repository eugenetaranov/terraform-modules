Terraform module creating AWS ECS cluster, launch configuration and autoscaling group, iam profiles, load balancer. 

Example of usage:
```
module "ecs" {
  source               = "github.com/eugenetaranov/terraform-modules//tf-aws-ecs"
  ecs_name             = "${var.project}-${var.environment}"
  ecs_image            = "ami-40286957"
  ecs_instance_type    = "t2.small"
  ssh_key              = "ssh-key"
  vpc_az               = ["${var.vpc_az}"]
  asg_min_size         = 1
  asg_max_size         = 1
  asg_desired_capacity = 1
  vpc_id               = "${module.vpc.vpc_id}"
  vpc_subnets_ecs      = ["${module.vpc.private_subnets}"]
  vpc_subnets_elb      = ["${module.vpc.public_subnets}"]
}
```
