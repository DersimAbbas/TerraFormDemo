
provider "azurerm" {
    features {
      
    }
    
  
  }
  resource "azurerm_resource_group" "example" {
    name = "RG-TerraformTest"
    location = "Sweden Central"
  }

resource "azurerm_service_plan" "example" {
  name                = "Terraform-Webapp_plan"
  resource_group_name = "RG-TerraformTest"
  location            = azurerm_resource_group.example.location
  os_type             = "Linux"
  sku_name = "B1"

}

resource "azurerm_linux_web_app" "example" {
  name                = "TerraformDersimAbbasTestDemo"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id
  https_only = true
  enabled = true
  
  site_config {}
}