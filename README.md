# terraform-aws-tree module
This module will create a directory tree of AWS services, each with its own tf state file.

```hcl
module "tree" {
    source       = "github.com/aguamala/terraform-aws-tree"
    tree_path    = "./aguamala/"
    modules_path = "github.com/aguamala/"
    modules_ref  = "?ref=v1.0.3"
}
```

### usage  

    $ terraform init
    $ terraform apply

### tree

    $ cd aguamala/
    $ tree aguamala
    aguamala
    ├── compute
    │   ├── ec2
    │   │   ├── backend_config_EC2.tf
    │   │   ├── main.tf
    │   │   ├── provider.tf -> ../../provider.tf
    │   │   ├── root_variables.tf -> ../../variables.tf
    │   │   ├── terraform_remote_state_files_global.tf -> ../../terraform_remote_state_files_global.tf
    │   │   ├── terraform_remote_state_files_workspace.tf -> ../../terraform_remote_state_files_workspace.tf
    │   │   └── terraform.tfvars -> ../../terraform.tfvars
    │   └── ecs
    │       ├── backend_config_ContainerService.tf
    │       ├── main.tf
    │       ├── provider.tf -> ../../provider.tf
    │       ├── root_variables.tf -> ../../variables.tf
    │       ├── terraform_remote_state_files_global.tf -> ../../terraform_remote_state_files_global.tf
    │       ├── terraform_remote_state_files_workspace.tf -> ../../terraform_remote_state_files_workspace.tf
    │       └── terraform.tfvars -> ../../terraform.tfvars
    ├── database
    │   ├── dynamodb
    │   │   ├── backend_config_DynamoDB.tf
    │   │   ├── main.tf
    │   │   ├── provider.tf -> ../../provider.tf
    │   │   ├── root_variables.tf -> ../../variables.tf
    │   │   ├── terraform_remote_state_files_global.tf -> ../../terraform_remote_state_files_global.tf
    │   │   ├── terraform_remote_state_files_workspace.tf -> ../../terraform_remote_state_files_workspace.tf
    │   │   └── terraform.tfvars -> ../../terraform.tfvars
    │   └── rds
    │       ├── backend_config_RDS.tf
    │       ├── main.tf
    │       ├── provider.tf -> ../../provider.tf
    │       ├── root_variables.tf -> ../../variables.tf
    │       ├── terraform_remote_state_files_global.tf -> ../../terraform_remote_state_files_global.tf
    │       ├── terraform_remote_state_files_workspace.tf -> ../../terraform_remote_state_files_workspace.tf
    │       └── terraform.tfvars -> ../../terraform.tfvars
    ├── developer
    │   └── codecommit
    │       ├── backend_config_CodeCommit.tf
    │       ├── main.tf
    │       ├── provider.tf -> ../../provider.tf
    │       ├── root_variables.tf -> ../../variables.tf
    │       ├── terraform_remote_state_files_global.tf -> ../../terraform_remote_state_files_global.tf
    │       ├── terraform_remote_state_files_workspace.tf -> ../../terraform_remote_state_files_workspace.tf
    │       ├── terraform.tfvars -> ../../terraform.tfvars
    │       ├── tf
    │       │   ├── templates.tf
    │       │   └── variables.tf
    │       └── tpl
    │           └── repository.tpl
    ├── identity
    │   └── iam
    │       ├── backend_config_IAM.tf
    │       ├── main.tf
    │       ├── provider.tf -> ../../provider.tf
    │       ├── root_variables.tf -> ../../variables.tf
    │       ├── terraform_remote_state_files_global.tf -> ../../terraform_remote_state_files_global.tf
    │       ├── terraform.tfvars -> ../../terraform.tfvars
    │       └── variables.tf
    ├── main.tf
    ├── networking
    │   ├── route53
    │   │   ├── backend_config_Route53.tf
    │   │   ├── main.tf
    │   │   ├── provider.tf -> ../../provider.tf
    │   │   ├── root_variables.tf -> ../../variables.tf
    │   │   ├── terraform_remote_state_files_global.tf -> ../../terraform_remote_state_files_global.tf
    │   │   ├── terraform_remote_state_files_workspace.tf -> ../../terraform_remote_state_files_workspace.tf
    │   │   └── terraform.tfvars -> ../../terraform.tfvars
    │   └── vpc
    │       ├── backend_config_VPC.tf
    │       ├── example.tfvars
    │       ├── main.tf
    │       ├── outputs.tf
    │       ├── provider.tf -> ../../provider.tf
    │       ├── root_variables.tf -> ../../variables.tf
    │       ├── terraform_remote_state_files_global.tf -> ../../terraform_remote_state_files_global.tf
    │       ├── terraform_remote_state_files_workspace.tf -> ../../terraform_remote_state_files_workspace.tf
    │       ├── terraform.tfvars -> ../../terraform.tfvars
    │       └── variables.tf
    ├── provider.tf
    ├── storage
    │   ├── efs
    │   │   ├── backend_config_EFS.tf
    │   │   ├── main.tf
    │   │   ├── provider.tf -> ../../provider.tf
    │   │   ├── root_variables.tf -> ../../variables.tf
    │   │   ├── terraform_remote_state_files_global.tf -> ../../terraform_remote_state_files_global.tf
    │   │   ├── terraform_remote_state_files_workspace.tf -> ../../terraform_remote_state_files_workspace.tf
    │   │   └── terraform.tfvars -> ../../terraform.tfvars
    │   └── s3
    │       ├── backend_config_S3.tf
    │       ├── main.tf
    │       ├── provider.tf -> ../../provider.tf
    │       ├── root_variables.tf -> ../../variables.tf
    │       ├── terraform_remote_state_files_global.tf -> ../../terraform_remote_state_files_global.tf
    │       └── terraform.tfvars -> ../../terraform.tfvars
    ├── templates
    │   └── terraform_tfvars.tpl
    ├── terraform_backend.tf
    ├── terraform_remote_state_files_global.tf
    ├── terraform_remote_state_files_workspace.tf
    ├── terraform.tfvars
    └── variables.tf

Each directory represents a AWS service with its own tf state file configured with S3 backend using another module.
This type of configuartion is useful when you don't want to give to much access to AWS services.
Variables can be changed to use more or less services.