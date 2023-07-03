variable "region" {
  default = "eu-central-1"
}

variable "no_of_instances" {
  default = 3
}

variable "instance_config" {
  default = {
    name_prefix   = "vault"
    instance_type = "t2.micro"
    tags = {
      terraform_managed = "true"
      application_name  = "Vault"
      owner             = "Andrii Guselietov"
    }
  }
}

variable "vpcCIDRblock" {
  default = "10.1.0.0/16"
}

variable "subnetCIDRblock" {
  default = "10.1.0.0/24"
}

variable "ubuntu_account_number" {
  default = "099720109477"
}

variable "testname" {
  default = "agtest"
}


variable "tag" {
  description = "Short tag"
  default     = "ag_vault_test"
}
