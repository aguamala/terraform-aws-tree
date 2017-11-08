
name = "example"

cidr = "172.25.0.0/16"

enable_dns_hostnames = true

enable_dns_support = true

azs = ["us-east-2a", "us-east-2b", "us-east-2c"]

private_subnets     = ["172.25.1.0/24", "172.25.2.0/24", "172.25.3.0/24"]

public_subnets      = ["172.25.11.0/24", "172.25.12.0/24", "172.25.13.0/24"]

database_subnets    = ["172.25.21.0/24", "172.25.22.0/24", "172.25.23.0/24"]

create_database_subnet_group = false

enable_nat_gateway = true

enable_s3_endpoint = true

tags = {
    Environment = "${terraform.workspace}"
    Workspace   = "${terraform.workspace}"
}


 