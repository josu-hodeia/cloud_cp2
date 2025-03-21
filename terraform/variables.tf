variable "localizacion" {
  description = "Región de Azure para los recursos"
  type        = string
  default     = "westeurope"
}

variable "grupo_de_recursos" {
  description = "Grupo de recursos en azure"
  type        = string
  default     = "rg-caso-practico2-jbr"
}