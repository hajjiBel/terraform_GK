# Lab 17 — Infrastructure déployée par le pipeline : un site web statique dans un Storage Account
# Volontairement simple et rapide (≈ 1 min) : le sujet du lab est le pipeline, pas l'infrastructure.

terraform {
  required_version = ">= 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# Aucun identifiant dans le code : le provider lit ARM_CLIENT_ID, ARM_CLIENT_SECRET,
# ARM_TENANT_ID et ARM_SUBSCRIPTION_ID (variables d'environnement, secrets GitHub dans le pipeline).
provider "azurerm" {
  features {}
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.identity}-lab17"
  location = var.location

  tags = {
    ManagedBy = "GitHub Actions"
  }
}

resource "azurerm_storage_account" "web" {
  # 3 à 24 caractères, minuscules et chiffres, unique dans tout Azure
  name                     = substr("stweb${random_string.suffix.result}${var.identity}", 0, 24)
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

# Active l'hébergement de site statique (crée le conteneur spécial $web)
resource "azurerm_storage_account_static_website" "web" {
  storage_account_id = azurerm_storage_account.web.id
  index_document     = "index.html"
}

# La page d'accueil, générée à partir d'un modèle
resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.web.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html; charset=utf-8"

  source_content = templatefile("${path.module}/site/index.html.tftpl", {
    identity    = var.identity
    message     = var.message
    environment = var.environment
  })

  depends_on = [azurerm_storage_account_static_website.web]
}
