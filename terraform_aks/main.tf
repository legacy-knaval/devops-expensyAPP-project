resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# -----------------------
# VNET + SUBNET PARA AKS
# -----------------------

resource "azurerm_virtual_network" "vnet" {
  name                = "aks-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.0.0/16"]
}

# -----------------------
# ACR
# -----------------------

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# -----------------------
# AKS
# -----------------------

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "knavalaks"

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_B2s_v2"
    vnet_subnet_id  = azurerm_subnet.aks_subnet.id
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    service_cidr       = "10.2.0.0/24"
    dns_service_ip     = "10.2.0.10"
  }
}

# -----------------------
# ACR PULL PERMISSIONS
# -----------------------

resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}