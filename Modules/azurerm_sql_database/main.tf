resource "azurerm_mssql_database" "mssql_database" {
  name         = var.mssql_name
  server_id    = var.server_id
}
