# Introdução
A solução é responsável por automatizar o ciclo de vida da aplicação, desde o build da imagem Docker, execução de testes automatizados, envio para o GitHub Container Registry (GHCR) e, por fim, o provisionamento da infraestrutura utilizando Terraform com o provider Docker. Todo processo é realizado por meio do GitHub Actions.

## Arquitetura
### A arquitetura é composta por dois blocos principais:  
__Pipeline de Build/Teste/Push:__  
O pipeline é executado no GitHub Actions, sendo responsável por fazer o build da imagem, teste de Health Check e envio para o GitHub Container Registry (GHCR).  
A autenticação é realizada via docker/login-action utilizando GITHUB_TOKEN, conforme as boas prática para publicação de pacotes associados ao repositório.

__Pipeline de Provisionamento em IaC (Terraform):__  
Responsável por provivisionar toda estrutura Docker utilizando o provider kreuzwerker/docker.
O pipeline segue as etapas de criação do recurso de rede (devops_network) e criação do container (devops_test_app) consumindo a imagem previamente enviada ao GHCR

### Representação gráfica do pipeline:  
<img width="1087" height="544" alt="image" src="https://github.com/user-attachments/assets/13a0696e-8fdc-437b-8a17-0d54c5d905d6" />

## Steps do pipeline  
__Job "build-teste-envio"__
1. Checkout do código  
2. Setup Python (3.14.3)  
3. Autenticação no GHCR  
4. Definição da URI da imagem  
5. Build da imagem Docker  
6. Execução do container (porta 8000)  
7. Teste da aplicação (Healthcheck com script externo "monitoramento_hc.sh")  
8. Limpeza do ambiente (remoção do container)  
9. Envio da imagem validada para o GHCR e output do image_uri 

__Job "terraform-deploy"__  
1. Checkout do código  
2. Autenticação no GHCR  
3. Setup do Terraform
4. Inicialização do Terraform (terraform init)  
5. Verificação de formatação (terraform fmt -check)  
6. Validação da estrutura Terraform (terraform validate)  
7. Aplicação da estrutura com aprovação automática (terraform apply)  

## Autenticação no GitHub Container Registry
A autenticação é feita através da action oficial, conforme recomendação da [documentação oficial](https://github.com/docker/login-action).

```
 - name: Login no GHCR
  uses: docker/login-action@v3
  with:
    registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}
 ```

## Requisitos para execução do ambiente
__Para executar o ambiente localmente ou fazer troubleshooting do pipeline, é necessario:__
- Docker instalado e executando.
- Terraform (>=1.0).
- Git instalado com suporte a GitHub.

## Testes locais  
__Testar a aplicação Docker__  
```
docker build -t local/test-app .
docker run -d -p 8000:8000 --name test-app local/test-app
curl -f http://localhost:8000/health
docker rm -f test-app
 ```

__Testar o Terraform localmente__
```
cd terraform
set TF_VAR_image_name=local/test-app (windows) ou export TF_VAR_image_name=local/test-app (linux)
terraform init
terraform validate
terraform apply
```