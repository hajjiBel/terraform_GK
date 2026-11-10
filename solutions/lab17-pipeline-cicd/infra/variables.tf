variable "identity" {
  description = "Identifiant unique du participant"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,12}$", var.identity))
    error_message = "identity : 3 à 12 caractères, minuscules et chiffres uniquement."
  }
}

variable "location" {
  description = "Région Azure"
  type        = string
  default     = "francecentral"
}

variable "environment" {
  description = "Nom de l'environnement affiché sur la page"
  type        = string
  default     = "production"
}

variable "message" {
  description = "Message affiché sur la page d'accueil"
  type        = string
  default     = "Bonjour ! Ce site a été déployé par un pipeline."
}
