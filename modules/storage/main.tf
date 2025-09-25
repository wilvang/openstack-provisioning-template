# ============================================
# STORAGE MODULE: main.tf
# ============================================
# This file contains the core resources for managing
# OpenStack object storage containers.
#
# Module Purpose:
#   - Provision Swift object storage containers with
#     configurable access control.
#   - Support storage containers that can be attached
#     to services or VMs as needed.

# --------------------------------------------
# Current Authentication Scope Data Source
# --------------------------------------------
# Retrieves information about the current OpenStack authentication context,
# including the project ID and scope details.
data "openstack_identity_auth_scope_v3" "current" {
    name = var.project
}

# --------------------------------------------
# Storage Container Resource
# --------------------------------------------
# Defines a Swift object storage container in OpenStack.
# This container can be used to store objects (files, blobs)
# and can be attached to VMs or services as needed.
resource "openstack_objectstorage_container_v1" "public_container" {
  region = var.region_name     
  name   = var.container_name    

  # Public read access to all users (anonymous read)
  container_read  = ".r:*"

  # Write access restricted to admin user in current project
  container_write = "${data.openstack_identity_auth_scope_v3.current.project_id}:${var.admin_name}"
}
