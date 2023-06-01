output "folder_parent_path" {
  description = "Parent folder for tree."
  value       = vsphere_folder.parent.path
}

# Kubernetes

output "folder_kubernetes_path" {
  description = "Kubernetes environment root folder."
  value       = vsphere_folder.kubernetes.path
}

output "folder_kubernetes_master_path" {
  description = "Kubernetes mater nodes."
  value       = vsphere_folder.kubemasters.path
}

output "folder_kubernetes_worker_path" {
  description = "Kubernetes worker nodes."
  value       = vsphere_folder.kubeworkers.path
}

# Windows

output "folder_windows_path" {
  description = "Windows VM root folder."
  value       = vsphere_folder.windows.path
}

# Linux

output "folder_linux_path" {
  description = "Linux VM root folder."
  value       = vsphere_folder.linux.path
}

# Ansible

output "folder_ansible_path" {
  description = "Ansible dev root folder."
  value       = vsphere_folder.ansibletest.path
}