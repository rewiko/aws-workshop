resource "aws_launch_template" "template" {
  name                   = "workshop-ec2-template"
  image_id               = data.aws_ami.ubuntu_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = ["${aws_security_group.sg_allow_ssh.id}", "${aws_security_group.sg_allow_web.id}"]
  ebs_optimized          = false #t2.micro doesn't support
  update_default_version = true
  user_data              = filebase64("run.sh")
  key_name               = aws_key_pair.generated_key[0].key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.app.name
  }

  # block_device_mappings {
  #   device_name = "/dev/sda1"

  #   ebs {
  #     volume_size           = 12
  #     delete_on_termination = true
  #     volume_type           = "gp2"
  #   }
  # }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "workshop-ec2-template"
    }
  }
}

resource "tls_private_key" "algorithm" {
  count     = var.ec2_key_enabled ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  count      = var.ec2_key_enabled ? 1 : 0
  key_name   = "our-ssh-key"
  public_key = tls_private_key.algorithm[0].public_key_openssh
}
