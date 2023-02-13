// Provider configuration
terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 4.0"
   }
 }
}
 
provider "aws" {
 region = "eu-central-1"
}

// Load Balancer
# aws_lb.applb:
resource "aws_lb" "applb" {
    # arn                              = "arn:aws:elasticloadbalancing:eu-central-1:258038385982:loadbalancer/app/E-Commerce-API-LB/3512ec59392bbd34"
    # arn_suffix                       = "app/E-Commerce-API-LB/3512ec59392bbd34"
    desync_mitigation_mode           = "defensive"
    # dns_name                         = "E-Commerce-API-LB-1237091546.eu-central-1.elb.amazonaws.com"    
    drop_invalid_header_fields       = false
    enable_cross_zone_load_balancing = true
    enable_deletion_protection       = false
    enable_http2                     = true
    enable_waf_fail_open             = false
    # id                               = "arn:aws:elasticloadbalancing:eu-central-1:258038385982:loadbalancer/app/E-Commerce-API-LB/3512ec59392bbd34"
    idle_timeout                     = 60
    internal                         = false
    ip_address_type                  = "ipv4"
    load_balancer_type               = "application"
    name                             = "E-Commerce-API-LB"
    preserve_host_header             = false
    security_groups                  = [
        "sg-0f3b86d3720122d63",
    ]
    subnets                          = [
        "subnet-07a0226fac3e88918",
        "subnet-0e21c790b71ed90bb",
        "subnet-0e66d825162a93535",
    ]
    tags                             = {}
    tags_all                         = {}
    # vpc_id                           = "vpc-056511aa86388b615"
    # zone_id                          = "Z215JYRZR1TBD5"

    subnet_mapping {
        subnet_id = "subnet-07a0226fac3e88918"
    }
    subnet_mapping {
        subnet_id = "subnet-0e21c790b71ed90bb"
    }
    subnet_mapping {
        subnet_id = "subnet-0e66d825162a93535"
    }

    timeouts {}
}