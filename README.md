# Terraform Proxmox Talos
Terraform module to create Talos VMs in Proxmox VE.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 0.111.1 |
| <a name="requirement_talos"></a> [talos](#requirement\_talos) | 0.11.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 0.111.1 |
| <a name="provider_talos"></a> [talos](#provider\_talos) | 0.11.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_download_file.talos_image](https://registry.terraform.io/providers/bpg/proxmox/0.111.1/docs/resources/download_file) | resource |
| [proxmox_virtual_environment_vm.talos_vms](https://registry.terraform.io/providers/bpg/proxmox/0.111.1/docs/resources/virtual_environment_vm) | resource |
| [talos_image_factory_schematic.this](https://registry.terraform.io/providers/siderolabs/talos/0.11.0/docs/resources/image_factory_schematic) | resource |
| [talos_image_factory_extensions_versions.this](https://registry.terraform.io/providers/siderolabs/talos/0.11.0/docs/data-sources/image_factory_extensions_versions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_image_datastore_id"></a> [image\_datastore\_id](#input\_image\_datastore\_id) | Datastore holding the downloaded Talos image.<br/><br/>`local` is per-node storage, so the image is only visible on<br/>`image_node_name`. Spreading nodes across several Proxmox hosts means<br/>instantiating this module once per host. | `string` | `"local"` | no |
| <a name="input_image_node_name"></a> [image\_node\_name](#input\_image\_node\_name) | Node where to download Talos image | `string` | n/a | yes |
| <a name="input_network_bridge"></a> [network\_bridge](#input\_network\_bridge) | Default bridge for node NICs. Override per node with `bridge`. | `string` | `"vmbr0"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Proxmox tags applied to every node this module creates.<br/><br/>Proxmox normalises tags to lowercase and sorts them, so the order given<br/>here is not preserved. | `list(string)` | <pre>[<br/>  "terraform",<br/>  "talos"<br/>]</pre> | no |
| <a name="input_talos_extensions"></a> [talos\_extensions](#input\_talos\_extensions) | Talos extensions needed in Talos nodes | `list(string)` | <pre>[<br/>  "siderolabs/iscsi-tools",<br/>  "siderolabs/qemu-guest-agent"<br/>]</pre> | no |
| <a name="input_talos_extra_kernel_args"></a> [talos\_extra\_kernel\_args](#input\_talos\_extra\_kernel\_args) | Talos extra kernel arguments for Talos nodes | `list(string)` | `[]` | no |
| <a name="input_talos_nodes"></a> [talos\_nodes](#input\_talos\_nodes) | Configuration for cluster nodes.<br/><br/>Per-node `bridge` overrides the module-level `network_bridge`; `vlan_id`<br/>leaves the NIC untagged when unset.<br/><br/>`pci_devices` passes host PCI devices through, addressed by Proxmox<br/>resource mapping name rather than raw PCI address, so one map can cover<br/>hosts where the device sits at a different address. Passthrough to a VM is<br/>exclusive -- a device given to a node is unavailable to the host and to<br/>every other guest, unlike a device bind-mounted into an LXC. | <pre>map(object({<br/>    host_node      = string<br/>    machine_type   = string<br/>    datastore_id   = optional(string, "local-lvm")<br/>    dns            = optional(list(string))<br/>    vm_id          = number<br/>    cpu            = number<br/>    memory         = number<br/>    boot_disk_size = optional(number, 20)<br/>    ip_address     = string<br/>    ip_gateway     = string<br/>    ip_subnet      = number<br/>    bridge         = optional(string)<br/>    vlan_id        = optional(number)<br/>    pci_devices = optional(list(object({<br/>      mapping = string<br/>      pcie    = optional(bool, true)<br/>      rombar  = optional(bool, true)<br/>      xvga    = optional(bool, false)<br/>    })), [])<br/>  }))</pre> | n/a | yes |
| <a name="input_talos_version"></a> [talos\_version](#input\_talos\_version) | Talos node version | `string` | `"v1.12.11"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_schematic_id"></a> [schematic\_id](#output\_schematic\_id) | n/a |
<!-- END_TF_DOCS -->