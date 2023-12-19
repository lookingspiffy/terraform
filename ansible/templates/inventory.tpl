%{ if inventory != null ~}
%{ for group in distinct(localdata.*.vm_group) }
[${group}]
%{ for local in localdata ~}
%{ for vm in inventory ~}
%{ if vm.name == local.vm_name ~}
%{ if local.vm_group == group ~}
${vm.name} ansible_host=${vm.default_ip_address} ansible_user=${user}
%{ endif ~}
%{ endif ~}
%{ endfor ~}
%{ endfor ~}
%{ endfor ~}

[all]
%{ for vm in inventory ~}
${vm.name} ansible_host=${vm.default_ip_address} ansible_user=${user}
%{ endfor ~}
%{ endif ~}
