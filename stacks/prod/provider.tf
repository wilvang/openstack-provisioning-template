# ============================================
# PROVIDER CONFIGURATION
# ============================================
# Configures the OpenStack provider to interact with OpenStack's API
# and manage resources, as well as sets up the backend for Terraform state
# storage and locking in GitLab.

# --------------------------------------------
# Backend Configuration (GitLab)
# --------------------------------------------
# This backend stores Terraform state and lock information in a GitLab project.
terraform {
  required_version = ">= 0.14.0"

  backend "http" {
    address        = "${var.gitlab_backend}/prod"
    lock_address   = "${var.gitlab_backend}/prod/lock"
    unlock_address = "${var.gitlab_backend}/prod/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = "5"
  }

  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3"
    }
  }
}

# --------------------------------------------
# OpenStack Provider Configuration
# --------------------------------------------
# Configures OpenStack provider credentials and endpoint.
# Use environment variables for secure authentication.
provider "openstack" {}