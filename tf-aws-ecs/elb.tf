resource "aws_elb" "ecs" {
  name = "${var.ecs_name}"

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  /*listener {
      instance_port      = 80
      instance_protocol  = "http"
      lb_port            = 443
      lb_protocol        = "https"
      ssl_certificate_id = "${var.ssl_id}"
    }*/


  /*access_logs {
      bucket        = "${var.elb_logs_bucket}"
      bucket_prefix = "${var.elb_logs_bucket_prefix}"
      interval      = 5
    }*/

  tags {
    Name = "${var.ecs_name}"
  }
  subnets = ["${var.vpc_subnets_elb}"]
  security_groups           = ["${aws_security_group.load_balancer.id}"]
  cross_zone_load_balancing = true
  idle_timeout              = 600
}
