# GoDaddy DSN module

A terraform module to create VPC and secruity groups for given region
with firewall rules for TFE 

# Dependency

- Require AWS provider initialization

See [installation](#installation) section below  for more details 

## WARNING


## Inputs

- **region** - *string* - AWS region
- **availabilityZone** - *string* - AWS availabilty zone for that region
- **tag** - *string* - tag

## non-mandatory inputs(parameters)
- **instanceTenancy** -  default = "default"
- **dnsSupport** -  default = true
- **dnsHostNames** - default = true
- **vpcCIDRblock** -  default = "10.0.0.0/16"
- **subnetCIDRblock** -  default = "10.0.1.0/24"
- **destinationCIDRblock** -  default = "0.0.0.0/0"
- **ingressCIDRblock** -  *list*  - default = ["0.0.0.0/0"]
- **mapPublicIP** - default = true

## Outputs

- **subnet_id" - *string* - AWS subnet ID

- **security_group_id" - *string* - AWS security group for the main instance 
  ( SSH access enabled )

- **elb_security_group_id" - *string* - AWS load-balancer security group ID, only
SSL ports for main TFE access opened (443) and for dashboard ( 8800 )


# Installation

- AWS provider example config: 
```terraform
provider "aws" {
  profile = "default"
  region  = YOUR_REGION
}
```
