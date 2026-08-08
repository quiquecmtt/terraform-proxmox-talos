variable "image_node_name" {
  description = "Node where to download Talos image"
  type        = string
  sensitive   = false
}

variable "image_datastore_id" {
  description = <<-EOT
    Datastore holding the downloaded Talos image.

    `local` is per-node storage, so the image is only visible on
    `image_node_name`. Spreading nodes across several Proxmox hosts means
    instantiating this module once per host.
  EOT
  type        = string
  sensitive   = false
  default     = "local"
}

variable "network_bridge" {
  description = "Default bridge for node NICs. Override per node with `bridge`."
  type        = string
  sensitive   = false
  default     = "vmbr0"
}

variable "tags" {
  description = <<-EOT
    Proxmox tags applied to every node this module creates.

    Proxmox normalises tags to lowercase and sorts them, so the order given
    here is not preserved.
  EOT
  type        = list(string)
  sensitive   = false
  default     = ["terraform", "talos"]
}

variable "talos_version" {
  description = "Talos node version"
  type        = string
  sensitive   = false
  default     = "v1.12.11"
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
  description = <<-EOT
    Configuration for cluster nodes.

    Per-node `bridge` overrides the module-level `network_bridge`; `vlan_id`
    leaves the NIC untagged when unset.

    `pci_devices` passes host PCI devices through, addressed by Proxmox
    resource mapping name rather than raw PCI address, so one map can cover
    hosts where the device sits at a different address. Passthrough to a VM is
    exclusive -- a device given to a node is unavailable to the host and to
    every other guest, unlike a device bind-mounted into an LXC.
  EOT
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
    bridge         = optional(string)
    vlan_id        = optional(number)
    pci_devices = optional(list(object({
      mapping = string
      pcie    = optional(bool, true)
      rombar  = optional(bool, true)
      xvga    = optional(bool, false)
    })), [])
  }))
}
