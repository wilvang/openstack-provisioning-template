# ============================================
# STACK CONFIGURATION: Prod
# ============================================
# This file defines the **stack-level orchestration** of all Terraform modules
# required to deploy a complete production infrastructure on OpenStack.
# It integrates networking, compute, storage, and load balancing components
# into a unified stack for the target environment (e.g., prod or dev).
#
# Modules Included:
#   - Networking:         Creates networks, routers, and subnets
#   - Compute:            Provisions virtual machines and floating IPs
#   - Object Storage:     Creates Swift object storage containers with ACLs
#   - Persistent Storage: Attaches durable Cinder block volumes to VMs
#   - Load Balancing:     Deploys an OpenStack load balancer with backend pool
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
}

# --------------------------------------------
# STORAGE MODULE
# --------------------------------------------
# Manages the provisioning of OpenStack object storage containers.
# The module creates containers with configurable read/write ACLs,
# scoped to the specified project and admin user.
# This supports persistent object storage usable by VMs or services.
module "container" {
  source = "../../modules/storage"

  admin_name = var.admin_name # OpenStack admin user granted write access
  project    = var.project
}

# --------------------------------------------
# PERSISTENT STORAGE MODULE
# --------------------------------------------
# This module provisions persistent block storage volumes using OpenStack Cinder.
# It dynamically creates volumes based on the VM instances provided by the compute module.
# Each volume is attached to its corresponding VM to provide durable storage that
# persists independently of the VM lifecycle.
module "volume" {
  source     = "../../modules/persistent-storage"

  volume_size = 10
}

# --------------------------------------------
# LOAD BALANCER MODULE
# --------------------------------------------
# Creates an OpenStack load balancer with associated networking.
# Depends on both networking and compute modules for proper linkage.
module "loadbalancer" {
  source     = "../../modules/load-balancing"
  depends_on = [module.network, module.vm_instance]

  enable_lb = var.enable_lb

  external_network_name = var.external_network_name
  network_id            = module.network.network_id
  subnet_id             = module.network.subnet_ids["web"]
  instance_ips          = [module.vm_instance.instance_ip["web"]]
}