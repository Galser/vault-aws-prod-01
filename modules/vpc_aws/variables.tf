# parameters for the vpc_aws module
# you MNEED to specify at least
# region and availabilityZone

variable "tag" {}

variable "instanceTenancy" {
  default = "default"
}

variable "dnsSupport" {
  default = true
}

variable "dnsHostNames" {
  default = true
}
variable "vpcCIDRblock" {
  default = ""
}
variable "subnetCIDRblock" {
  default = "10.0.0.0/16"
}
variable "destinationCIDRblock" {
  default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
  type    = list
  default = ["0.0.0.0/0"]
}
variable "mapPublicIP" {
  default = true
}
