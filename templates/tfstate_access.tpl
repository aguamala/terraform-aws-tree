
module "\"${service}_tfstate_access\"" {
    source = "\"${modules_path}terraform-aws-backend//modules/tfstate_access${modules_ref}\""

    backend_bucket = "\"\$\{data.terraform_remote_state.state.terraform_backend_bucket_id\}\""
    tfstate_path         = "\"${path}\""
    tfstate_write_users  = ["\"\$\{var.terraform_aws_profile\}\""]
    tfstate_write_roles  = []
    tfstate_write_groups = []
}


