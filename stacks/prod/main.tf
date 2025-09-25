# ============================================
# STACK CONFIGURATION: Prod
# ============================================
# This file represents the stack-level orchestration of Terraform modules.
# It ties together the networking and compute modules to deploy a complete
# infrastructure stack in the target environment (e.g., prod or dev).
#
# Modules Included:
#   - Networking: Creates networks and subnets
#   - Compute:   Provisions virtual machines with floating IPs
#
# Variables are passed in from the corresponding terraform.tfvars file
# for environment-specific configuration.

# --------------------------------------------
# NETWORK MODULE
# --------------------------------------------
# This module sets up the internal networking resources, such as
# the virtual network and subnets, and integrates with the external network
# to allow access via floating IPs.
module "network" {
    source = "../../modules/networking"

    network_name = var.network_name
    external_network_id = var.external_network_id
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
    source = "../../modules/compute"
    depends_on = [ module.network ]

    keypair_name = var.keypair_name
    network_id = module.network.network_id
    subnet_ids = module.network.subnet_ids
    external_network_name = var.external_network_name
}