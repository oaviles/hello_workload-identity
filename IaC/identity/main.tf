provider "azurerm" {
  features {}
}

resource "azurerm_user_assigned_identity" "example" {
  name                = "oaIdentity"
  location            = "eastus"
  resource_group_name = "oa-aks-rg"
}

resource "azurerm_federated_identity_credential" "example" {
  name                = "oaFedIdentity"
  resource_group_name = "oa-aks-rg"
  parent_id           = azurerm_user_assigned_identity.example.id
  issuer              = "TYPE HERE YOUR OIDC URI"
  subject             = "system:serviceaccount:default:workload-identity-sa"
  audience            = ["api://AzureADTokenExchange"]
}