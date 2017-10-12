variable "tree_path" {
   default = "./"
}

variable "modules_path" {
  default = "github.com/aguamala/"
  #default = "/home/gabo/github.com/aguamala/"
}

variable "modules_ref" {
  default = "?ref=v0.14"

  #default = ""
}

#--------------------------------------------------------------
# Resources created in more than one workspace
#--------------------------------------------------------------
variable "workspace_services" {
  type = "list"

  default = [
    "EC2",
    "ContainerService",
    "EFS",
    "RDS",
    "DynamoDB",
    "VPC",
  ]
}

#--------------------------------------------------------------
# Resources created in the default workspace only
#--------------------------------------------------------------
variable "global_services" {
  type = "list"

  default = [
    "IAM",
    "S3",
    "CodeCommit",
    "Route53",
  ]
}

variable "service_names" {
  type = "map"

  default = {
    "IAM"              = "identity_iam"
    "EC2"              = "compute_ec2"
    "ContainerService" = "compute_ecs"
    "S3"               = "storage_s3"
    "EFS"              = "storage_efs"
    "RDS"              = "database_rds"
    "DynamoDB"         = "database_dynamodb"
    "VPC"              = "networking_vpc"
    "Route53"          = "networking_route53"
    "CodeCommit"       = "developer_codecommit"
  }
}
