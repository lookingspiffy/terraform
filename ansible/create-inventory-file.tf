resource "local_file" "ansible_inventory" {
  content = templatefile("./templates/inventory.tpl", {
    user      = var.ansible_user
    prefix    = "vm"
    inventory = module.deploy_vms.vm_details
    localdata = module.deploy_vms.local_vms
  })
  filename = "../ansible/inventory/inventory.yml"
}
