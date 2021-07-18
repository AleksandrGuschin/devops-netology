provider "aws" {
    region = "us-east-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

locals {
  dict_of_instance_types = {
    stage = "t2.micro"
    prod = "t2.small"
  }
}

locals {
  dict_of_instance_count = {
    stage = 1
    prod = 2
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

module "ec2_module" {
  source = "terraform-aws-modules/ec2-instance/aws"

  instance_count = 1

  name          = "done-with-ec2_module"
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.dict_of_instance_types[var.kvazi_workspace]
  subnet_id     = tolist(data.aws_subnet_ids.all.ids)[0]
}

  subnet_id              = "subnet-3ff45875"

  tags = {
    Terraform   = "true"
    Environment = "test-dev"
  }
}



data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
