# ============================================
# OPENSTACK OUTPUTS
# ============================================
# This section defines the output values from the resources created in this Terraform module.
# These outputs provide important information about the created OpenStack resources
# such as instance ID, IP addresses, and floating IP addresses.

# --------------------------------------------
# Load Balancer Virtual IP Output
# --------------------------------------------
# Exposes the floating (public) IP address assigned to the load balancer.
# Returns null if the load balancer is disabled.
output "load_balancer_ip" {
  description = "The virtual IP address of the load balancer."
  value       = var.enable_lb ? openstack_networking_floatingip_v2.lb_fip[0].address : null
}
