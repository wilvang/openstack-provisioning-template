# ============================================
# OUTPUT CONFIGURATION
# ============================================
# Defines output variables that expose key resource information
# created by Terraform. These outputs are intended for use by other
# modules, root stacks, or users to reference important values such as
# IDs, IP addresses, and endpoints.

# --------------------------------------------
# Output: Storage Container Name
# --------------------------------------------
# Exposes the name of the OpenStack Swift object storage container.
# This value can be used by other modules or the root stack to reference
# the container for attaching it to services or VMs.
output "container_name" {
  description = "The name of the OpenStack Swift object storage container."
  value       = openstack_objectstorage_container_v1.public_container.name
}