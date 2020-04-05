# LigeroSmart Stack

Configuração básica do Ligero a partir da imagem com código do OTRS

# Pré-requisitos

* arquivos deste repositório
* docker instalado
* docker-compose instalado

# Comandos para iniciar uma instância nova
```
docker-compose up
```

## Usando make
```
make up
```
Você pode usar ainda outros parâmetros. Consulte o comando `make help`


# Primeiro acesso

O ambiente será configurado e funcionará na porta 8008
* Endereço: http://localhost:8008/otrs/index.pl
* Usuário: root@localhost
* Senha: ligero

Informações de acesso do Grafana:
* Endereço: http://localhost:3000
* Usuário: admin
* Senha: complemento

