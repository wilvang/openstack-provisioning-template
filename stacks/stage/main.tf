# ============================================
# STACK CONFIGURATION: Stage
# ============================================
# This file defines the **stack-level orchestration** of all Terraform modules
# required to deploy a complete staging infrastructure on OpenStack.
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
  source = "git::https://github.com/wilvang/openstack-provisioning-template.git//modules/networking?ref=1b9875ce3432c8bc0286a8c410297b861d5db892"

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
  source     = "git::https://github.com/wilvang/openstack-provisioning-template.git//modules/compute?ref=5de522f1674e0a3fc481f625caab08e9c1602898"
  depends_on = [module.network, module.volume]

  volume_ids            = module.volume.volume_id
  keypair_name          = var.keypair_name
  network_id            = module.network.network_id
  subnet_ids            = module.network.subnet_ids
  external_network_name = var.external_network_name
  vm_setup              = var.vm_setup
}

# --------------------------------------------
# STORAGE MODULE
# --------------------------------------------
# Manages the provisioning of OpenStack object storage containers.
# The module creates containers with configurable read/write ACLs,
# scoped to the specified project and admin user.
# This supports persistent object storage usable by VMs or services.
module "container" {
  source     = "git::https://github.com/wilvang/openstack-provisioning-template.git//modules/storage?ref=b5576b048ccadd687a4c203f6a4703d7e3ae0ec4"
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
  source = "git::https://github.com/wilvang/openstack-provisioning-template.git//modules/persistent-storage?ref=43784959c35017fe7e4961c780c31aa001197127"

  volume_size = 10
}

# --------------------------------------------
# LOAD BALANCER MODULE
# --------------------------------------------
# Creates an OpenStack load balancer with associated networking.
# Depends on both networking and compute modules for proper linkage.
module "loadbalancer" {
  source     = "git::https://github.com/wilvang/openstack-provisioning-template.git//modules/load-balancing?ref=062d856b4f833bebf4d777e6b2f20b574cb2fadc"
  depends_on = [module.network, module.vm_instance]

  enable_lb = var.enable_lb

  external_network_name = var.external_network_name
  network_id            = module.network.network_id
  subnet_id             = module.network.subnet_ids["web"]
  instance_ips          = [module.vm_instance.instance_ip["web"]]
}