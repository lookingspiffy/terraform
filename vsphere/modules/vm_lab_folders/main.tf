data "vsphere_datacenter" "dc" {
  name = var.dc
}

# Parent Folder
resource "vsphere_folder" "parent" {
  path          = var.parent_folder
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Child Folder(s)

resource "vsphere_folder" "kubernetes" {
  path          = "${vsphere_folder.parent.path}/Kubernetes"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "ansibletest" {
  path          = "${vsphere_folder.parent.path}/AnsibleTest"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "windows" {
  path          = "${vsphere_folder.parent.path}/Windows"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "linux" {
  path          = "${vsphere_folder.parent.path}/Linux"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Grandchild Folder(s)

resource "vsphere_folder" "kubemanager" {
  path          = "${vsphere_folder.kubernetes.path}/KubeManager"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "kubemasters" {
  path          = "${vsphere_folder.kubernetes.path}/KubeMasters"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "kubeworkers" {
  path          = "${vsphere_folder.kubernetes.path}/KubeWorkers"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}
