resource "aws_security_group" "sg_allow_ssh" {
  name        = "allow-ssh"
  description = "Port 22"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "allow_ssh" {
  security_group_id = aws_security_group.sg_allow_ssh.id
  description       = "Allow Port 22"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_ssh_egress" {
  security_group_id = aws_security_group.sg_allow_ssh.id
  description       = "Allow all ip and ports outbound"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "sg_allow_web" {
  name        = "allow-web"
  description = "Allow web"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "allow_web_port_app" {
  security_group_id = aws_security_group.sg_allow_web.id
  description       = "Allow Port 8080"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8080
  to_port           = 8080

  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_security_group_rule" "allow_web_port-lb" {
  security_group_id = aws_security_group.sg_allow_web.id
  description       = "Allow Port 80"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80

  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_security_group_rule" "allow_web_egress" {
  security_group_id = aws_security_group.sg_allow_web.id
  description       = "Allow all ip and ports outbound"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
