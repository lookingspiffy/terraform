variable "instance_count" {
  type    = number
  default = "1"
}

#variable "vsphere_folder_path" {
#  description = "Folder for VM storage"
#}

variable "vsphere_datacenter" {
  type = string
}

variable "vsphere_datastore" {
  type = string
}

variable "vsphere_network" {
  description = "vSphere network"
  type        = string
  default     = "VM Network"
}

variable "vsphere_vm_name_prefix" {
  description = "VM name prefix"
  type        = string
  default     = "misc_vm"
}

variable "vsphere_host" {
  description = "Cluster host"
  type        = string
}

variable "vm_disk_size" {
  description = "Size of disk in GB"
  type        = number
  default     = 25
}

variable "vm_disk_label" {
  description = "Name of disk"
  type        = string
  default     = "disk0"
}

variable "vm_thin_provisioned" {
  description = "True for thin provisioned."
  type        = bool
  default     = true
}

#variable "vm_template_name" {
#  description = "Name of the template to use."
#  type        = string
#}

variable "vm_firmware" {
  description = "Firmware type to be used for the new VM."
  type        = string
  default     = "efi"
}

# Variables for looping environment deployments

variable "virtual_machines" {
  description = "Template for constructing deployment requirements."
  type = list(object({
    vm_name          = string,
    vm_count         = number,
    vsphere_template = string,
    vsphere_folder   = string,
    vm_firmware      = string,
    vm_group         = string,
    vm_thindisk      = bool,
    vm_annotation    = string,
    vm_cpus          = number,
    vm_memorygb      = number
  }))
}
