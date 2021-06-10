## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

## Ответ

 ```
docker run --name dzpostgres -e POSTGRES_PASSWORD=password -d -v posgresv:/home/algus/posgres postgres:13

root@pc:/home/algus# docker exec -it 1e5326b6d7a1 bash
root@1e5326b6d7a1:/# su postgres
postgres@1e5326b6d7a1:/$ psql
psql (13.3 (Debian 13.3-1.pgdg100+1))
Type "help" for help.

Postgres=# \?
```

вывод списка БД
```
\l[+]   [PATTERN]      list databases
```

подключение к БД
```
\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
```
вывод списка таблиц
```
\dt[S+] [PATTERN]      list tables
```
вывод описания содержимого таблиц
```
\d[S+]  NAME           describe table, view, sequence, or index
```
выход из psql

```
\q                     quit psql
```
