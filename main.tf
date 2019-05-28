#Create root directory and initial terraform files
resource "null_resource" "root_directory" {
  provisioner "local-exec" {
    command = "mkdir -p ${var.tree_path}"
  }

  provisioner "local-exec" {
    command = "touch ${var.tree_path}/terraform_remote_state_files_workspace.tf && touch ${var.tree_path}/terraform_remote_state_files_global.tf && touch ${var.tree_path}/terraform.tfvars && cp -p ${path.module}/files/provider.tf ${var.tree_path}/ && cp -p ${path.module}/files/main.tf ${var.tree_path}/ && cp -p ${path.module}/files/variables.tf ${var.tree_path}/"
  }

  provisioner "local-exec" {
    command = "mkdir -p  ${var.tree_path}/templates && cp -p ${path.module}/files/*.tpl ${var.tree_path}/templates/"
  }
}

data "template_file" "terraform_backend" {
  template = "${file("${path.module}/templates/terraform_backend.tpl")}"

  vars = {
    modules_path = "${var.modules_path}"
    modules_ref  = "${var.modules_ref}"
  }
}

#create terraform backend module
resource "null_resource" "terraform_backend" {
  depends_on = ["null_resource.root_directory"]

  provisioner "local-exec" {
    command = "echo \"${data.template_file.terraform_backend.rendered}\" > ${var.tree_path}/terraform_backend.tf"
  }
}

#create services directories with more than one workspace
resource "null_resource" "workspace_service_directory" {
  depends_on = ["null_resource.root_directory"]
  count      = "${length(var.workspace_services)}"

  provisioner "local-exec" {
    command = "mkdir -p ${var.tree_path}${replace(lookup(var.service_names,var.workspace_services[count.index],var.workspace_services[count.index]), "_", "/")}"
  }
}

resource "null_resource" "workspace_service_links" {
  depends_on = ["null_resource.workspace_service_directory"]
  count      = "${length(var.workspace_services)}"

  provisioner "local-exec" {
    command = "cd ${var.tree_path}${replace(lookup(var.service_names,var.workspace_services[count.index],var.workspace_services[count.index]), "_", "/")} && if [ ! -L terraform_remote_state_files_workspace.tf ]; then ln -s ${replace(replace(lookup(var.service_names,var.workspace_services[count.index],var.workspace_services[count.index]), "/([a-zA-Z]*[0-9]*)/", ".."), "_" , "/")}/terraform_remote_state_files_workspace.tf terraform_remote_state_files_workspace.tf; fi"
  }

  provisioner "local-exec" {
    command = "cd ${var.tree_path}${replace(lookup(var.service_names,var.workspace_services[count.index],var.workspace_services[count.index]), "_", "/")} && if [ ! -L terraform_remote_state_files_global.tf ]; then ln -s ${replace(replace(lookup(var.service_names,var.workspace_services[count.index],var.workspace_services[count.index]), "/([a-zA-Z]*[0-9]*)/", ".."), "_" , "/")}/terraform_remote_state_files_global.tf terraform_remote_state_files_global.tf; fi"
  }

  provisioner "local-exec" {
    command = "cd ${var.tree_path}${replace(lookup(var.service_names,var.workspace_services[count.index],var.workspace_services[count.index]), "_", "/")} && if [ ! -L root_variables.tf ]; then ln -s ${replace(replace(lookup(var.service_names,var.workspace_services[count.index],var.workspace_services[count.index]), "/([a-zA-Z]*[0-9]*)/", ".."), "_" , "/")}/variables.tf root_variables.tf; fi"
  }

  provisioner "local-exec" {
    command = "cd ${var.tree_path}${replace(lookup(var.service_names,var.workspace_services[count.index],var.workspace_services[count.index]), "_", "/")} && if [ ! -L provider.tf ]; then ln -s ${replace(replace(lookup(var.service_names,var.workspace_services[count.index],var.workspace_services[count.index]), "/([a-zA-Z]*[0-9]*)/", ".."), "_" , "/")}/provider.tf provider.tf; fi"
  }

  provisioner "local-exec" {
    command = "cd ${var.tree_path}${replace(lookup(var.service_names,var.workspace_services[count.index],var.workspace_services[count.index]), "_", "/")} && if [ ! -L terraform.tfvars ]; then ln -s ${replace(replace(lookup(var.service_names,var.workspace_services[count.index],var.workspace_services[count.index]), "/([a-zA-Z]*[0-9]*)/", ".."), "_" , "/")}/terraform.tfvars terraform.tfvars; fi"
  }
  
}

data "template_file" "workspace_service_backend_config" {
  template = "${file("${path.module}/templates/tfstate_config.tpl")}"
  count    = "${length(var.workspace_services)}"

  vars = {
    service                             = "${var.workspace_services[count.index]}"
    path                                = "${replace(lookup(var.service_names,var.workspace_services[count.index],var.workspace_services[count.index]), "_", "/")}/"
    path_name                           = "${lookup(var.service_names,var.workspace_services[count.index],var.workspace_services[count.index])}"
    modules_path                        = "${var.modules_path}"
    modules_ref                         = "${var.modules_ref}"
    terraform_remote_state              = "workspace"

  }
}

