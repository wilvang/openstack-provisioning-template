# ============================================
# OUTPUT CONFIGURATION
# ============================================
# The output block is used to display information
# about the resources that have been created by Terraform.
# Outputs are useful for displaying important values
# like IP addresses, resource IDs, or names that may
# need to be referenced later in other modules or by users.

# This output will return the name of the network
# created in the OpenStack environment.
output "network_name" {
  description = "The name of the network that was created in OpenStack."
  value       = openstack_networking_network_v2.network.name
}
