module "resource_group" {
  source                  = "../Modules/azurerm_resource_group"
  resource_group_name     = "vishnu-rg"
  resource_group_location = "Central US"
}
module "virtual_network" {
  depends_on               = [module.resource_group]
  source                   = "../Modules/azurerm_virtual_network"
  virtual_network_name     = "todovnet001"
  virtual_network_location = "Central US"
  resource_group_name      = "vishnu-rg"
  address_space            = ["10.0.0.0/16"]
}
module "subnet_frontend" {
  source     = "../Modules/azurerm_subnet"
  depends_on = [module.virtual_network]

  subnet_name          = "frontend-subnet"
  resource_group_name  = "vishnu-rg"
  virtual_network_name = "todovnet001"
  address_prefixes     = ["10.0.1.0/24"]
}
module "backend_subnet" {
  source     = "../Modules/azurerm_subnet"
  depends_on = [module.virtual_network]

  subnet_name          = "backend-subnet"
  resource_group_name  = "vishnu-rg"
  virtual_network_name = "todovnet001"
  address_prefixes     = ["10.0.2.0/24"]
}
module "frt_pip" {
  depends_on          = [module.resource_group]
  source              = "../Modules/azurerm_public_ip"
  public_ip_name      = "todopip-frt"
  location            = "Central US"
  resource_group_name = "vishnu-rg"
  allocation_method   = "Static"
}
module "bck_pip" {
  depends_on          = [module.resource_group]
  source              = "../Modules/azurerm_public_ip"
  public_ip_name      = "todopip-bck"
  location            = "Central US"
  resource_group_name = "vishnu-rg"
  allocation_method   = "Static"
}
module "sql_server" {
  depends_on                   = [module.resource_group]
  source                       = "../Modules/azurerm_sql_server"
  server_name                  = "todo-server002"
  resource_group_name          = "vishnu-rg"
  location                     = "Central US"
  administrator_login          = "azureadmin"
  administrator_login_password = "India@123456"
}
module "mssql_database" {
  depends_on = [module.sql_server]
  source     = "../Modules/azurerm_sql_database"
  mssql_name = "mssql_database"
  server_id  = "/subscriptions/8c7f87da-a447-4222-8e07-a8253eaea14b/resourceGroups/vishnu-rg/providers/Microsoft.Sql/servers/todo-server002"
}
module "frontend_vm" {
  depends_on = [module.subnet_frontend, module.frt_pip]
  source     = "../Modules/azurerm_virtual_machine"

  nic_name             = "todo-frontnic"
  location             = "Central US"
  resource_group_name  = "vishnu-rg"
  public_ip_address_id = "/subscriptions/8c7f87da-a447-4222-8e07-a8253eaea14b/resourceGroups/vishnu-rg/providers/Microsoft.Network/publicIPAddresses/todopip-frt"
  subnet_id            = "/subscriptions/8c7f87da-a447-4222-8e07-a8253eaea14b/resourceGroups/vishnu-rg/providers/Microsoft.Network/virtualNetworks/todovnet001/subnets/frontend-subnet"
  vm_name              = "todo-frontendvm"
  size                 = "Standard_B1s"
  admin_username       = "azureadmin"
  admin_password       = "India@123456"
  publisher            = "Canonical"
  offer                = "0001-com-ubuntu-server-focal"
  sku                  = "20_04-lts"

}

module "backend_vm" {
  depends_on           = [module.backend_subnet, module.bck_pip]
  source               = "../Modules/azurerm_virtual_machine"
  nic_name             = "todo-backnic"
  location             = "Central US"
  resource_group_name  = "vishnu-rg"
  public_ip_address_id = "/subscriptions/8c7f87da-a447-4222-8e07-a8253eaea14b/resourceGroups/vishnu-rg/providers/Microsoft.Network/publicIPAddresses/todopip-bck"
  subnet_id            = "/subscriptions/8c7f87da-a447-4222-8e07-a8253eaea14b/resourceGroups/vishnu-rg/providers/Microsoft.Network/virtualNetworks/todovnet001/subnets/backend-subnet"
  vm_name              = "todo-backendvm"
  size                 = "Standard_B1s"
  admin_username       = "azureadmin"
  admin_password       = "India@123456"
  publisher            = "Canonical"
  offer                = "0001-com-ubuntu-server-focal"
  sku                  = "20_04-lts"
}
# module "key_vault" {
#   source              = "../Modules/azurerm_key_vault"
#   depends_on          = [resource_group]
#   name                = "todo-keyvault"
#   location            = "Central US"
#   resource_group_name = "vishnu-rg"
#   tenant_id           = "c8322656-5c2b-4769-8e53-4bcc906bb52c"
# }
