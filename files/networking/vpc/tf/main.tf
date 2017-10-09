#--------------------------------------------------------------
#  VPC module (use with terraform workspaces)
#--------------------------------------------------------------

module "vpc" {
  source                        = "terraform-aws-modules/vpc/aws?ref=v1.0.2"
  name                          = "${var.name}"
  cidr                          = "${var.cidr}"
  enable_dns_hostnames          = "${var.enable_dns_hostnames}"
  enable_dns_support            = "${var.enable_dns_support}"
  azs                           = "${var.azs}"  
  private_subnets               = "${var.private_subnets}"
  public_subnets                = "${var.public_subnets}"
  database_subnets              = "${var.database_subnets}"
  create_database_subnet_group  = "${var.create_database_subnet_group}"
  enable_nat_gateway            = "${var.enable_nat_gateway}"
  enable_s3_endpoint            = "${var.enable_s3_endpoint}"
  tags                          = "${var.tags}"
}
