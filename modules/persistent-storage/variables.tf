# ============================================
# VARIABLES CONFIGURATION
# ============================================
# This section defines the variables used throughout the storage module.
# These variables allow customization of the OpenStack block storage volume,
# including its name, size, and the VM instance to attach to.

# --------------------------------------------
# Region Name Variable
# --------------------------------------------
# The OpenStack region where the volume will be created.
# This corresponds to the region configured in your OpenStack cloud provider.
# Default is set to 'SkyHiGh' but should be updated if deploying elsewhere.
variable "region_name" {
  type        = string
  default     = "SkyHiGh"
  description = "The OpenStack region where the volume will be created."
}

# --------------------------------------------
# Volume Name Variable
# --------------------------------------------
# Specifies the name of the persistent block storage volume to be created.
# This name is used to identify the volume within the OpenStack environment and should be unique.
variable "volume_name" {
  type    = string
  default = "persistent_volume"
  description = "The name assigned to the persistent block storage volume."
}

# --------------------------------------------
# Volume Size Variable
# --------------------------------------------
# Defines the size of the block storage volume in gigabytes (GB).
# Set this value based on the required storage capacity for your workload.
variable "volume_size" {
  type    = number
  default = 10
  description = "The size of the block storage volume in gigabytes (GB)."
}

# --------------------------------------------
# VM Instance ID Variable
# --------------------------------------------
# Contains a map of VM instance IDs to which the volume may be attached.
# This enables attaching the volume dynamically to one or multiple instances.
variable "vm_id" {
  type        = map(string)
  description = "A map of VM instance IDs for attaching the volume."
}