#imagem leve e estavel para micro app
FROM python:3.14.3-alpine3.23

#define o diretorio de trabalho dentro do container
WORKDIR /app

#copia o arquivo de dependencias para o container
COPY app/requirements.txt .

#instala as dependencias e o limpa o cache
RUN pip install --no-cache-dir -r requirements.txt

#copia o codigo da aplicacao para o container
COPY app .

#expoe a porta 8000
EXPOSE 8000

#comando de entrada para iniciar a aplicacao
CMD [python, "main.py"]