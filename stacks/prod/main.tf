module "network" {
    source = "../../modules/networking"

    network_name = var.network_name
    external_network_id = var.external_network_id
    subnet_cidr_blocks = var.subnet_cidr_blocks

}

module "vm_instance" {
    source = "../../modules/compute"
    depends_on = [ module.network ]

    for_each = { for vm in var.vm_setup : vm.name => vm }

    keypair_name = var.keypair_name
    network = module.network.network_name 
    external_network_name = var.external_network_name
}


