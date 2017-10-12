#--------------------------------------------------------------
# config  tfstate file backend
#--------------------------------------------------------------

module "\"${service}_tfstate_config\"" {
    source = "\"${modules_path}/terraform-aws-backend//modules/tfstate_config${modules_ref}\""

    backend_bucket = "\"\$\{data.terraform_remote_state.state.terraform_backend_bucket_id\}\""
    backend_aws_profile = "\"\$\{var.terraform_aws_profile\}\""
    backend_aws_region = "\"\$\{var.terraform_aws_region\}\""
    terraform_remote_state = "\"${terraform_remote_state}\""

    tfstate_path = "\"${path}\""

}

resource "\"aws_iam_policy_attachment\"" "\"backend_access_global_service\"" {
  count       = "\"\$\{terraform.workspace == "\"default\"" ? 1 : 0\}\""
  name        = "\"TerraformBackendWriteAccess_\$\{data.terraform_remote_state.state.terraform_backend_bucket_id\}_${path_name}\""
  users       = ["\"\$\{var.terraform_aws_profile\}\""]
  roles       = []
  groups      = []
  policy_arn  = "\"\$\{module.${service}_tfstate_config.this_iam_policy_write_access_global_arn\}\""
}

resource "\"aws_iam_policy_attachment\"" "\"backend_access_workspace_service\"" {
  count       = "\"\$\{terraform.workspace != "\"default\"" ? 1 : 0\}\""
  name        = "\"TerraformBackendWriteAccess_\$\{data.terraform_remote_state.state.terraform_backend_bucket_id\}_${path_name}_\$\{terraform.workspace\}\""
  users       = ["\"\$\{var.terraform_aws_profile\}\""]
  roles       = []
  groups      = []
  policy_arn  = "\"\$\{module.${service}_tfstate_config.this_iam_policy_write_access_workspace_arn\}\""
}


