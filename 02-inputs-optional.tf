variable "availability_set_id" {
  description = "ID of availability set to put the VM in"
  default     = ""
}

variable "vm_size" {
  description = "Size of the VM in azure"
  default     = "Standard_DS1_v2"
}

variable "vm_sku" {
  description = "F5 SKU to use for the image"
  default     = "f5-bigip-virtual-edition-25m-best-hourly"
}

variable "vm_disk_name" {
  description = "VM disk name"
  default     = "disk-mgmt-vpn-os"
}

variable "vm_osprofile_computer_name" {
  description = "Name of the OS profile"
  default     = "osprof-mgmt-vpn"
}
