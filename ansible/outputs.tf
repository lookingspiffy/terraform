# These outputs are exposed by the module deploy_vms

output "vm_details" {
  value = {
    for vm in vsphere_virtual_machine.vm : vm.name => vm
  }
}

output "local_vms" {
  value = local.virtual_machines[*]
}
