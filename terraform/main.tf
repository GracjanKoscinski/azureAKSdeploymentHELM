resource "azurerm_resource_group" "myterraformgroup" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "myterraformvnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
}

resource "azurerm_subnet" "myterraformsubnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformvnet.name
  address_prefixes     = [var.subnet_address_prefix]
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  dns_prefix          = "my-k8s"
  kubernetes_version  = "1.29.2"

  default_node_pool {
    name            = "default"
    node_count      = var.aks_node_count
    vm_size         = var.aks_node_vm_size
    os_disk_size_gb = 30
    vnet_subnet_id  = azurerm_subnet.myterraformsubnet.id
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}