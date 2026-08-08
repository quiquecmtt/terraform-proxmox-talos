data "talos_image_factory_extensions_versions" "this" {
  talos_version = var.talos_version
  filters = {
    names = var.talos_extensions
  }
}

resource "talos_image_factory_schematic" "this" {
  schematic = yamlencode(
    {
      customization = {
        extraKernelArgs = var.talos_extra_kernel_args
        systemExtensions = {
          officialExtensions = data.talos_image_factory_extensions_versions.this.extensions_info[*].name
        }
      }
    }
  )
}

# Renamed from proxmox_virtual_environment_download_file, which the provider
# deprecated and removes in v1.0. Same underlying resource; the moved block
# below keeps existing state rather than proposing a destroy and re-download.
moved {
  from = proxmox_virtual_environment_download_file.talos_image
  to   = proxmox_download_file.talos_image
}

resource "proxmox_download_file" "talos_image" {
  content_type            = "iso"
  datastore_id            = var.image_datastore_id
  file_name               = "talos-nocloud-${substr(talos_image_factory_schematic.this.id, 0, 7)}.img"
  node_name               = var.image_node_name
  url                     = "https://factory.talos.dev/image/${talos_image_factory_schematic.this.id}/${var.talos_version}/nocloud-amd64.raw.gz"
  decompression_algorithm = "gz"

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "proxmox_virtual_environment_vm" "talos_vms" {
  for_each = var.talos_nodes

  node_name       = each.value.host_node
  stop_on_destroy = true

  name        = each.key
  description = "Managed by Terraform"
  tags        = var.tags
  on_boot     = true
  vm_id       = each.value.vm_id

  scsi_hardware = "virtio-scsi-single"

  agent {
    enabled = true
  }

  cpu {
    cores = each.value.cpu
    type  = "host"
  }

  memory {
    dedicated = each.value.memory
    floating  = each.value.memory # set equal to dedicated to enable ballooning
  }

  network_device {
    bridge  = coalesce(each.value.bridge, var.network_bridge)
    vlan_id = each.value.vlan_id
  }

  disk {
    datastore_id = each.value.datastore_id
    interface    = "scsi0"
    iothread     = true
    discard      = "on"
    ssd          = true
    size         = each.value.boot_disk_size
    file_id      = proxmox_download_file.talos_image.id
  }

  boot_order = ["scsi0"]

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 6.X.
  }

  initialization {
    datastore_id = each.value.datastore_id

    # Optional DNS Block.  Update Nodes with a list value to use.
    dynamic "dns" {
      for_each = try(each.value.dns, null) != null ? { "enabled" = each.value.dns } : {}
      content {
        servers = each.value.dns
      }
    }

    ip_config {
      ipv4 {
        address = "${each.value.ip_address}/${each.value.ip_subnet}"
        gateway = each.value.ip_gateway
      }
    }
  }

  # PCI passthrough, addressed by Proxmox resource mapping rather than raw PCI
  # address so one node map can cover hosts where the device sits elsewhere.
  #
  # `device` must be hostpci0, hostpci1, ... so it is derived from list order.
  # Reordering pci_devices therefore renumbers the slots, which Proxmox treats
  # as a hardware change: expect a stop/start of the node.
  dynamic "hostpci" {
    for_each = { for idx, dev in each.value.pci_devices : idx => dev }
    content {
      device  = "hostpci${hostpci.key}"
      mapping = hostpci.value.mapping
      pcie    = hostpci.value.pcie
      rombar  = hostpci.value.rombar
      xvga    = hostpci.value.xvga
    }
  }
}
