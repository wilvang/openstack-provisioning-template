# ============================================
# NETWORKING MODULE: main.tf
# ============================================
# This file contains the core networking resources 
# for the infrastructure setup, including the
# creation of networks, subnets, and routers.
#
# Modules: 
#   - Network
#   - Subnet
#   - Router
#
# This file defines resources and configurations 
# related to networking and should be used within 
# the larger Terraform module.


# --------------------------------------------
# Network Resource
# --------------------------------------------
# Define the network to be created in OpenStack.
resource "openstack_networking_network_v2" "network" {
  name           = var.network_name
  admin_state_up = true
}

# --------------------------------------------
# Subnet Resource
# --------------------------------------------
# Define subnets to be created within the network.
resource "openstack_networking_subnet_v2" "subnet" {
  for_each = var.subnet_layout
  
  name            = "${var.network_name}_${each.key}_subnet"
  network_id      = openstack_networking_network_v2.network.id
  cidr            = each.value
  dns_nameservers = var.dns_nameservers
}

# --------------------------------------------
# Router Resource
# --------------------------------------------
# Define a router to connect the network to an external gateway.
resource "openstack_networking_router_v2" "router" {
  name                = var.router_name
  external_network_id = var.external_network_id
}

# --------------------------------------------
# Router Interface Resource
# --------------------------------------------
# Attach each subnet to the router's interface dynamically.
resource "openstack_networking_router_interface_v2" "router_interface" {
  for_each = openstack_networking_subnet_v2.subnet

  router_id = openstack_networking_router_v2.router.id
  subnet_id = each.value.id
}
