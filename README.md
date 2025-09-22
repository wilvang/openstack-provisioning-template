# OpenTofu Provisioning for OpenStack

## Setup and Partitioning of Infrastructure
This section describes how to set up and partition the infrastructure for this project.

### Step 1: Prepare the example.tfvars File
Create an example.tfvars file in the root of your project or in a central location where you store all your environment-specific variable values.

### Step 2: Use `ln` to Link example.tfvars to Your Modules
Once you have the `example.tfvars` file prepared, you can create a symbolic link in each module directory pointing to the central `example.tfvars` file. To link the file to a specific module, navigate to the module's directory and run the following command:

```bash
ln -s ../../example.tfvars ./example.tfvars
```