# ============================================
# COMPUTE & SECURITY MODULE: main.tf
# ============================================
# This file contains the core compute and security resources
# for the infrastructure setup, including the creation
# of virtual machines, floating IPs, security groups, and
# security group rules.
#
# Modules:
#   - Compute Instance (VM)
#   - Floating IP
#   - Security Group
#   - Security Group Rules
#
# This file defines resources and configurations 
# related to compute instances and networking security 
# in OpenStack, and should be used within a larger 
# Terraform module.

# --------------------------------------------
# VM Instance Resource
# --------------------------------------------
# Define the virtual machine (VM) instances that will be
# created in OpenStack. Each VM is configured with 
# specific parameters such as the name, image, flavor, 
# and security groups.
resource "openstack_compute_instance_v2" "vm_instance" {
  for_each = { for vm in var.vm_setup : vm.name => vm }

  name            = each.value.name
  image_id        = data.openstack_images_image_v2.instance_image.id
  flavor_id       = data.openstack_compute_flavor_v2.instance_flavor.id
  key_pair        = data.openstack_compute_keypair_v2.key_pair.name
  security_groups = [openstack_networking_secgroup_v2.vm_secgroup[each.key].name]

  network {
    name = data.terraform_remote_state.network.outputs.network_name 
  }
}

# --------------------------------------------
# Floating IP Resource
# --------------------------------------------
# This resource dynamically creates floating IPs 
# for each VM instance. Floating IPs are typically 
# used to provide public access to instances.
resource "openstack_networking_floatingip_v2" "float_ip" {
  for_each = { for vm in var.vm_setup : vm.name => vm }

  pool       = data.openstack_networking_network_v2.ext_network.name
  subnet_ids = data.openstack_networking_subnet_ids_v2.ext_subnets.ids
}

# --------------------------------------------
# Floating IP Association Resource
# --------------------------------------------
# This resource associates the floating IPs with the 
# corresponding compute instances, allowing public 
# access to the VMs.
resource "openstack_compute_floatingip_associate_v2" "fip_assoc" {
  for_each = openstack_networking_floatingip_v2.float_ip

  floating_ip = each.value.address
  instance_id = openstack_compute_instance_v2.vm_instance[each.key].id
}

# --------------------------------------------
# Security Group Resource
# --------------------------------------------
# This resource creates a security group for each VM, 
# where the security group will define which network 
# traffic is allowed or denied.
resource "openstack_networking_secgroup_v2" "vm_secgroup" {
  for_each = { for vm in var.vm_setup : vm.name => vm }

  name        = "${each.key}_sg"
  description = "Security group for ${each.key} instance"
}

# --------------------------------------------
# Security Group Rule (Server-Specific) Resource
# --------------------------------------------
# This resource dynamically creates security group rules
# for the web and database servers, assigning the
# appropriate ports based on the VM type (web or db).
resource "openstack_networking_secgroup_rule_v2" "server_specific_rule" {
  for_each = {
    for vm in var.vm_setup :
    vm.name => vm if (vm.type == "web" || vm.type == "db")
  }

  security_group_id = openstack_networking_secgroup_v2.vm_secgroup[each.key].id

  direction = var.sg_rule.direction
  ethertype = var.sg_rule.ethertype
  protocol  = var.sg_rule.protocol
  remote_ip_prefix = var.sg_rule.remote_ip_prefix

  # Conditional logic to allow different ports based on the VM type
  port_range = each.value.type == "web" ? var.web_port : var.db_port
}

# --------------------------------------------
# Security Group Rule (SSH) Resource
# --------------------------------------------
# This resource creates an ingress rule to allow SSH access
# (port 22) to all instances through their security group.
resource "openstack_networking_secgroup_rule_v2" "ssh_connect_rule" {
  for_each = openstack_networking_secgroup_v2.vm_secgroup

  security_group_id = each.value.id

  direction = var.sg_rule.direction
  ethertype = var.sg_rule.ethertype
  protocol  = var.sg_rule.protocol
  remote_ip_prefix = var.sg_rule.remote_ip_prefix
  port_range = var.ssh_port
}
