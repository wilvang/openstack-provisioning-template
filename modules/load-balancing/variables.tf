# ============================================
# VARIABLES CONFIGURATION
# ============================================
# This section defines the input variables for the load balancer module.
# Variables control the load balancer enablement, network configuration,
# protocols, scheduling methods, and related settings.

# --------------------------------------------
# Enable Load Balancer Flag
# --------------------------------------------
# Boolean flag to enable or disable creation of the load balancer resources.
variable "enable_lb" {
  type        = bool
  description = "Flag to enable or disable the load balancer."
  default     = false
}

# --------------------------------------------
# VM Instance IPs
# --------------------------------------------
# List of IP addresses of the virtual machines that will be registered as pool members.
variable "instance_ips" {
  type        = list(string)
  description = "List of VM instance IPs to be included as members in the load balancer pool."
}

# --------------------------------------------
# VIP Subnet ID
# --------------------------------------------
# Subnet ID where the load balancer's virtual IP (VIP) will be allocated.
variable "subnet_id" {
  type        = string
  description = "List of subnet IDs where the load balancer VIP will be created."
}

# --------------------------------------------
# Load Balancer Scheduling Method
# --------------------------------------------
# Load balancing algorithm to distribute traffic across pool members.
# Common methods include ROUND_ROBIN, LEAST_CONNECTIONS, etc.
variable "scheduling" {
    type = string
    default = "ROUND_ROBIN"
}

# --------------------------------------------
# Protocol Configuration
# --------------------------------------------
# Defines the protocol and port used by the load balancer listener and pool.
variable "protocol" {
  type = object({
    name = string
    port = number
  })
  default = {
    name = "HTTP"
    port = 80
  }
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
# Network Configuration
# --------------------------------------------
# This variable defines the network to which the VM instance will be connected.
# It's a string that should match the name of the network in OpenStack.
# This is an essential field for ensuring the VM has proper connectivity.
variable "network_id" {
  description = "ID of network to associate with the VM instance"
  type        = string
}