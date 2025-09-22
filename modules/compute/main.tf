# ============================================
# COMPUTE MODULE: main.tf
# ============================================
# This file contains the core compute for the 
# infrastructure setup, including the creation
# of virtual machines and floating IPs.
#
# Modules:
#   - Compute Instance (VM)
#   - Floating IP
#
# This file defines resources and configurations 
# related to compute instances in OpenStack, and 
# should be used within a larger Terraform module.

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
  security_groups = each.value.security_groups

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