resource "null_resource" "workspace_service_backend_config" {
  depends_on = ["null_resource.workspace_service_directory"]
  count      = "${length(var.workspace_services)}"

  provisioner "local-exec" {
    command = "echo \"${data.template_file.workspace_service_backend_config.*.rendered[count.index]}\" > ${var.tree_path}${replace(lookup(var.service_names,var.workspace_services[count.index],var.workspace_services[count.index]), "_", "/")}/backend_config_${var.workspace_services[count.index]}.tf"
  }
}


#create services directories for global services
resource "null_resource" "global_service_directory" {
  depends_on = ["null_resource.root_directory"]
  count      = "${length(var.global_services)}"

  provisioner "local-exec" {
    command = "mkdir -p ${var.tree_path}${replace(lookup(var.service_names,var.global_services[count.index],var.global_services[count.index]), "_", "/")}"
  }
}

resource "null_resource" "global_service_links" {
  depends_on = ["null_resource.global_service_directory"]
  count      = "${length(var.global_services)}"

  provisioner "local-exec" {
    command = "cd ${var.tree_path}${replace(lookup(var.service_names,var.global_services[count.index],var.global_services[count.index]), "_", "/")} && if [ ! -L terraform_remote_state_files_global.tf ]; then ln -s ${replace(replace(lookup(var.service_names,var.global_services[count.index],var.global_services[count.index]), "/([a-zA-Z]*[0-9]*)/", ".."), "_" , "/")}/terraform_remote_state_files_global.tf terraform_remote_state_files_global.tf; fi"
  }

  provisioner "local-exec" {
    command = "cd ${var.tree_path}${replace(lookup(var.service_names,var.global_services[count.index],var.global_services[count.index]), "_", "/")} && if [ ! -L root_variables.tf ]; then ln -s ${replace(replace(lookup(var.service_names,var.global_services[count.index],var.global_services[count.index]), "/([a-zA-Z]*[0-9]*)/", ".."), "_" , "/")}/variables.tf root_variables.tf; fi"
  }

  provisioner "local-exec" {
    command = "cd ${var.tree_path}${replace(lookup(var.service_names,var.global_services[count.index],var.global_services[count.index]), "_", "/")} && if [ ! -L provider.tf ]; then ln -s ${replace(replace(lookup(var.service_names,var.global_services[count.index],var.global_services[count.index]), "/([a-zA-Z]*[0-9]*)/", ".."), "_" , "/")}/provider.tf provider.tf; fi"
  }

  provisioner "local-exec" {
    command = "cd ${var.tree_path}${replace(lookup(var.service_names,var.global_services[count.index],var.global_services[count.index]), "_", "/")} && if [ ! -L terraform.tfvars ]; then ln -s ${replace(replace(lookup(var.service_names,var.global_services[count.index],var.global_services[count.index]), "/([a-zA-Z]*[0-9]*)/", ".."), "_" , "/")}/terraform.tfvars terraform.tfvars; fi"
  }
}

data "template_file" "global_service_backend_config" {
  template = "${file("${path.module}/templates/tfstate_config.tpl")}"
  count    = "${length(var.global_services)}"

  vars = {
    service                             = "${var.global_services[count.index]}"
    path                                = "${replace(lookup(var.service_names,var.global_services[count.index],var.global_services[count.index]), "_", "/")}/"
    path_name                           = "${lookup(var.service_names,var.workspace_services[count.index],var.workspace_services[count.index])}"
    modules_path                        = "${var.modules_path}"
    modules_ref                         = "${var.modules_ref}"
    terraform_remote_state              = "global"
  }
}

resource "null_resource" "global_service_backend_config" {
  depends_on = ["null_resource.global_service_directory"]
  count      = "${length(var.global_services)}"

  provisioner "local-exec" {
    command = "echo \"${data.template_file.global_service_backend_config.*.rendered[count.index]}\" > ${var.tree_path}${replace(lookup(var.service_names,var.global_services[count.index],var.global_services[count.index]), "_", "/")}/backend_config_${var.global_services[count.index]}.tf"
  }
}

#modules
#FIXME: provisioner for each tf file main, variables outputs check if already exists
resource "null_resource" "global_services_module_templates" {
  depends_on = ["null_resource.global_service_directory"]
  count      = "${length(var.global_services)}"

  provisioner "local-exec" {
    command = "cp -rap ${path.module}/files/${replace(lookup(var.service_names,var.global_services[count.index],var.global_services[count.index]), "_", "/")}/*  ${var.tree_path}${replace(lookup(var.service_names,var.global_services[count.index],var.global_services[count.index]), "_", "/")}/"
  }
}

resource "null_resource" "workspace_services_module_templates" {
  depends_on = ["null_resource.workspace_service_directory"]
  count      = "${length(var.workspace_services)}"

  provisioner "local-exec" {
    command = "cp -rap ${path.module}/files/${replace(lookup(var.service_names,var.workspace_services[count.index],var.workspace_services[count.index]), "_", "/")}/*  ${var.tree_path}${replace(lookup(var.service_names,var.workspace_services[count.index],var.workspace_services[count.index]), "_", "/")}/"
  }
}
