# ============================================
# LOAD BALANCER MODULE: main.tf
# ============================================
# This file defines the resources needed to create an OpenStack
# load balancer, including the load balancer itself, listeners,
# pools, pool members, and floating IPs.
#
# The load balancer is only created if enabled by the
# `enable_lb` variable.
#
# Resources:
#   - Load Balancer
#   - Listener
#   - Pool
#   - Pool Members

# --------------------------------------------
# Random ID Resource
# --------------------------------------------
# Generates a random hexadecimal ID used to uniquely
# identify the load balancer and related resources.
resource "random_id" "lb_id" {
  byte_length = 4
}

# --------------------------------------------
# Load Balancer Resource
# --------------------------------------------
# Creates the OpenStack load balancer resource, assigning it a unique
# name using a random ID. The VIP (Virtual IP) is created in the specified
# subnet.
resource "openstack_lb_loadbalancer_v2" "lb" {
  count      = var.enable_lb ? 1 : 0
  name       = "lb-${random_id.lb_id.hex}"
  vip_subnet_id = var.subnet_id
}

# --------------------------------------------
# Load Balancer Listener Resource
# --------------------------------------------
# Creates a listener for the load balancer, specifying the protocol
# and port based on input variables. This listener routes incoming
# traffic to the pool members.
resource "openstack_lb_listener_v2" "listener" {
  count           = var.enable_lb ? 1 : 0
  loadbalancer_id = openstack_lb_loadbalancer_v2.lb[0].id
  protocol        = var.protocol.name
  protocol_port   = var.protocol.port
  name            = "listener-${random_id.lb_id.hex}"
}

# --------------------------------------------
# Load Balancer Pool Resource
# --------------------------------------------
# Creates a load balancer pool associated with the listener. Defines
# the load balancing method (scheduling) and protocol to use when
# distributing traffic.
resource "openstack_lb_pool_v2" "pool" {
  count      = var.enable_lb ? 1 : 0
  listener_id = openstack_lb_listener_v2.listener[0].id
  protocol    = var.protocol.name
  lb_method   = var.scheduling
  name        = "pool-${random_id.lb_id.hex}"
}

# --------------------------------------------
# Load Balancer Pool Member Resource
# --------------------------------------------
# Defines the members (backend instances) of the load balancer pool.
# Each member corresponds to an instance IP address, allowing traffic
# to be distributed to multiple backend servers.
resource "openstack_lb_member_v2" "member" {
  count         = var.enable_lb ? length(var.instance_ips) : 0
  pool_id    = openstack_lb_pool_v2.pool[0].id
  address    = var.instance_ips[count.index]
  protocol_port = var.protocol.port
  subnet_id  = var.subnet_id
}

# --------------------------------------------
# Floating IP for Load Balancer
# --------------------------------------------
# Allocates a floating IP from the external network pool to
# provide public access to the load balancer.
resource "openstack_networking_floatingip_v2" "lb_fip" {
  count      = var.enable_lb ? 1 : 0
  pool       = data.openstack_networking_network_v2.ext_network.name
}

# --------------------------------------------
# Floating IP Association Resource
# --------------------------------------------
# Associates the allocated floating IP with the load balancer's
# VIP port to enable external connectivity.
resource "openstack_networking_floatingip_associate_v2" "fip_assoc_lb" {
  count              = var.enable_lb ? 1 : 0
  floating_ip = openstack_networking_floatingip_v2.lb_fip[0].address
  port_id     = openstack_lb_loadbalancer_v2.lb[0].vip_port_id
}