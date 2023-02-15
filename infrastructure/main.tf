// Provider configuration
terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 4.0"
   }
   okta = {
    source = "okta/okta"
    version = "~> 3.42"
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
    enable_deletion_protection       = true
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
        aws_security_group.lbsg.id,
    ]
    subnets                          = [
        aws_subnet.psubnet1A.id,
        aws_subnet.psubnet1B.id,
        aws_subnet.psubnet1C.id,
    ]
    tags                             = {}
    tags_all                         = {}
    # vpc_id                           = aws_vpc.mainvpc.id
    # zone_id                          = "Z215JYRZR1TBD5"

    subnet_mapping {
        subnet_id = aws_subnet.psubnet1A.id
    }
    subnet_mapping {
        subnet_id = aws_subnet.psubnet1C.id
    }
    subnet_mapping {
        subnet_id = aws_subnet.psubnet1B.id
    }

    timeouts {}
}

// Load Balancer Listener PORT:80
# aws_lb_listener.httplistener:
resource "aws_lb_listener" "httplistener" {
    # arn               = "arn:aws:elasticloadbalancing:eu-central-1:258038385982:listener/app/E-Commerce-API-LB/3512ec59392bbd34/42ed680a65762cf1"
    # id                = "arn:aws:elasticloadbalancing:eu-central-1:258038385982:listener/app/E-Commerce-API-LB/3512ec59392bbd34/42ed680a65762cf1"
    load_balancer_arn = aws_lb.applb.arn
    port              = 80
    protocol          = "HTTP"
    tags              = {}
    tags_all          = {}

    default_action {
        type = "fixed-response"

        fixed_response {
            content_type = "application/json"
            status_code = 401
            message_body = "Unauthorized"
        }
    }

    timeouts {}
}

resource "aws_lb_listener_rule" "rule_1" {
    listener_arn = aws_lb_listener.httplistener.arn

    # action {
    #     type = "authenticate-oidc"

    #     authenticate_oidc {
    #         authorization_endpoint = "${local.okta_url}/oauth2/default/authorize"
    #         token_endpoint = "${local.okta_url}/oauth2/v1/token"
    #         user_info_endpoint = "${local.okta_url}/oauth2/v1/userinfo"
    #         issuer = local.okta_issuer
    #         session_cookie_name = "RPAuthSessionCookie"
    #         session_timeout = 120
    #         scope = "openid profile"
    #         on_unauthenticated_request = "authenticate"
    #         client_id = "0oa8c0tisljhMWJaN5d7"
    #         client_secret = "F61bhlfOWphlmeqmgmK-Q3XjrMuh5b4Ezd6rq9Pm"
    #     }
    # }

    action {
        # order            = 0
        target_group_arn = aws_lb_target_group.maintg.arn
        type             = "forward"
    }

    condition {
        path_pattern {
            values = ["/test"]
        }
    }

    condition {
        host_header {
            values = ["e-commerce-api-lb-1237091546.eu-central-1.elb.amazonaws.com"]
        }
    }
}

# resource "aws_lb_listener_rule" "rule_2" {
#     listener_arn = aws_lb_listener.httplistener.arn

#     action {
#         type = "fixed-response"

#         fixed_response {
#             content_type = "application/json"
#             status_code = 200
#             # message_body = "OK"
#         }
#     }

#     condition {
#         path_pattern {
#             values = ["/test"]
#         }
#     }

#     condition {
#         host_header {
#             values = ["e-commerce-api-lb-1237091546.eu-central-1.elb.amazonaws.com"]
#         }
#     }
# }

// Load Balancer Security Group (LB-SG)
# aws_security_group.lbsg:
resource "aws_security_group" "lbsg" {
    # arn         = "arn:aws:ec2:eu-central-1:258038385982:security-group/sg-0f3b86d3720122d63"
    description = "Load Balancer Security Group"
    egress      = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
        },
    ]
    # id          = "sg-0f3b86d3720122d63"
    ingress     = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 80
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 80
        },
    ]
    name        = "LB-SG"
    # owner_id    = "258038385982"
    tags        = {}
    tags_all    = {}
    vpc_id      = aws_vpc.mainvpc.id

    timeouts {}
}

// E-Commerce-V3 VPC
# aws_vpc.mainvpc:
resource "aws_vpc" "mainvpc" {
    # arn                                  = "arn:aws:ec2:eu-central-1:258038385982:vpc/vpc-056511aa86388b615"
    assign_generated_ipv6_cidr_block     = false
    cidr_block                           = "10.0.0.0/16"
    # default_network_acl_id               = "acl-0faf9a9057a7905e9"
    # default_route_table_id               = "rtb-0816d62616c02099c"
    # default_security_group_id            = "sg-0358869d78e569e8f"
    # dhcp_options_id                      = "dopt-068f705734122c23c"
    # enable_classiclink                   = false
    # enable_classiclink_dns_support       = false
    enable_dns_hostnames                 = true
    enable_dns_support                   = true
    enable_network_address_usage_metrics = false
    # id                                   = "vpc-056511aa86388b615"
    instance_tenancy                     = "default"
    # ipv6_netmask_length                  = 0
    # main_route_table_id                  = "rtb-0816d62616c02099c"
    # owner_id                             = "258038385982"
    tags                                 = {
        "Name" = "E-Commerce-VPC"
    }
    tags_all                             = {
        "Name" = "E-Commerce-VPC"
    }
}

