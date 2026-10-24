terraform {
  required_version = ">= 1.10.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.113.1, < 0.118.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = ">= 0.11.0, < 0.13.0"
    }
  }
}
