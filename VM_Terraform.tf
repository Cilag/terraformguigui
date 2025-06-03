############################################################################
#  Fichier : VM_Terraform.tf (backend mis en dur pour éviter l’erreur "Variables not allowed")
############################################################################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.77.0"
    }
  }

  # ------------------------------------------------
  # Backend "azurerm" : on ne peut pas utiliser `var.xxx` ici.
  # On insère donc en dur les mêmes valeurs que dans variables.tf par défaut.
  # ------------------------------------------------
  backend "azurerm" {
    resource_group_name   = "rg-terraform-state"          # correspond à var.backend_rg_name
    storage_account_name  = "terraformgregouz"            # correspond à var.backend_storage_account_name
    container_name        = "tfstate"                     # correspond à var.backend_container_name
    key                   = "vm_deploy.tfstate"           # correspond à var.backend_key
    access_key            = "MmR/Rj5C2bql6Qro17XhTH1EUljiUMc2mtYUSCNH4gR9/r18PklvC3Gs0RmJMroAZ8+MemGTgjy2+AStVXrfng==" 
                                                       # correspond à var.backend_access_key
  }
}

############################################################################
# 1) Provider AzureRM (skip_provider_registration activé)
############################################################################
provider "azurerm" {
  skip_provider_registration = true
  subscription_id            = var.subscription_id
  features {}
}

############################################################################
# 2) Resource Group
############################################################################
resource "azurerm_resource_group" "my_resource_group" {
  name     = var.rg_name
  location = var.rg_location
}

############################################################################
# 3) Virtual Network + Subnet
############################################################################
resource "azurerm_virtual_network" "my_vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
}

resource "azurerm_subnet" "my_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.my_resource_group.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = var.subnet_address_prefixes
}

############################################################################
# 4) Availability Set (avec managed = true)
############################################################################
resource "azurerm_availability_set" "my_availability_set" {
  name                         = var.availability_set_name
  resource_group_name          = azurerm_resource_group.my_resource_group.name
  location                     = azurerm_resource_group.my_resource_group.location
  platform_fault_domain_count  = var.availability_set_fault_domain_count
  platform_update_domain_count = var.availability_set_update_domain_count
  managed                      = var.availability_set_managed
}

############################################################################
# 5) Network Interface (NIC)
############################################################################
resource "azurerm_network_interface" "my_nic" {
  name                = var.nic_name
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name

  ip_configuration {
    name                          = var.nic_ip_config_name
    subnet_id                     = azurerm_subnet.my_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

############################################################################
# 6) Virtual Machine
############################################################################
resource "azurerm_virtual_machine" "my_vm" {
  name                  = var.vm_name
  resource_group_name   = azurerm_resource_group.my_resource_group.name
  location              = azurerm_resource_group.my_resource_group.location
  availability_set_id   = azurerm_availability_set.my_availability_set.id
  network_interface_ids = [azurerm_network_interface.my_nic.id]

  vm_size                          = var.vm_size
  delete_os_disk_on_termination    = var.vm_delete_os_disk_on_termination
  delete_data_disks_on_termination = var.vm_delete_data_disks_on_termination

  storage_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }

  storage_os_disk {
    name              = "${var.vm_name}-OSDisk"
    caching           = var.vm_os_disk_caching
    create_option     = var.vm_os_disk_create_option
    managed_disk_type = var.vm_os_disk_managed_disk_type
  }

  os_profile {
    computer_name  = var.vm_computer_name
    admin_username = var.vm_admin_username
    admin_password = var.vm_admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = var.vm_disable_password_authentication
  }
}
