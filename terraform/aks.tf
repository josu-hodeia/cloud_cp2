resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "aks-cp2-jbr"
  location            = azurerm_resource_group.caso_practico_2.location
  resource_group_name = azurerm_resource_group.caso_practico_2.name
  dns_prefix          = "casopractico2"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
  }
}
