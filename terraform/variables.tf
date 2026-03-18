# definicao da variavel para a imagem docker, apontando para o repositorio no GHCR
variable "image_name" {
  description = "URI da imagem Docker no GHCR"
  type        = string
  default     = "ghcr.io/leonardoalmeida095/devops-test:latest" 
}