resource "aws_instance" "bastion" {
  count             = "${var.bastion_count}"
  ami               = "${var.bastion_ami}"
  source_dest_check = false
  instance_type     = "${var.bastion_instance_type}"
  subnet_id         = "${element(aws_subnet.public.*.id, count.index)}"
  key_name          = "${var.ssh_key}"
  vpc_security_groups_ids   = ["${aws_security_group.bastion.id}"]

  tags {
    Name = "bastion-${count.index}"
  }
}

resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "bastion"
  vpc_id      = "${aws_vpc.mod.id}"

  tags {
    Name = "bastion"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
