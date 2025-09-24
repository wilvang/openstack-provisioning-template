# ============================================
# OPENSTACK DATA SOURCES
# ============================================
# This section defines the data sources used to retrieve information about 
# OpenStack resources such as key pairs, networks and ports.

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


# --------------------------------------------
# Networking Port Data Source
# --------------------------------------------
data "openstack_networking_port_v2" "instance_port" {
  for_each = { for vm in var.vm_setup : vm.name => vm }

  device_id  = openstack_compute_instance_v2.vm_instance[each.key].id
  network_id = data.openstack_networking_network_v2.ext_network.id
}
