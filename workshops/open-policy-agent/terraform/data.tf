module "prod" {
  source     = "./modules/vpc"
  cidr_range = "10.0.0.0/16"
}

module "default" {
  source     = "./modules/vpc"
  cidr_range = "172.31.0.0/16"
}


data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

data "aws_security_group" "prod_webserver" {
  vpc_id = module.prod.vpc_id
  
  tags = {
    Environment = "Production"
    Application = "Webserver"
  }
}

data "aws_security_group" "default" {
  vpc_id = module.prod.vpc_id
  name = "default"
}


output "good_subnets" {
    value = module.prod.subnet_ids
}

output "bad_subnets" {
    value = module.default.subnet_ids
}