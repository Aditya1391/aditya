resource "azurerm_resource_group" "example1" {
    
  name     = var.rgname1
  location = var.location1
}

resource "azurerm_resource_group" "example2" {
  name     = var.rgname2
  location = var.location2
}

resource "azurerm_resource_group" "example3" {
  name     = var.rgname3
  location = var.location3
}