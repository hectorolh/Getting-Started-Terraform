variable "region" {
  type        = string
  description = "AWS Region to use for resources"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  type        = string
  description = "AWS VPC cidr block"
  default     = "10.0.0.0/16"
}

variable "vpc_subnet_count" {
  type        = number
  description = "Number of subnets to create"
  default     = 2

}

variable "vpc_subnets_cidr_block" {
  type        = list(string)
  description = "CIDR block for Subnets in VPC"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "ami" {
  type        = string
  description = "AWS AMI used in SSM"
  default     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

variable "instance_type" {
  type        = string
  description = "Type for EC2 Instnace"
  default     = "t2.micro"
}

variable "company" {
  type        = string
  description = "Name of the company for tag"
  default     = "Globomantics"
}

variable "project" {
  type        = string
  description = "Project name for the tag"
}

variable "billing_code" {
  type        = string
  description = "Billing code for the tag"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map a public IP address for Subnet instances"
  default     = true
}

variable "instance_count" {
  type        = number
  description = "Number of instances to create in VPC"
  default     = 2

}

variable "naming_prefix" {
  type        = string
  description = "Naming prefix for all resources"
  default     = "globoweb"
}