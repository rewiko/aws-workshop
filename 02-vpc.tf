resource "aws_vpc" "vpc" {
  cidr_block = var.cidr

  tags = {
    Name = "workshop-vpc"
  }
}
