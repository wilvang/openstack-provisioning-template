# Configure remote backend for storing Terraform state in GitLab 
terraform {
  backend "http" {
    address        = "https://gitlab.stud.idi.ntnu.no/api/v4/projects/30968/terraform/state/networking"
    lock_address   = "https://gitlab.stud.idi.ntnu.no/api/v4/projects/30968/terraform/state/networking/lock"
    unlock_address = "https://gitlab.stud.idi.ntnu.no/api/v4/projects/30968/terraform/state/networking/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = "5"
  }

  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {}
