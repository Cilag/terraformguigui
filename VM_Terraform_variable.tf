variable "backend_rg_name" {
  default = "rg-terraform-state"
}
variable "backend_storage_account_name" {
  default = "terraformgregouz"
}
variable "backend_container_name" {
  default = "tfstate"
}
variable "backend_key" {
  default = "vm_deploy.tfstate"
}
variable "backend_access_key" {
  default = "MmR/Rj5C2bql6Qro17XhTH1EUljiUMc2mtYUSCNH4gR9/r18PklvC3Gs0RmJMroAZ8+MemGTgjy2+AStVXrfng=="
}

# === 2) Provider AzureRM ===
variable "subscription_id" {
  description = "ID de la subscription Azure dans laquelle on déploie."
  type        = string
  default     = "5f13b879-49c5-44a1-8328-0b128ab8b9a2"
}

# === 3) Resource Group principal ===
variable "rg_name" {
  description = "Nom du Resource Group qui contiendra VNet, Subnet, NIC, VM."
  type        = string
  default     = "rg-terraform-state-1"
}

variable "rg_location" {
  description = "Région Azure où sera créé le Resource Group principal."
  type        = string
  default     = "West Europe"
}

# === 4) Virtual Network & Subnet ===
variable "vnet_name" {
  description = "Nom du Virtual Network."
  type        = string
  default     = "vnett-terraform-state"
}

variable "vnet_address_space" {
  description = "Liste des plages CIDR du Virtual Network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Nom du Subnet."
  type        = string
  default     = "subnett-terraform-state"
}

variable "subnet_address_prefixes" {
  description = "Liste des préfixes CIDR du Subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

# === 5) Availability Set ===
variable "availability_set_name" {
  description = "Nom de l’Availability Set."
  type        = string
  default     = "test-terraform-state-AS"
}

variable "availability_set_fault_domain_count" {
  description = "Nombre de fault domains pour l’Availability Set."
  type        = number
  default     = 2
}

variable "availability_set_update_domain_count" {
  description = "Nombre de update domains pour l’Availability Set."
  type        = number
  default     = 2
}

variable "availability_set_managed" {
  description = "Indique si l’Availability Set est en mode géré."
  type        = bool
  default     = true
}

# === 6) Network Interface (NIC) ===
variable "nic_name" {
  description = "Nom de la Network Interface (NIC)."
  type        = string
  default     = "test-terraform-state-NIC"
}

variable "nic_ip_config_name" {
  description = "Nom de la configuration IP dans la NIC."
  type        = string
  default     = "test-terraform-state-NIConf"
}

# === 7) Virtual Machine ===
variable "vm_name" {
  description = "Nom de la Virtual Machine."
  type        = string
  default     = "test-terraform-state-VM"
}

variable "vm_size" {
  description = "Taille de la Virtual Machine."
  type        = string
  default     = "Standard_B1s"
}

variable "vm_delete_os_disk_on_termination" {
  description = "Supprimer le disque OS à la terminaison de la VM."
  type        = bool
  default     = true
}

variable "vm_delete_data_disks_on_termination" {
  description = "Supprimer les disques de données à la terminaison de la VM."
  type        = bool
  default     = true
}

# -- Image d’OS --
variable "vm_image_publisher" {
  description = "Publisher de l’image de la VM."
  type        = string
  default     = "Canonical"
}

variable "vm_image_offer" {
  description = "Offer de l’image de la VM."
  type        = string
  default     = "0001-com-ubuntu-server-focal"
}

variable "vm_image_sku" {
  description = "SKU de l’image de la VM."
  type        = string
  default     = "20_04-lts-gen2"
}

variable "vm_image_version" {
  description = "Version de l’image de la VM."
  type        = string
  default     = "latest"
}

# -- OS Disk --
variable "vm_os_disk_caching" {
  description = "Méthode de caching du disque OS."
  type        = string
  default     = "ReadWrite"
}

variable "vm_os_disk_create_option" {
  description = "Option de création du disque OS."
  type        = string
  default     = "FromImage"
}

variable "vm_os_disk_managed_disk_type" {
  description = "Type de stockage du disque OS."
  type        = string
  default     = "Premium_LRS"
}

# -- OS Profile --
variable "vm_computer_name" {
  description = "Nom machine (hostname) à l’intérieur de la VM."
  type        = string
  default     = "test-terraform-ubuntu"
}

variable "vm_admin_username" {
  description = "Nom d’utilisateur administrateur pour la VM."
  type        = string
  default     = "adminuser"
}

variable "vm_admin_password" {
  description = "Mot de passe administrateur pour la VM (sensible)."
  type        = string
  sensitive   = true
  default     = "Password1234!"
}

variable "vm_disable_password_authentication" {
  description = "Désactiver l’authentification par mot de passe pour la VM."
  type        = bool
  default     = false
}