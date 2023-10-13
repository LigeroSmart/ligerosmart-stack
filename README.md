# LigeroSmart Stack

Configuração básica para instanciar serviços do LigeroSmart

# Script de instalação

O comando abaixo serve tanto para fazer a instalação dos pré-requisitos quanto para subir uma stack do LigeroSmart
```
curl https://get.ligerosmart.com | sh
```

# Pré-requisitos

* arquivos deste repositório

# Comandos para iniciar uma instância nova
```
docker-compose up
```
Lembrando que este comando deve ser sempre rodado no diretório onde se encontra o arquivo docker-compose.yml

## Usando make
```
make up
```
Você pode usar ainda outros parâmetros. Consulte o comando `make help`


# Primeiro acesso

O ambiente será configurado e funcionará na porta 8008

Na primeira execução o sistema é configurado para você. Aguarde até que todas as configurações sejam aplicadas.
A tela de login será carregada automaticamente ao final da configuração.

* Endereço: http://localhost/otrs/
* Usuário: root@localhost
* Senha: ligero

Informações de acesso do Grafana:
* Endereço: http://localhost/grafana/
* Usuário: admin
* Senha: ligero

Informações de acesso do Elasticsearch:
* Endereço: http://localhost/elasticsearch/
* Para acessar é preciso [editar o docker-compose.yml](https://github.com/LigeroSmart/ligerosmart-stack/blob/29cba5cc221b4dbbbf9ce7d0cdeb97985b496d77/docker-compose.yml#L113) e incluir o usuário e hash de senha no formato do htpasswd. Você pode gerar um com o https://hostingcanada.org/htpasswd-generator/


Caso queira acessar remotamente, troque o endereço localhost pelo IP do seu servidor

# Documentação

Veja em https://docs.ligerosmart.org


