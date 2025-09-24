# ============================================
# GLOBAL VARIABLES CONFIGURATION
# ============================================
# This file contains the global variables that are used throughout
# different modules. These variables allow users to customize 
# various aspects of the infrastructure, such as VM settings,
# networking, security configurations, and more.

# --------------------------------------------
# Image Name Variable
# --------------------------------------------
# The name of the OpenStack image to be used for creating virtual machines.
# You can provide the exact image name you want, which typically refers 
# to the base operating system or template for the VM.
variable "image_name" {
  description = "Name of the OpenStack image to use for the VM"
  type        = string
  default     = "Debian 13 (trixie) stable amd64"
}

# --------------------------------------------
# Flavor ID Variable
# --------------------------------------------
# The ID of the OpenStack flavor to use for creating the virtual machines.
# A flavor defines the compute, memory, and storage capacity for the VM.
# You can specify a custom flavor ID or use a predefined one.
variable "flavor_name" {
  description = "ID of the OpenStack flavor to use"
  type        = string
  default     = "gx3.2c2r"
}

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
# VM Setup Variable
# --------------------------------------------
# A list of VM setup specifications. Each entry defines the name and type
# of the VM to be created. The `type` can be used to define roles, such as 
# "web" or "db", to apply specific configurations (like ports) based on the VM type.
variable "vm_setup" {
  description = "A list of VM setup specifications."
  type = list(object({
    name  = string
    type  = string
  }))
  default = [
    { name = "web-server", type = "web" },
    { name = "db-server", type = "db" }
  ]
}

# --------------------------------------------
# Network Configuration
# --------------------------------------------
# This variable defines the network to which the VM instance will be connected.
# It's a string that should match the name of the network in OpenStack.
# This is an essential field for ensuring the VM has proper connectivity.
variable "network" {
  description = "Name of network to associate with the VM instance"
  type        = string
}

# --------------------------------------------
# Security Group Rule Configuration
# --------------------------------------------
# This object defines the configuration for a security group rule.
# It includes the ethertype (IPv4/IPv6), the protocol (e.g., tcp, udp),
# and the remote IP prefix (for example, `0.0.0.0/0` allows access from anywhere).
variable "sg_rule" {
  description = "Configuration for a security group rule"
  type = object({
    direction        = string
    ethertype        = string
    protocol         = string
    remote_ip_prefix = string
  })
  default = {
    direction = "ingress"
    ethertype = "IPv4"
    protocol = "tcp"
    remote_ip_prefix = "0.0.0.0/0"
  }
}

# --------------------------------------------
# Web Port Variable
# --------------------------------------------
# Defines the port to be opened for web servers (default is port 80).
# This is typically used for HTTP traffic on the web-server VMs.
variable "web_port" {
    description = "Open port for web-servers"
    type = number
    default = 80
}

# --------------------------------------------
# DB Port Variable
# --------------------------------------------
# Defines the port to be opened for database servers (default is port 3306).
# This is typically used for MySQL or other database services.
variable "db_port" {
    description = "Open port for db-servers"
    type = number
    default = 3306
}

# --------------------------------------------
# SSH Port Variable
# --------------------------------------------
# Defines the port to be opened for SSH access to all virtual machines.
# By default, this is set to port 22, which is the standard for SSH connections.
variable "ssh_port" {
    description = "Open port for ssh connections"
    type = number
    default = 22
}

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
variable "subnet_cidr_blocks" {
  description = "List of CIDR blocks for the subnets."
  type        = list(string)
  default     = ["192.168.50.0/26", "192.168.50.64/26", "192.168.50.128/26"]
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
