variable "name" {
  type        = string
  description = "Name for tags and etc"
}

variable "ami" {
  description = "AMI for the instance"
}

variable "instance_type" {
  description = "AWS Type of instance"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID"
}

variable "security_groups" {
  type        = list
  description = "List of security groups IDs"
}

variable "key_name" {
  type        = string
  description = "SSH Key ID  , stored in AWS"
}

variable "key_path" {
  description = "Local SSH key path (priavte part)"
}

