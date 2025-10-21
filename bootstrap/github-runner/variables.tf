# ============================================
# GLOBAL VARIABLES CONFIGURATION
# ============================================
# This file contains the global variables that are used throughout
# different modules. These variables allow users to customize 
# various aspects of the infrastructure, such as VM settings,
# networking, security configurations, and more.

# --------------------------------------------
# Keypair Name Variable
# --------------------------------------------
# The name of the OpenStack keypair to use for secure SSH access to the VM.
# The keypair is used for authentication when accessing the virtual machine.
variable "keypair_name" {
  description = "Name of the OpenStack keypair to use"
  type        = string
}

# --------------------------------------------
# External Network Name Variable
# --------------------------------------------
# The name of the external network for allocating floating IPs.
# The external network is usually the public network or the one connected
# to the outside world for public IPs.
variable "external_network_name" {
  description = "Name of the external network for floating IPs"
  type        = string
}

# --------------------------------------------
# Admin Username Variable
# --------------------------------------------
# The OpenStack admin username who will have write access to the storage container.
# This user must exist in the current OpenStack project and have appropriate permissions.
variable "admin_name" {
  description = "The OpenStack admin usernamer who will have write access to the storage container."
  type        = string
}

# --------------------------------------------
# GitLab Backend Variable
# --------------------------------------------
# Configures the HTTP backend URL integrated with GitLab's Terraform state API.
# This backend manages the remote Terraform state storage within GitLab.
variable "gitlab_backend" {
  description = "HTTP backend, integrated with GitLab's Terraform state API."
  type        = string
}

# --------------------------------------------
# VM Setup Variable
# --------------------------------------------
# Map of VM roles to instance names.
variable "vm_setup" {
  type        = map(string)
  description = "Map of VM roles to instance names for the compute instances."
  default = {
    app = "github-runner"
  }
}

# --------------------------------------------
# Volume Name Variable
# --------------------------------------------
# Specifies the names of the persistent block storage volumes to be created.
# This name is used to identify each volume within the OpenStack environment and should be unique.
variable "volume_name" {
  type = map(string)
  default = {
    app = "runner_volume"
  }
  description = "The names assigned to the persistent block storage volumes."
}

# --------------------------------------------
# Subnet CIDR Blocks Variable
# --------------------------------------------
# A list of CIDR blocks to be used for creating subnets within the OpenStack network.
# The default includes three subnets with a /26 mask.
variable "subnet_layout" {
  description = "CIDR blocks for the different subnets."
  type        = map(string)
  default = {
    app = "192.168.200.0/26"
  }
}

# --------------------------------------------
# External Network Name Variable
# --------------------------------------------
# The name of the external network for allocating floating IPs.
# The external network is usually the public network or the one connected
# to the outside world for public IPs.
variable "external_network_id" {
  description = "ID of the external network for floating IPs"
  type        = string
}

# --------------------------------------------
# Network Name Variable
# --------------------------------------------
# The name of the OpenStack network to be created.
# You can provide a custom network name or use the default "main_network".
variable "network_name" {
  description = "The name of the OpenStack network."
  type        = string
  default     = "runner_network"
}

# --------------------------------------------
# Router Name Variable
# --------------------------------------------
# The name of the OpenStack router to be created.
# This will be used when configuring the router in the OpenStack environment.
variable "router_name" {
  description = "The name of the OpenStack router."
  type        = string
  default     = "runner_router"
}