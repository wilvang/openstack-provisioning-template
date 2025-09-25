# ============================================
# VARIABLES CONFIGURATION
# ============================================
# This section defines the variables used throughout the networking module.
# These variables allow users to customize aspects of the network, subnets,
# router, and external network configurations.

# --------------------------------------------
# Network Name Variable
# --------------------------------------------
# The name of the OpenStack network to be created.
# You can provide a custom network name or use the default "main_network".
variable "network_name" {
  description = "The name of the OpenStack network."
  type        = string
  default     = "main_network"
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
    web = "192.168.80.0/26",
    app = "192.168.80.64/26",
    db  = "192.168.80.128/26"
  }
}

# --------------------------------------------
# DNS Nameservers Variable
# --------------------------------------------
# List of DNS nameservers to be applied to the subnets.
# The default is set to Cloudflare's DNS (1.1.1.1).
variable "dns_nameservers" {
  description = "List of DNS nameservers for the subnets."
  type        = list(string)
  default     = ["1.1.1.1"]
}

# --------------------------------------------
# Router Name Variable
# --------------------------------------------
# The name of the OpenStack router to be created.
# This will be used when configuring the router in the OpenStack environment.
variable "router_name" {
  description = "The name of the OpenStack router."
  type        = string
  default     = "main_router"
}

# --------------------------------------------
# External Network ID Variable
# --------------------------------------------
# The UUID of the external network to which the OpenStack router will connect.
# This is required to enable internet access or connectivity to other external systems.
variable "external_network_id" {
  description = "The external network UUID for router connectivity."
  type        = string
}
