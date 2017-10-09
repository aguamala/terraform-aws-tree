resource "null_resource" "root_directory" {
  provisioner "local-exec" {
    command = "mkdir -p ${var.tree_path}"
  }

  provisioner "local-exec" {
    command = "touch ${var.tree_path}/terraform_remote_state_files_workspace.tf && touch ${var.tree_path}/terraform_remote_state_files_workspace.tf && touch ${var.tree_path}/terraform.tfvars && cp -p ${path.module}/files/provider.tf ${var.tree_path}/ && cp -p ${path.module}/files/templates.tf ${var.tree_path}/ && cp -p ${path.module}/files/variables.tf ${var.tree_path}/"
  }

  provisioner "local-exec" {
    command = "mkdir -p  ${var.tree_path}/templates && cp -p ${path.module}/files/*.tpl ${var.tree_path}/templates/"
  }
}

data "template_file" "terraform_backend" {
  template = "${file("${path.module}/templates/terraform_backend.tpl")}"

  vars {
    modules_path = "${var.modules_path}"
    modules_ref  = "${var.modules_ref}"
  }
}

resource "null_resource" "terraform_backend" {
  depends_on = ["null_resource.root_directory"]

  provisioner "local-exec" {
    command = "echo \"${data.template_file.terraform_backend.rendered}\" > ${var.tree_path}/module_terraform_backend.tf"
  }
}

resource "null_resource" "service_directory" {
  depends_on = ["null_resource.root_directory"]
  count      = "${length(var.services)}"

  provisioner "local-exec" {
    command = "mkdir -p ${var.tree_path}${replace(lookup(var.service_names,var.services[count.index],var.services[count.index]), "_", "/")}"
  }

  provisioner "local-exec" {
    command = "mkdir -p ${var.tree_path}${replace(lookup(var.service_names,var.services[count.index],var.services[count.index]), "_", "/")}/templates"
  }

  provisioner "local-exec" {
    command = "cp -rap ${path.module}/files/${replace(lookup(var.service_names,var.services[count.index],var.services[count.index]), "_", "/")}/tpl/*  ${var.tree_path}${replace(lookup(var.service_names,var.services[count.index],var.services[count.index]), "_", "/")}/templates/"
  }

  provisioner "local-exec" {
    command = "cp -rap ${path.module}/files/${replace(lookup(var.service_names,var.services[count.index],var.services[count.index]), "_", "/")}/tf/*  ${var.tree_path}${replace(lookup(var.service_names,var.services[count.index],var.services[count.index]), "_", "/")}/"
  }
}

data "template_file" "service_backend_config" {
  template = "${file("${path.module}/templates/tfstate_config.tpl")}"
  count    = "${length(var.global_services)}"

  vars {
    service      = "${var.global_services[count.index]}"
    path         = "${replace(lookup(var.service_names,var.global_services[count.index],var.global_services[count.index]), "_", "/")}/"
    modules_path = "${var.modules_path}"
    modules_ref  = "${var.modules_ref}"
  }
}

resource "null_resource" "service_backend_config" {
  depends_on = ["null_resource.service_directory"]
  count      = "${length(var.global_services)}"

  provisioner "local-exec" {
    command = "echo \"${data.template_file.service_backend_config.*.rendered[count.index]}\" > ${var.tree_path}${replace(lookup(var.service_names,var.global_services[count.index],var.global_services[count.index]), "_", "/")}/module_backend_config_${var.global_services[count.index]}.tf"
  }
}

resource "null_resource" "service_links" {
  depends_on = ["null_resource.service_directory"]
  count      = "${length(var.services)}"

  provisioner "local-exec" {
    command = "cd ${var.tree_path}${replace(lookup(var.service_names,var.services[count.index],var.services[count.index]), "_", "/")} && if [ ! -L terraform_remote_state_files_global.tf ]; then ln -s ${replace(replace(lookup(var.service_names,var.services[count.index],var.services[count.index]), "/([a-zA-Z]*[0-9]*)/", ".."), "_" , "/")}/terraform_remote_state_files_global.tf terraform_remote_state_files_global.tf; fi"
  }

  provisioner "local-exec" {
    command = "cd ${var.tree_path}${replace(lookup(var.service_names,var.services[count.index],var.services[count.index]), "_", "/")} && if [ ! -L root_variables.tf ]; then ln -s ${replace(replace(lookup(var.service_names,var.services[count.index],var.services[count.index]), "/([a-zA-Z]*[0-9]*)/", ".."), "_" , "/")}/variables.tf root_variables.tf; fi"
  }

  provisioner "local-exec" {
    command = "cd ${var.tree_path}${replace(lookup(var.service_names,var.services[count.index],var.services[count.index]), "_", "/")} && if [ ! -L provider.tf ]; then ln -s ${replace(replace(lookup(var.service_names,var.services[count.index],var.services[count.index]), "/([a-zA-Z]*[0-9]*)/", ".."), "_" , "/")}/provider.tf provider.tf; fi"
  }

  provisioner "local-exec" {
    command = "cd ${var.tree_path}${replace(lookup(var.service_names,var.services[count.index],var.services[count.index]), "_", "/")} && if [ ! -L terraform.tfvars ]; then ln -s ${replace(replace(lookup(var.service_names,var.services[count.index],var.services[count.index]), "/([a-zA-Z]*[0-9]*)/", ".."), "_" , "/")}/terraform.tfvars terraform.tfvars; fi"
  }
}

data "template_file" "networking_vpc_module" {
  template = "${file("${path.module}/templates/networking_vpc.tpl")}"

  vars {
    modules_path = "${var.modules_path}"
    modules_ref  = "${var.modules_ref}"
  }
}

resource "null_resource" "networking_vpc_module" {
  depends_on = ["null_resource.service_directory"]
  count      = "${length(var.global_services)}"

  provisioner "local-exec" {
    command = "echo \"${data.template_file.networking_vpc_module.rendered}\" > ${var.tree_path}networking/vpc/module.tf"
  }
}
