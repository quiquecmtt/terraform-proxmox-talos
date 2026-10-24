module "nodes" {
  source = "../.."

  image_node_name = "pve1"
  talos_nodes     = {}
}