// Public Subnet 1A
# aws_subnet.psubnet1A:
resource "aws_subnet" "psubnet1A" {
    # arn                                            = "arn:aws:ec2:eu-central-1:258038385982:subnet/subnet-07a0226fac3e88918"
    assign_ipv6_address_on_creation                = false
    # availability_zone                              = "eu-central-1a"
    availability_zone_id                           = "euc1-az2"
    cidr_block                                     = "10.0.0.0/24"
    enable_dns64                                   = false
    enable_resource_name_dns_a_record_on_launch    = false
    enable_resource_name_dns_aaaa_record_on_launch = false
    # id                                             = "subnet-07a0226fac3e88918"
    ipv6_native                                    = false
    # map_customer_owned_ip_on_launch                = false
    map_public_ip_on_launch                        = true
    # owner_id                                       = "258038385982"
    private_dns_hostname_type_on_launch            = "ip-name"
    tags                                           = {
        "Name" = "Public-1A"
    }
    tags_all                                       = {
        "Name" = "Public-1A"
    }
    vpc_id                                         = aws_vpc.mainvpc.id

    timeouts {}
}

// Public Subnet 1B
# aws_subnet.psubnet1B:
resource "aws_subnet" "psubnet1B" {
    # arn                                            = "arn:aws:ec2:eu-central-1:258038385982:subnet/subnet-0e66d825162a93535"
    assign_ipv6_address_on_creation                = false
    # availability_zone                              = "eu-central-1b"
    availability_zone_id                           = "euc1-az3"
    cidr_block                                     = "10.0.1.0/24"
    enable_dns64                                   = false
    enable_resource_name_dns_a_record_on_launch    = false
    enable_resource_name_dns_aaaa_record_on_launch = false
    # id                                             = "subnet-0e66d825162a93535"
    ipv6_native                                    = false
    # map_customer_owned_ip_on_launch                = false
    map_public_ip_on_launch                        = true
    # owner_id                                       = "258038385982"
    private_dns_hostname_type_on_launch            = "ip-name"
    tags                                           = {
        "Name" = "Public-1B"
    }
    tags_all                                       = {
        "Name" = "Public-1B"
    }
    vpc_id                                         = aws_vpc.mainvpc.id

    timeouts {}
}

// Public Subnet 1C
# aws_subnet.psubnet1C:
resource "aws_subnet" "psubnet1C" {
    # arn                                            = "arn:aws:ec2:eu-central-1:258038385982:subnet/subnet-0e21c790b71ed90bb"
    assign_ipv6_address_on_creation                = false
    # availability_zone                              = "eu-central-1c"
    availability_zone_id                           = "euc1-az1"
    cidr_block                                     = "10.0.2.0/24"
    enable_dns64                                   = false
    enable_resource_name_dns_a_record_on_launch    = false
    enable_resource_name_dns_aaaa_record_on_launch = false
    # id                                             = "subnet-0e21c790b71ed90bb"
    ipv6_native                                    = false
    # map_customer_owned_ip_on_launch                = false
    map_public_ip_on_launch                        = true
    # owner_id                                       = "258038385982"
    private_dns_hostname_type_on_launch            = "ip-name"
    tags                                           = {
        "Name" = "Public-1C"
    }
    tags_all                                       = {
        "Name" = "Public-1C"
    }
    vpc_id                                         = aws_vpc.mainvpc.id

    timeouts {}
}

// Load Balancer Target Group (Main Server Containers)
# aws_lb_target_group.maintg:
resource "aws_lb_target_group" "maintg" {
    # arn                           = "arn:aws:elasticloadbalancing:eu-central-1:258038385982:targetgroup/E-Commerce-API-TG1/9b6da579e7e47796"
    # arn_suffix                    = "targetgroup/E-Commerce-API-TG1/9b6da579e7e47796"
    deregistration_delay          = "300"
    # id                            = "arn:aws:elasticloadbalancing:eu-central-1:258038385982:targetgroup/E-Commerce-API-TG1/9b6da579e7e47796"
    ip_address_type               = "ipv4"
    load_balancing_algorithm_type = "round_robin"
    name                          = "E-Commerce-API-TG1"
    port                          = 80
    protocol                      = "HTTP"
    protocol_version              = "HTTP1"
    slow_start                    = 0
    tags                          = {}
    tags_all                      = {}
    target_type                   = "instance"
    vpc_id                        = aws_vpc.mainvpc.id

    health_check {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
    }

    stickiness {
        cookie_duration = 86400
        enabled         = false
        type            = "lb_cookie"
    }

    # target_failover {
    #     on_deregistration = null
    #     on_unhealthy = null
    # }
}