#imagem leve e estavel para micro app
FROM python:3.14.3-alpine3.23

#Criacao de usuario/grupo de dicado e nao-privilegiado
RUN addgroup -S appgrp -g 10001 \
 && adduser  -S appuser -G appgrp -u 10001 -h /app -D

#Instalacao do curl para monitoramento por HealthCheck
RUN apk add --no-cache curl

#define o diretorio de trabalho dentro do container
WORKDIR /app

#copia o codigo da aplicacao e requisitos e instala dependencias
COPY app/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt
COPY app/ /app/

#atribuicao de permissao para o usuario dedicado
RUN chown -R appuser:appgrp /app

#uso do usuario nao-root
USER appuser:appgrp

#expoe a porta 8000
EXPOSE 8000

#Configuracao do HealthCheck (execucao a cada 30 segundos)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -fsS http://127.0.0.1:8000/health || exit 1

#comando de entrada para iniciar a aplicacao
CMD ["python", "app.py"]