# ============================================
# OPENSTACK DATA SOURCES
# ============================================
# This section defines the data sources used to retrieve information about 
# OpenStack resources such as key pairs, networks and ports.

# --------------------------------------------
# External Network Data Source
# --------------------------------------------
# Retrieves the external network by its name in OpenStack.
# This network is typically used for internet connectivity.
data "openstack_networking_network_v2" "ext_network" {
  name = var.external_network_name
}