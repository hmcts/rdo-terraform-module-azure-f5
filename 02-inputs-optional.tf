variable "availability_set_id" {
  description = "ID of availability set to put the VM in"
  default     = ""
}

variable "vm_size" {
  description = "Size of the VM in azure"
  default     = "Standard_D2s_v3"
}

variable "vm_sku" {
  description = "F5 SKU to use for the image"
  default     = "f5-bigip-virtual-edition-25m-best-hourly"
}

variable "tags" {
  description = "The tags to associate with your resources."
  type        = map(string)
  default = {
    Team = "Reform-DevOps"
  }
}

