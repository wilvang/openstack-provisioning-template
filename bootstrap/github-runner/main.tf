# ============================================
# STACK CONFIGURATION: Github-Runner
# ============================================
# This file defines the **stack-level orchestration** of Terraform modules
# required to deploy the GitHub Runner infrastructure on OpenStack.
#
# Modules Included:
#   - Networking:         Creates networks, routers, and subnets
#   - Compute:            Provisions virtual machines and floating IPs
#   - Persistent Storage: Attaches durable Cinder block volumes to VMs
#
# All variables are supplied via the corresponding terraform.tfvars file
# to allow environment-specific configuration and scaling.

# --------------------------------------------
# NETWORK MODULE
# --------------------------------------------
# This module sets up the internal networking resources, such as
# the virtual network and subnets, and integrates with the external network
# to allow access via floating IPs.
module "network" {
  source = "../../modules/networking"

  network_name        = var.network_name
  router_name         = var.router_name
  external_network_id = var.external_network_id
  subnet_layout       = var.subnet_layout
}

# --------------------------------------------
# COMPUTE MODULE
# --------------------------------------------
# This module provisions the compute instances (VMs), connects them
# to the network created above, and applies user-defined configuration
# such as keypairs, templates, and security group rules.
# It depends on the network module to ensure resources are created
# in the correct order.
module "vm_instance" {
  source     = "../../modules/compute"
  depends_on = [module.network, module.volume]

  volume_ids            = module.volume.volume_id
  keypair_name          = var.keypair_name
  network_id            = module.network.network_id
  subnet_ids            = module.network.subnet_ids
  external_network_name = var.external_network_name
  vm_setup              = var.vm_setup
}

# --------------------------------------------
# PERSISTENT STORAGE MODULE
# --------------------------------------------
# This module provisions persistent block storage volumes using OpenStack Cinder.
# It dynamically creates volumes based on the VM instances provided by the compute module.
# Each volume is attached to its corresponding VM to provide durable storage that
# persists independently of the VM lifecycle.
module "volume" {
  source = "../../modules/persistent-storage"

  volume_name = var.volume_name
}
