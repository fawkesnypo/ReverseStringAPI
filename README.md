# ReverseStringAPI
API para reverter string

Binários:
https://github.com/fawkesnypo/ReverseStringAPI/releases/tag/v1.0

Subir API:

-Windows: 
1. Executar ReverseStringAPI.exe

-Linux: 
1. Instalar fpc (sudo apt-get install fpc)
2. Rodar o comando: fpc ReverseStringAPI.lpr
3. Executar o arquivo gerado: ./ReverseStringAPI

-Docker:
1. Instalar o docker: https://docs.docker.com/engine/install/ubuntu/
2. Habilitar BuildKit: https://docs.docker.com/build/buildkit/
3. Buildar imagem docker: DOCKER_BUILDKIT=1 docker build. -t pascal_api

Subir container com imagem criada: -Comando: docker run -p porta_externa:porta_interna --name nome_do_container -d nome_da_imagem

-Docker-Compose:
1. Subindo docker-compose: docker-compose up
