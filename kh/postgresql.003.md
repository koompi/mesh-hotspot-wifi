```
DEV: 001
Title: PostgreSQL
Author: Heng Hongsea
Status: Active
Create: 2020-06-16
Update: NA
version: 0.1.0
```

# PostgreSQL

#### Run posgres on docker

### Install package

```console
sudo apt install docker
sudo apt install docker-compose
```

### You need start service docker

```console
sudo systemctl enable docker
sudo systemctl start docker
```

### create this file:  `docker-compose.yml`

```console
version: "3"
services:
 posgresdb:
    image: postgres
    restart: always
    volumes:
      - ./dbs:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: Adminer
      POSTGRES_PASSWORD: Adminer
    ports:
      - 5432:5432

 adminer:
    image: adminer
    restart: always
    ports:
      - 8088:8080
    depends_on:
      - posgresdb
```

Run docker compose

```console
sudo docker-compose up -d
```