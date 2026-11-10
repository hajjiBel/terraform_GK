# État distant : indispensable en CI/CD.
# Chaque exécution du pipeline démarre sur une machine neuve : un état local serait perdu.
# Configuration partielle (comme au lab 11) : le groupe et le compte de stockage sont fournis à l'init :
#   terraform init -backend-config="resource_group_name=$TFSTATE_RG" \
#                  -backend-config="storage_account_name=$TFSTATE_SA"

terraform {
  backend "azurerm" {
    container_name = "tfstate"
    key            = "lab17/pipeline.tfstate"
  }
}
