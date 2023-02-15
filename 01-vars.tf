variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "azs" {
  type = list(string)
  default = ["eu-west-1a",
    "eu-west-1b",
  "eu-west-1c"]
}

variable "subnets-ips" {
  type = list(string)
  default = ["10.0.1.0/24",
    "10.0.3.0/24",
  "10.0.5.0/24"]
}

# variable "AMI" {
#   type    = string
#   default = "ami-06d94a781b544c133"
# }

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ec2_key_enabled" {
  type    = bool
  default = true
}


