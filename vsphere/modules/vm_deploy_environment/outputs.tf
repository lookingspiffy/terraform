output "vm_details" {
  value = {
    for vm in vsphere_virtual_machine.vm : vm.name => vm
  }
}

output "vm_template_data" {
  value = data.vsphere_virtual_machine.template[*]
}

output "local_vms" {
  value = local.virtual_machines[*]
}

output "ipaddresses" {
  value = tomap({
    for vm in vsphere_virtual_machine.vm : vm.name => vm.default_ip_address
  })
}