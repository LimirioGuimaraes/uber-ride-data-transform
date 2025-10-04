# SBD2---Grupo-16

# Como rodar 

Primeiramente é necessário ter o docker instalado em sua máquina

Para subir o serviço, rode:

```bash
docker-compose up
```

Para acessar o container:

```bash
docker exec -it postgres psql -U admin -d postgres
```

No entando o docker também sobe um serviço pgAdmin que pode ser acessado em:

```
http://localhost:8080/login?next=/
```
**E-mail:** admin@admin.com
**Senha:** admin

Após logar, faça a linkagem do nosso banco. As credenciais são:

| Parâmetro     | Valor      |
| ------------- | ---------- |
| **Host name** | `postgres` |
| **Port**      | `5432`     |
| **Username**  | `admin`    |
| **Password**  | `admin`    |
| **Database**  | `postgres` |

Inicialmente o script cria uma tabela teste de nome `users`, você pode visualizá-la em:

```
Databases → postgres → Schemas → public → Tables → users
```

Clique com o botão direito na tabela → View/Edit Data → All Rows. Isso mostrará a tabela.