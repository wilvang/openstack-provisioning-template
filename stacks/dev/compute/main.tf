# ============================================
# STACK CONFIGURATION: Dev Compute
# ============================================
# This file defines the **stack-level orchestration** of all Terraform modules
# required to deploy a compute development infrastructure on OpenStack.
# It integrates compute and storage components.
#
# Modules Included:
#
#   - Compute:            Provisions virtual machines and floating IPs
#   - Persistent Storage: Attaches durable Cinder block volumes to VMs
#
# All variables are supplied via the corresponding terraform.tfvars file
# to allow environment-specific configuration and scaling.

# --------------------------------------------
# COMPUTE MODULE
# --------------------------------------------
# This module provisions the compute instances (VMs), connects them
# to the network created above, and applies user-defined configuration
# such as keypairs, templates, and security group rules.
# It depends on the network module to ensure resources are created
# in the correct order.
module "vm_instance" {
  source     = "git::https://github.com/wilvang/openstack-provisioning-template.git//modules/compute?ref=5de522f1674e0a3fc481f625caab08e9c1602898"
  depends_on = [module.volume]

  volume_ids            = module.volume.volume_id
  keypair_name          = var.keypair_name
  network_id            = data.terraform_remote_state.network.outputs.network_id
  subnet_ids            = data.terraform_remote_state.network.outputs.subnet_ids
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
  source = "git::https://github.com/wilvang/openstack-provisioning-template.git//modules/persistent-storage?ref=43784959c35017fe7e4961c780c31aa001197127"

  volume_size = 10
}