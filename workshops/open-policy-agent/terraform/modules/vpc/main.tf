variable "cidr_range" {}

data "aws_vpc" "vpc" {
  cidr_block = var.cidr_range
}

data "aws_subnet_ids" "subnet_ids" {
   vpc_id = data.aws_vpc.vpc.id
}

data "aws_subnet" "subnet" {
    count = length(data.aws_subnet_ids.subnet_ids.ids)
    # subnet_ids.ids is a set, so has to be cast to a list to work with count.index
    id = tolist(data.aws_subnet_ids.subnet_ids.ids)[count.index]
}

output "vpc_id" {
  value = data.aws_vpc.vpc.id
}

output "subnet_ids" {
    value = data.aws_subnet.subnet.*.id
}