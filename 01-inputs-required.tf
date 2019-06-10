variable "rg_name" {
  description = "Resource group to create the vm in"
}

variable "vm_name" {
  description = "Name of the virtual machine in azure"
}

variable "subnet_mgmt_id" {
  description = "ID of the management subnet"
}

variable "subnet_vip_id" {
  description = "ID of the Loadbalancer subnet"
}

variable "vm_username" {
  description = "Username to use for the appliance"
}

variable "vm_password" {
  description                         = "Password to use for the appliance"
}

variable "nic_vip_id" {
  description                         = "ID of the NIC to be used for vip access"
}

variable "ssh_public_key" {
  description                         = "SSH Public Key to access host"
}

variable "selfip_private_ip" {
  description                         = "Needs to be the F5 IP Address"
}

variable "selfip_subnet" {
  description                         = "Subnet for the F5 IP Address"
}