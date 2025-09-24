# ============================================
# VARIABLES CONFIGURATION
# ============================================
# This section defines the variables used throughout the compute and 
# networking module. These variables allow users to customize the 
# specifications of virtual machines, security groups, and network 
# configurations.

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
# Flavor Name Variable
# --------------------------------------------
# The name of the OpenStack flavor to use for creating the virtual machines.
# A flavor defines the compute, memory, and storage capacity for the VM.
# You can specify a custom flavor name or use a predefined one.
variable "flavor_name" {
  description = "Name of the OpenStack flavor to use"
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
# Network Configuration
# --------------------------------------------
# This variable defines the network to which the VM instance will be connected.
# It's a string that should match the name of the network in OpenStack.
# This is an essential field for ensuring the VM has proper connectivity.
variable "network" {
  description = "Name of network to associate with the VM instance"
  type        = string
}

