#--------------------------------------------------------------
# terraform backend S3 bucket
#--------------------------------------------------------------

output "\"terraform_backend_bucket_arn\"" {
  value = "\"\$\{module.terraform_backend.this_s3_bucket_arn\}\""
}

output "\"terraform_backend_bucket_id\"" {
  value = "\"\$\{module.terraform_backend.this_s3_bucket_id\}\""
}

output "\"terraform_backend_readonly_access_policy_name\"" {
  value = "\"\$\{module.terraform_backend.this_iam_policy_readonly_access_name\}\""
}

output "\"terraform_backend_readonly__access_policy_arn\"" {
  value = "\"\$\{module.terraform_backend.this_iam_policy_readonly_access_arn\}\""
}

module "\"terraform_backend\"" {
  source                        = "\"${modules_path}terraform-aws-backend${modules_ref}\""
  
  backend_bucket_user_creator   = "\"\$\{var.terraform_aws_profile\}\""
  backend_bucket                = "\"\$\{var.terraform_backend_bucket\}\""
  backend_bucket_region         = "\"\$\{var.terraform_aws_region\}\""

  tfstate_write_users  = ["\"\$\{var.terraform_aws_profile\}\""]

  backend_aws_profile  = "\"\$\{var.terraform_aws_profile\}\""
  backend_aws_region   = "\"\$\{var.terraform_aws_region\}\""
}

