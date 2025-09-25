# OpenTofu Provisioning for OpenStack

## Setup and Partitioning of Infrastructure
This section describes how to set up and partition the infrastructure for this project.

### Step 1: Prepare the example.tfvars File
Open the example.tfvars file and define the specific values for the variables used in your infrastructure. Here's an example of what it might look like:

```
# Network Configuration
network_name  = "my-vlan-network"
subnet_cidr   = "192.168.100.0/24"
```

### Step 2: Rename the File to terraform.tfvars
Once the values are specified, rename example.tfvars to terraform.tfvars using the following command:

```bash
mv example.tfvars terraform.tfvars
```

### Step 3: Use `ln` to Link terraform.tfvars and variables.tf to Your Modules
Once you have the **terraform.tfvars** file prepared, you can create a symbolic link in each module directory pointing to the central file. This si also done for the **variables.tf** file. To link the files to a specific module, navigate to the module's directory and run the following command:

```bash
ln -s ../../terraform.tfvars ./terraform.tfvars
ln -s ../../variables.tf ./variables.tf
```

### Step 4: Initialize stack with OpenTofu

```bash
tofu init -backend-config="username=${TF_HTTP_USER}"
```