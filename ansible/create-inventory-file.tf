# Relevant blocks for ansible inventory file creation.
# For the full module, please see https://github.com/lookingspiffy/terraform/tree/main/vsphere/modules/vm_deploy_environment

module "deploy_vms" {
  source             = "./modules/vm_deploy_environment"
  virtual_machines   = var.virtual_machines
  vsphere_datacenter = var.vsphere_datacenter
  vsphere_datastore  = var.vsphere_datastore
  vsphere_host       = var.vsphere_host
  vsphere_network    = var.vsphere_network

  depends_on = [module.vm_lab_folders]
}

resource "local_file" "ansible_inventory" {
  content = templatefile("./templates/inventory.tpl", {
    user      = var.ansible_user
    prefix    = "vm"
    inventory = module.deploy_vms.vm_details
    localdata = module.deploy_vms.local_vms
  })
  filename = "../ansible/inventory/inventory.yml"
}
