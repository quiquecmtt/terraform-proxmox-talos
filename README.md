# Terraform Proxmox Talos
Terraform module to create Talos VMs in Proxmox VE.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 0.90.0 |
| <a name="requirement_talos"></a> [talos](#requirement\_talos) | 0.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 0.90.0 |
| <a name="provider_talos"></a> [talos](#provider\_talos) | 0.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_virtual_environment_download_file.talos_image](https://registry.terraform.io/providers/bpg/proxmox/0.90.0/docs/resources/virtual_environment_download_file) | resource |
| [proxmox_virtual_environment_vm.talos_vms](https://registry.terraform.io/providers/bpg/proxmox/0.90.0/docs/resources/virtual_environment_vm) | resource |
| [talos_image_factory_schematic.this](https://registry.terraform.io/providers/siderolabs/talos/0.10.0/docs/resources/image_factory_schematic) | resource |
| [talos_image_factory_extensions_versions.this](https://registry.terraform.io/providers/siderolabs/talos/0.10.0/docs/data-sources/image_factory_extensions_versions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_image_node_name"></a> [image\_node\_name](#input\_image\_node\_name) | Node where to download Talos image | `string` | n/a | yes |
| <a name="input_talos_extensions"></a> [talos\_extensions](#input\_talos\_extensions) | Talos extensions needed in Talos nodes | `list(string)` | <pre>[<br/>  "siderolabs/iscsi-tools",<br/>  "siderolabs/qemu-guest-agent"<br/>]</pre> | no |
| <a name="input_talos_extra_kernel_args"></a> [talos\_extra\_kernel\_args](#input\_talos\_extra\_kernel\_args) | Talos extra kernel arguments for Talos nodes | `list(string)` | `[]` | no |
| <a name="input_talos_nodes"></a> [talos\_nodes](#input\_talos\_nodes) | Configuration for cluster nodes | <pre>map(object({<br/>    host_node      = string<br/>    machine_type   = string<br/>    datastore_id   = optional(string, "local-lvm")<br/>    dns            = optional(list(string))<br/>    vm_id          = number<br/>    cpu            = number<br/>    memory         = number<br/>    boot_disk_size = optional(number, 20)<br/>    ip_address     = string<br/>    ip_gateway     = string<br/>    ip_subnet      = number<br/>  }))</pre> | n/a | yes |
| <a name="input_talos_version"></a> [talos\_version](#input\_talos\_version) | Talos node version | `string` | `"v1.10.6"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_schematic_id"></a> [schematic\_id](#output\_schematic\_id) | n/a |
<!-- END_TF_DOCS -->