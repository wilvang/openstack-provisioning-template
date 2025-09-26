# ============================================
# PERSISTENT STORAGE MODULE: main.tf
# ============================================
# This file contains the core resources for managing
# OpenStack persistent block storage volumes.
#
# Module Purpose:
#   - Provision Cinder block storage volumes with configurable size and names.
#   - Attach these volumes to specified VM instances to provide persistent storage.
#   - Ensure storage volumes persist independently of the VM lifecycle.

# --------------------------------------------
# Block Storage Volume Resource
# --------------------------------------------
# Defines one or more persistent block storage volumes using OpenStack Cinder.
# Each volume is created with the specified name, size, and region.
# Volumes can be attached to one or multiple VM instances dynamically.
resource "openstack_blockstorage_volume_v3" "volume" {
  for_each = var.volume_name

  region      = var.region_name
  name        = each.value
  description = "Persistent block storage volume for VM instance (${each.key})"
  size        = var.volume_size
}