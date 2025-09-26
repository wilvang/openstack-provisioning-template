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
# The OpenStack image name used for creating virtual machines.
# Specifies the base OS or template for the VM.
variable "image_name" {
  description = "Name of the OpenStack image to use for the VM"
  type        = string
  default     = "Debian 13 (trixie) stable amd64"
}

# --------------------------------------------
# Flavor Name Variable
# --------------------------------------------
# The OpenStack flavor name used for VM creation.
# Defines compute, memory, and storage capacity.
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
# Security Group Rule Configuration
# --------------------------------------------
# Defines the properties of a security group rule, including direction,
# protocol, ethertype, and remote IP prefix (e.g., '0.0.0.0/0' for any).
variable "sg_rule" {
  description = "Configuration for a security group rule"
  type = object({
    direction        = string
    ethertype        = string
    protocol         = string
    remote_ip_prefix = string
  })
  default = {
    direction        = "ingress"
    ethertype        = "IPv4"
    protocol         = "tcp"
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
  type        = number
  default     = 80
}

# --------------------------------------------
# DB Port Variable
# --------------------------------------------
# Defines the port to be opened for database servers (default is port 3306).
# This is typically used for MySQL or other database services.
variable "db_port" {
  description = "Open port for db-servers"
  type        = number
  default     = 3306
}

# --------------------------------------------
# SSH Port Variable
# --------------------------------------------
# Defines the port to be opened for SSH access to all virtual machines.
# By default, this is set to port 22, which is the standard for SSH connections.
variable "ssh_port" {
  description = "Open port for ssh connections"
  type        = number
  default     = 22
}

# --------------------------------------------
# VM Setup Variable
# --------------------------------------------
# Map of VM roles to instance names.
variable "vm_setup" {
  type        = map(string)
  description = "Map of VM roles to instance names for the compute instances."
  default = {
    web = "web-server_1"
    db  = "db-server_1"
  }
}

# --------------------------------------------
# User Data Template Variable
# --------------------------------------------
# Map of VM roles to user data template file paths for instance initialization.
variable "template" {
  type        = map(string)
  description = "Map of VM roles to user data template file paths for initializing the compute instances."
  default = {
    web = "scripts/web-template.yml"
    db  = "scripts/db-template.yml"
  }
}

# --------------------------------------------
# Subnet IDs Variable
# --------------------------------------------
# Map of VM roles to subnet IDs where the instances will be deployed.
variable "subnet_ids" {
  type        = map(string)
  description = "Map of VM roles to subnet IDs where the compute instances will be deployed."
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

# --------------------------------------------
# Volumes IDs Variable
# --------------------------------------------
# Defines the IDs for persistent block storage volumes.
# Each volume is represented by a key (typically matching the VM role),
variable "volume_ids" {
  type = map(string)
}