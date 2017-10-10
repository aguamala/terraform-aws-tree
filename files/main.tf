#--------------------------------------------------------------
# Create terraform.tfvars
#--------------------------------------------------------------
resource "null_resource" "terraform_tfvars" {
  provisioner "local-exec" {
    command = "echo \"${data.template_file.terraform_tfvars.rendered}\" > terraform.tfvars"
  }
}

data "template_file" "terraform_tfvars" {
  template = "${file("templates/terraform_tfvars.tpl")}"

  vars {
    terraform_tfvars_region         = "${var.terraform_aws_region}"
    terraform_tfvars_profile        = "${var.terraform_aws_profile}"
    terraform_tfvars_backend_bucket = "${var.terraform_backend_bucket}"
  }
}
