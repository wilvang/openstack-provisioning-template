# ============================================
# OUTPUT CONFIGURATION
# ============================================
# The output block is used to display information
# about the resources that have been created by Terraform.
# Outputs are useful for displaying important values
# like IP addresses, resource IDs, or names that may
# need to be referenced later in other modules or by users.

# --------------------------------------------
# Network ID Output
# --------------------------------------------
# Returns the ID of the OpenStack network resource created,
# allowing other modules or users to reference this network.
output "network_id" {
  description = "The ID of the network created in OpenStack."
  value       = openstack_networking_network_v2.network.id
}

# --------------------------------------------
# Subnet IDs Output
# --------------------------------------------
# Returns a map of subnet keys to their corresponding subnet IDs.
# This enables easy lookup of subnet IDs for subnets managed by this module.
output "subnet_ids" {
  value = { for key, subnet in openstack_networking_subnet_v2.subnet : key => subnet.id }
}