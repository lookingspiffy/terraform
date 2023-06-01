# See "https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine"

# Cloning from template

terraform {
  required_version = ">=1.3.7"
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.2.0"
    }
  }
}

#=============================================
#               GATHER DATA
#=============================================

# Reference datacenters

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

# Data source for datastores

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Data source for host - Alternatively vsphere_compute_cluster

data "vsphere_host" "host" {
  name          = var.vsphere_host
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Data source for networks

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Data source for template

#data "vsphere_virtual_machine" "template" {
#  for_each = length(var.virtual_machines.*.vsphere_template)
#  name          = var.virtual_machines.*.vsphere_template[count.index]
#  datacenter_id = data.vsphere_datacenter.dc.id
#}

#data "vsphere_virtual_machine" "template" {
#  for_each = { for vm in var.virtual_machines : vm.vm_name => vm }
#  name          = lookup(each.value, "vsphere_template", null)
#  datacenter_id = data.vsphere_datacenter.dc.id
#}



#=============================================
#         DEPLOY VIRTUAL MACHINES
#=============================================

# Create local value to consolidate input object(s) and ranges into flattened array instead of lists in lists, etc.

locals {
  virtual_machines = flatten([
    for vm in var.virtual_machines : [
      for i in range(vm.vm_count) : [
        {
          vm_name          = "${vm.vm_name}${i + 1}",
          vm_key           = "${vm.vm_name}",
          vsphere_template = "${vm.vsphere_template}",
          vsphere_folder   = "${vm.vsphere_folder}",
          vm_firmware      = "${vm.vm_firmware}",
          vm_group         = "${vm.vm_group}",
          vm_thindisk      = "${vm.vm_thindisk}",
          vm_annotation    = "${vm.vm_annotation}",
          vm_cpus          = "${vm.vm_cpus}",
          vm_memorygb      = "${vm.vm_memorygb}"
        }
      ]
    ]
  ])
}

# Collect template details

data "vsphere_virtual_machine" "template" {
  for_each      = tomap({ for vm in var.virtual_machines : vm.vm_name => vm })
  name          = each.value.vsphere_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Perform deployment from flattened map

resource "vsphere_virtual_machine" "vm" {
  for_each                   = tomap({ for vm in local.virtual_machines : vm.vm_name => vm })
  name                       = each.value.vm_name
  datastore_id               = data.vsphere_datastore.datastore.id
  resource_pool_id           = data.vsphere_host.host.resource_pool_id
  num_cpus                   = each.value.vm_cpus >= 1 ? each.value.vm_cpus : 1
  memory                     = each.value.vm_memorygb >= 1 ? each.value.vm_memorygb * 1024 : 2
  folder                     = each.value.vsphere_folder
  guest_id                   = data.vsphere_virtual_machine.template[each.value.vm_key].guest_id
  scsi_type                  = data.vsphere_virtual_machine.template[each.value.vm_key].scsi_type
  firmware                   = each.value.vm_firmware != null ? each.value.vm_firmware : "efi"
  wait_for_guest_net_timeout = 5

  disk {
    size             = var.vm_disk_size
    label            = var.vm_disk_label
    thin_provisioned = each.value.vm_thindisk != null ? each.value.vm_thindisk : false
  }

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template[each.value.vm_key].id
  }
}
