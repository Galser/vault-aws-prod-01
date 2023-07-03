# Vault EC2 infra deploy for 3 nodes
# Query the latest ubuntu AMI for 20.04-amd64

# variable "instance_config" {
#   default = {
#     name_prefix = "vault"
#     size        = "t2.micro"
#     tags = {
#       terraform_managed = "true"
#       application_name  = "Vault"
#       owner             = "Andrii Guselietov"
#     }
#   }

locals {
  instances = toset([
    for i in range(1, var.no_of_instances + 1) : "${var.instance_config.name_prefix}-${i}"
  ])
}

// We need to Flatten it before using it
# locals {
#   instances = flatten(local.all_instances)
# }

# Get the AMI in region 1
data "aws_ami" "ubuntu-18_04" {
  most_recent = true
  owners      = [var.ubuntu_account_number]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

# SSH Key
module "sshkey" {
  source   = "./modules/sshkey_aws"
  name     = "${var.testname}-region1"
  key_path = "~/.ssh/id_rsa.pub"
}

# Network : AWS VPC
module "vpc" {
  source = "./modules/vpc_aws"

  vpcCIDRblock    = var.vpcCIDRblock
  subnetCIDRblock = var.subnetCIDRblock

  tag = var.tag
}

# Instances : AWS EC2
module "vault_node" {
  source          = "./modules/compute_aws"
  for_each        = local.instances
  name            = each.key
  ami             = data.aws_ami.ubuntu-18_04.id
  instance_type   = var.instance_config.instance_type
  security_groups = [module.vpc.security_group_id]
  subnet_id       = module.vpc.subnet_id
  key_name        = module.sshkey.key_id
  key_path        = "~/.ssh/id_rsa"
}
