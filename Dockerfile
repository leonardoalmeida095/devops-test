#imagem leve e estavel para micro app
FROM python:3.14.3-alpine3.23

#Criacao de usuario/grupo de dicado e nao-privilegiado
RUN addgroup -S appgrp -g 10001 \
 && adduser  -S appuser -G appgrp -u 10001 -h /app -D

#define o diretorio de trabalho dentro do container
WORKDIR /app

#copia o codigo da aplicacao para o container
COPY app . /app/

#instala as dependencias e o limpa o cache
RUN pip install --no-cache-dir -r requirements.txt

#atribuicao de permissao para o usuario dedicado
RUN chown -R appuser:appgrp /app

#uso do usuario nao-root
USER appuser:appgrp

#expoe a porta 8000
EXPOSE 8000

#comando de entrada para iniciar a aplicacao
CMD [python, "app.py"]