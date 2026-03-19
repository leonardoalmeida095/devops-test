# Baixa a imagem do registry do GHCR baseada na variável
resource "docker_image" "app_image" {
  name         = var.image_name
  keep_locally = true
}

# criacao do container usando a imagem do GHCR e conectando a rede criada
resource "docker_container" "app_container" {
  name  = "devops_test_app"
  image = docker_image.app_image.image_id

  networks_advanced {
    name = docker_network.app_network.name
  }

  # expoe a aplicacao na porta 8000
  ports {
    internal = 8000
    external = 8000
  }
}