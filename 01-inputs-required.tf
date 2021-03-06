variable "rg_name" {
  description                             = "Resource group to create the vm in"
}

variable "vm_name" {
  description                             = "Name of the virtual machine in azure"
}

variable "subnet_mgmt_id" {
  description                             = "ID of the management subnet"
}

variable "vm_username" {
  description                             = "Username to use for the appliance"
}

variable "vm_password" {
  description                             = "Password to use for the appliance"
}

variable "nic_vip_id" {
  description                             = "ID of the NIC to be used for vip access"
}

variable "selfip_private_ip" {
  description                             = "Needs to be the F5 IP Address"
}

variable "selfip_subnet" {
  description                             = "Subnet for the F5 IP Address"
}

variable "as3_username" {
  description                             = "Name of F5 AS3 user"  
}

variable "as3_password" {
  description                             = "F5 AS3 user password"  
}

variable "environment" {
  description                             = "Environment like sbox / nonprod and prod"
}

variable "backend_storage_account_name" {
  description                             = "Storage Account Name"
}

variable "arm_client_id" { }
variable "arm_client_secret" { }
variable "arm_tenant_id" { }

variable "subscription_id" { }