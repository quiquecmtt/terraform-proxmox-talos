variable "image_node_name" {
  description = "Node where to download Talos image"
  type        = string
  sensitive   = false
}

variable "talos_version" {
  description = "Talos node version"
  type        = string
  sensitive   = false
  default     = "v1.10.6"
}

variable "talos_extensions" {
  description = "Talos extensions needed in Talos nodes"
  type        = list(string)
  sensitive   = false
  default = [
    "siderolabs/iscsi-tools",
    "siderolabs/qemu-guest-agent"
  ]
}

variable "talos_extra_kernel_args" {
  description = "Talos extra kernel arguments for Talos nodes"
  type        = list(string)
  sensitive   = false
  default     = []
}

variable "talos_nodes" {
  description = "Configuration for cluster nodes"
  type = map(object({
    host_node      = string
    machine_type   = string
    datastore_id   = optional(string, "local-lvm")
    dns            = optional(list(string))
    vm_id          = number
    cpu            = number
    memory         = number
    boot_disk_size = optional(number, 20)
    ip_address     = string
    ip_gateway     = string
    ip_subnet      = number
  }))
}
