# ============================================
# OPENSTACK DATA SOURCES
# ============================================
# This section defines the data sources used to retrieve information about 
# OpenStack resources such as images, key pairs, flavors, and networks.

# --------------------------------------------
# Instance Image Data Source
# --------------------------------------------
# Retrieves the most recent image by the specified name from OpenStack.
# This image will be used to launch new instances.
data "openstack_images_image_v2" "instance_image" {
  name        = var.image_name
  most_recent = true
}

# --------------------------------------------
# Instance Flavor Data Source
# --------------------------------------------
# Retrieves the flavor for the instance using the specified flavor ID.
# This determines the resources (CPU, RAM, etc.) available for the instance.
data "openstack_compute_flavor_v2" "instance_flavor" {
  flavor_id = var.flavor_id
}

# --------------------------------------------
# Key Pair Data Source
# --------------------------------------------
# Retrieves the specified key pair by name from OpenStack.
# This key pair will be used for SSH access to instances.
data "openstack_compute_keypair_v2" "key_pair" {
  name = var.keypair_name
}

# --------------------------------------------
# External Network Data Source
# --------------------------------------------
# Retrieves the external network by its name in OpenStack.
# This network is typically used for internet connectivity.
data "openstack_networking_network_v2" "ext_network" {
  name = var.external_network_name
}

# --------------------------------------------
# External Subnets Data Source
# --------------------------------------------
# Retrieves the subnet IDs associated with the external network.
# These subnets are used for connecting instances to external resources.
data "openstack_networking_subnet_ids_v2" "ext_subnets" {
  network_id = data.openstack_networking_network_v2.ext_network.id
}
