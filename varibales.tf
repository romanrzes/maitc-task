variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "eu-central-1"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the Public Subnet"
  default     = "10.0.0.0/24"
}

variable "public_subnet_cidr2" {
  description = "CIDR for the Private Subnet"
  default     = "10.0.1.0/24"
}

variable "db_type" {
  description = "Db type"
  default     = "gp2"
}
variable "db_engine" {
  description = "Db engine"
  default     = "postgres"
}
variable "db_instance" {
  description = "Db instance"
  default     = "db.t2.micro"
}

variable "postgres_port" {
  description = "Postgres Port"
  default     = 5432
}

variable "db_username" {
  description = "SSH PORT"
  default     = "postgres"
}

variable "az" {
  description = "az eu-central-1"
  default     = "eu-central-1"
}

variable "postgres_pass" {
  default = "postgres"
}

variable "cidr_block_all" {
  description = "Name of the tag value"
  default     = "0.0.0.0/0"
}
#
variable "true_value" {
  description = "True value"
  default     = "true"
}

variable "k8s_io_tag" {
  description = "True value"
  default     = "shared"
}
variable "db_storage" {
  description = "True value"
  default     = 20
}

variable "aws_vpc_name" {
  description = "Name of the vpc"
  default     = "kitten-vpc"
}

variable "aws_ig_name" {
  description = "Name of the internet gateway"
  default     = "kitten-ig"
}

variable "aws_nat_name" {
  description = "Name of the NAT"
  default     = "kitten-nat"
}

variable "pub_sub_name" {
  description = "Name of the public subnet"
  default     = "Public Subnet"
}

variable "sub_id" {
  default = "eu-central-1-public"
}
