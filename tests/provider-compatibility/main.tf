terraform {
  required_version = ">= 1.10.0"
}

module "nodes" {
  source = "../.."

  image_node_name = "pve1"
  talos_nodes     = {}
}
