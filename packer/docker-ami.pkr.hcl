packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

source "amazon-ebs" "amazon_linux" {
  region                  = var.region
  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "amzn2-ami-hvm-*-x86_64-gp2"
      root-device-type    = "ebs"
    }
    owners      = ["amazon"]
    most_recent = true
  }

  instance_type               = "t2.micro"
  ssh_username                = "ec2-user"
  ami_name                    = "custom-amazon-linux-docker-{{timestamp}}"
  ssh_keypair_name            = "packer-key"
  ssh_private_key_file        = "./ssh/id_rsa"
  associate_public_ip_address = true
}

build {
  sources = ["source.amazon-ebs.amazon_linux"]

  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user"
    ]
  }

  provisioner "file" {
    source      = "./ssh/id_rsa.pub"
    destination = "/home/ec2-user/authorized_keys"
  }

  provisioner "shell" {
    inline = [
      "mkdir -p /home/ec2-user/.ssh",
      "mv /home/ec2-user/authorized_keys /home/ec2-user/.ssh/authorized_keys",
      "chown -R ec2-user:ec2-user /home/ec2-user/.ssh",
      "chmod 600 /home/ec2-user/.ssh/authorized_keys"
    ]
  }
}
