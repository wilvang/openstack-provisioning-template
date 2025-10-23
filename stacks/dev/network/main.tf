# ============================================
# STACK CONFIGURATION: Dev Network
# ============================================
# This file defines the **stack-level orchestration** of all Terraform modules
# required to deploy a network development infrastructure on OpenStack.
#
# Modules Included:
#   - Networking:         Creates networks, routers, and subnets
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
  source = "git::https://github.com/wilvang/openstack-provisioning-template.git//modules/networking?ref=1b9875ce3432c8bc0286a8c410297b861d5db892"

  network_name        = var.network_name
  router_name         = var.router_name
  external_network_id = var.external_network_id
}