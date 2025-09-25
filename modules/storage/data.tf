# ============================================
# OPENSTACK DATA SOURCES
# ============================================
# This section defines data sources that query and retrieve
# information from the OpenStack environment at runtime.

# --------------------------------------------
# Current Authentication Scope Data Source
# --------------------------------------------
# Retrieves information about the current OpenStack authentication context,
# including the project ID and scope details.
data "openstack_identity_auth_scope_v3" "current" {
    name = var.project
}