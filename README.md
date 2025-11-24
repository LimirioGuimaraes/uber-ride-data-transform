# SBD2---Grupo-16

[Acesse o BI aqui.](https://app.powerbi.com/view?r=eyJrIjoiNzJkN2Y0MTMtOWI4Ny00MTEyLTk1MjgtZTE3NWUwZTA5MTdmIiwidCI6ImVjMzU5YmExLTYzMGItNGQyYi1iODMzLWM4ZTZkNDhmODA1OSJ9) 

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

Para se conectar com o banco com o page admin. As credenciais são:

| Parâmetro     | Valor       |
| ------------- | ----------- |
| **Host name** | `localhost` |
| **Port**      | `5432`      |
| **Username**  | `admin`     |
| **Password**  | `admin`     |
| **Database**  | `postgres`  |

Após isso rode o script `transformer\etl_raw_to_silver.ipynb`, para popular o banco com os dados já tratados.

# Silver
Para rodar o script DDL:

```bash
cat .\data_layer\silver\DDL.sql | docker exec -i postgres psql -U admin -d postgres
```

# DW

Para rodar o script DDL:

```bash
cat .\data_layer\gold\DDL.sql | docker exec -i postgres psql -U admin -d postgres
```
