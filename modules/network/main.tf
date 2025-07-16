# modules/network/main.tf
variable "vpc_cidr" { type = string }
variable "public_subnet_cidrs" { type = list(string) }
variable "private_subnet_cidrs" { type = list(string) }

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  tags = { Name = "${var.env}-vpc" }
}

resource "aws_subnet" "public" {
  for_each                = toset(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  map_public_ip_on_launch = true
  tags = { Name = "${var.env}-public-${each.key}" }
}

resource "aws_subnet" "private" {
  for_each = toset(var.private_subnet_cidrs)
  vpc_id   = aws_vpc.this.id
  cidr_block = each.value
  tags = { Name = "${var.env}-private-${each.key}" }
}
