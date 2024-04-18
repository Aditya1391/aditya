resource "azurerm_resource_group" "RG" {
  name     = "Embassy_RG"
  location = "West Europe"
}

resource "azurerm_virtual_network" "VNET" {
  name                = "Embassy-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
}

resource "azurerm_subnet" "SUBNET" {
  name                 = "FRONTEND"
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.VNET.name
  address_prefixes     = ["10.0.2.0/24"]

}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_public_ip" "pip" {
  name                = "Embassy-PIP"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  allocation_method   = "Static"


}

resource "azurerm_network_interface" "NIC" {
  name                = "Embassy-nic"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SUBNET.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "VM" {
  name                = "Embassy-machine"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password = "Pass@12341234"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.NIC.id,
  ]

  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
