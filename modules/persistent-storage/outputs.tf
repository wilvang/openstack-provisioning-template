# ============================================
# OUTPUT CONFIGURATION
# ============================================
# The output block is used to display information
# about the resources that have been created by Terraform.
# Outputs are useful for displaying important values
# like IP addresses, resource IDs, or names that may
# need to be referenced later in other modules or by users.

# --------------------------------------------
# Output: Block Storage Volume IDs
# --------------------------------------------
# Exposes a map of volume IDs for all persistent block storage volumes
# created by the module. The map keys correspond to the VM identifiers,
# allowing easy reference of the volume attached to each VM instance.
output "volume_id" {
  description = "Map of IDs for persistent block storage volumes keyed by VM instance."
  value       = { for key, volume in openstack_blockstorage_volume_v3.volume : key => volume.id }
}
