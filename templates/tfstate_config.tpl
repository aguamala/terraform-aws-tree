#--------------------------------------------------------------
# config  tfstate file backend
#--------------------------------------------------------------

module "\"${service}_tfstate_config\"" {
    source = "\"${modules_path}terraform-aws-backend//modules/tfstate_config${modules_ref}\""

    backend_bucket = "\"\$\{var.terraform_backend_bucket\}\""
    backend_aws_profile = "\"\$\{var.terraform_aws_profile\}\""
    backend_aws_region = "\"\$\{var.terraform_aws_region\}\""
    terraform_remote_state = "\"${terraform_remote_state}\""
    tfstate_path = "\"${path}\""

}

