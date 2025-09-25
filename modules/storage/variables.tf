# ============================================
# VARIABLES CONFIGURATION
# ============================================
# This section defines the variables used throughout the storage module.
# These variables allow customization of the OpenStack object storage container,
# including its name, region, and access control.

# --------------------------------------------
# Admin Username Variable
# --------------------------------------------
# The OpenStack admin username who will have write access to the storage container.
# This user must exist in the current OpenStack project and have appropriate permissions.
variable "admin_name" {
  type        = string
  description = "The OpenStack admin usernamer who will have write access to the storage container."
}

# --------------------------------------------
# Region Name Variable
# --------------------------------------------
# The OpenStack region where the object storage container will be created.
# This corresponds to the region configured in your OpenStack cloud provider.
# Default is set to 'eu-north' but should be updated if deploying elsewhere.
variable "region_name" {
  type        = string
  default     = "SkyHiGh"
  description = "The OpenStack region where the object storage container will be created."
}

# --------------------------------------------
# Container Name Variable
# --------------------------------------------
# The name of the object storage container to be created.
# This name must be unique within the project and should follow any naming conventions.
variable "container_name" {
  type        = string
  default     = "public_container"
  description = "The name of the object storage container to be created."
}

# --------------------------------------------
# Project Name Variable
# --------------------------------------------
# The name of the OpenStack project (tenant) used for scoping
# authentication and resource creation.
# This should match the project configured in your OpenStack environment.
variable "project" {
  description = "The OpenStack project name for authentication scope and resource management."
  type        = string
}