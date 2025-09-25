# OpenTofu Provisioning for OpenStack

## Overview

This project provides a modular Terraform codebase to deploy and manage OpenStack infrastructure components. It is designed for flexibility, reusability, and environment-specific deployments via stack-level orchestration.

The infrastructure includes:

- Networking (networks, subnets, security groups)
- Compute resources (virtual machines with floating IPs)
- Load balancing with OpenStack LBaaS
- Persistent block storage (Cinder volumes)
- Object storage containers

---

## Prerequisites

- **OpenTofu CLI v1.10.6 or later** installed

- **OpenStack CLI installed and configured**  
  Ensure your OpenStack credentials and environment variables (or RC file) are properly set to authenticate Terraform against your OpenStack cloud.

- **Access to a private OpenStack cloud**  
  Your user must have sufficient quotas and permissions to provision networks, compute instances, storage volumes, and load balancers.

- **Terraform backend configured for state storage**  
  The project uses a remote HTTP backend to store Terraform state, typically hosted on GitLab Terraform State or another compatible service.  
  Ensure the backend URL and any required access tokens are properly configured in your `terraform.tfvars` file or environment variables.

---


## Setup and Partitioning of Infrastructure
This section describes how to set up and partition the infrastructure for this project.

### Step 1: Install OpenTofu and OpenStack CLI
Before getting started, you need to install the required tools.

- **For Ubuntu/Linux:**
  Open your terminal and run:

```bash
brew install opentofu openstack
```
- **For Ubuntu/Linux:**
  Run the following command in your terminal:

```bash
sudo apt install opentofu openstack
```

### Step 2: Clone the Repository
Clone the project repository to your local machine and navigate into it:

```bash
git clone https://github.com/wilvang/openstack-provisioning-template.git
cd openstack-provisioning-template
```

### Step 3: Prepare Your `terraform.tfvars.example` File
The Terraform configuration uses a variables file to customize your infrastructure.

1) Navigate to the production stack directory:

```bash
cd stacks/prod
```

2) Rename the example variables file to the actual variables file:

```bash
mv terraform.tfvars.example terraform.tfvars
```

3) Open `terraform.tfvars` in your favorite text editor and update the values to match your specific project requirements (e.g., project name, region, credentials).

### Step 4: Initialize the Stack with OpenTofu
Initialize the working directory containing the Terraform configuration files. This will download necessary provider plugins and set up your working environment.

```bash
tofu init 
```

### Step 4: Plan and Apply the Stack with OpenTofu
- **Plan:** Preview the actions OpenTofu will perform to reach the desired state defined in your configuration files.

```bash
tofu plan
```

- **Apply:** Apply the planned changes to provision the infrastructure.

```bash
tofu apply
```

### Step 5: Destroy the Configuration
When you no longer need the infrastructure and want to clean up resources, run:

```bash
tofu destroy
```

---

## Modules Description

### Networking Module

- Creates a 3-tier network architecture (public, application, database subnets)
- Configures security groups for SSH, HTTP, and database access
- Allows customizable network and subnet naming, IP ranges

### Compute Module

- Boots VMs with configurable flavors, images, and names
- Supports cloud-init scripts to install and configure HTTP and DB servers
- Attaches persistent storage volumes optionally
- Outputs VM IDs and IP addresses

### Load Balancing Module

- Configurable enable/disable flag for LBaaS
- Creates a load balancer with associated listeners and pools
- Registers frontend VMs as backend members
- Outputs LB endpoint IP or DNS

### Persistent Storage Module

- Provisions Cinder volumes attachable to VMs
- Configurable size and volume type

### Storage Module

- Creates Swift object storage containers
- Outputs container names/IDs

---