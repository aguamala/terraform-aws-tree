#--------------------------------------------------------------
# config  tfstate file backend
#--------------------------------------------------------------

module "\"${service}_tfstate_config\"" {
    source = "\"${modules_path}/terraform-aws-backend//modules/tfstate_config${modules_ref}\""

    tfstate_write_users  = ["\"\$\{var.terraform_aws_profile\}\""]
    
    tfstate_write_groups = []

    tfstate_write_roles  = []

    backend_bucket = "\"\$\{data.terraform_remote_state.state.terraform_backend_bucket_id\}\""
    backend_aws_profile = "\"\$\{var.terraform_aws_profile\}\""
    backend_aws_region = "\"\$\{var.terraform_aws_region\}\""

    tfstate_path = "\"${path}\""

    workspace = "\"\$\{terraform.workspace\}\""
}
