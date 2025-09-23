# ============================================
# OPENSTACK OUTPUTS
# ============================================
# This section defines the output values from the resources created in this Terraform module.
# These outputs provide important information about the created OpenStack resources
# such as instance ID, IP addresses, and floating IP addresses.

# --------------------------------------------
# Instance ID Output
# --------------------------------------------
# This output provides the unique identifier (ID) of the VM instance created in OpenStack.
# The instance ID can be used for further actions such as updating, deleting, or referencing the instance.
output "instance_id" {
  value = { for key, instance in openstack_compute_instance_v2.vm_instance : key => instance.id }
}

# --------------------------------------------
# Instance IP Output
# --------------------------------------------
# This output provides the internal or external IPv4 address assigned to the VM instance.
# The IP address is necessary to access the instance either internally (within the VPC) or externally (via public IP).
output "instance_ip" {
  value = { for key, instance in openstack_compute_instance_v2.vm_instance : key => instance.access_ip_v4 }
}

# --------------------------------------------
# Instance Floating IP Output
# --------------------------------------------
# This output provides the floating IP address associated with the VM instance, if configured.
# Floating IPs are typically used to provide a public IP address that can be reassigned to instances.
output "instance_floating_ip" {
  value = { for key, ip in openstack_networking_floatingip_v2.float_ip : key => ip.address }
}