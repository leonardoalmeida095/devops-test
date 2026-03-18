# criacao da rede docker
resource "docker_network" "app_network" {
  name = "devops_network"
}