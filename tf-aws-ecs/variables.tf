variable "ecs_name" {
  default = ""
}

variable "ecs_image" {
  default = ""
}

variable "ecs_instance_type" {
  default = ""
}

variable "ssh_key" {
  default = ""
}

variable "vpc_az" {
  default = []
}

variable "asg_min_size" {
  default = ""
}

variable "asg_max_size" {
  default = ""
}

variable "asg_desired_capacity" {
  default = ""
}

variable "vpc_id" {
  description = "VPC to be placed in"
  default     = ""
}

variable "ecs_sg_ingress" {
  description = "Security groups allowed to communicate with ECS nodes"
  default     = []
}

variable "vpc_subnets_ecs" {
  description = "Subnets ECS to be launched in"
  default     = []
}

variable "vpc_subnets_elb" {
  description = "Subnets ECS ELB to be launched in"
  default     = []
}

variable "ssl_id" {
  description = "ECS ELB ssl certificate id"
  default     = ""
}
