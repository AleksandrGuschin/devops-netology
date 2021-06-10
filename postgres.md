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


## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.


## Ответ

```
CREATE DATABASE test_database
postgres-# ;
CREATE DATABASE

root@1e5326b6d7a1:/# psql -U postgres -W test_database < /home/algus/posgres/test_dump.sql
Password: 
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE



postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# 


test_database=# \dt
         List of relations
 Schema |  Name  | Type  |  Owner   
--------+--------+-------+----------
 public | orders | table | postgres
(1 row)

test_database=# ANALYZE orders;
ANALYZE

test_database=# SELECT avg_width FROM pg_stats WHERE tablename = 'orders' ORDER BY avg_width DESC;
 avg_width 
-----------
        16
         4
         4
(3 rows)
```
