## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

## Ответ

```
mysql> \s
--------------
mysql  Ver 8.0.25 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		18
Current database:	test_db
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.25 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			52 min 10 sec

Threads: 2  Questions: 50  Slow queries: 0  Opens: 162  Flush tables: 3  Open tables: 80  Queries per second avg: 0.015
--------------
```
```
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
```
```
mysql> SELECT COUNT(*) FROM orders WHERE price > 300;
+----------+
| COUNT(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)

```
## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

## Ответ

```
mysql> CREATE USER 'test'
    -> IDENTIFIED WITH mysql_native_password BY 'test-pass'
    -> WITH MAX_QUERIES_PER_HOUR 100
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3
    -> ATTRIBUTE '{"Name": "James", "lname":"Pretty"}';
Query OK, 0 rows affected (0.01 sec)

GRANT SELECT ON test_db.* TO 'test';
Query OK, 0 rows affected (0.01 sec)

SHOW GRANTS FOR 'test';
+-------------------------------------------+
| Grants for test@%                         |
+-------------------------------------------+
| GRANT USAGE ON *.* TO `test`@`%`          |
| GRANT SELECT ON `test_db`.* TO `test`@`%` |
+-------------------------------------------+
2 rows in set (0.00 sec)

mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE user='test';
+------+------+--------------------------------------+
| USER | HOST | ATTRIBUTE                            |
+------+------+--------------------------------------+
| test | %    | {"Name": "James", "lname": "Pretty"} |
+------+------+--------------------------------------+
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

## Ответ


Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.
```
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> select count(*) from orders;
+----------+
| count(*) |
+----------+
|        5 |
+----------+
1 row in set (0.00 sec)

mysql> SHOW PROFILES;
+----------+------------+-----------------------------+
| Query_ID | Duration   | Query                       |
+----------+------------+-----------------------------+
|        1 | 0.00089350 | select count(*) from orders |
+----------+------------+-----------------------------+
1 row in set, 1 warning (0.00 sec)
```
Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

```
mysql> SHOW TABLE STATUS FROM test_db LIKE 'orders'\G;
*************************** 1. row ***************************
           Name: orders
         Engine: InnoDB
        Version: 10
     Row_format: Dynamic
           Rows: 5
 Avg_row_length: 3276
    Data_length: 16384
Max_data_length: 0
   Index_length: 0
      Data_free: 0
 Auto_increment: 6
    Create_time: 2021-06-09 19:02:07
    Update_time: 2021-06-09 19:02:07
     Check_time: NULL
      Collation: utf8mb4_0900_ai_ci
       Checksum: NULL
 Create_options: 
        Comment: 
1 row in set (0.00 sec)

#Engine: InnoDB
```


Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`

```
mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.08 sec)
Records: 5  Duplicates: 0  Warnings: 0
```
- на `InnoDB`
        
```
mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.10 sec)
Records: 5  Duplicates: 0  Warnings: 0
```
```
|        6 | 0.00079700 | ALTER TABLE test_db ENGINE = MyISAM          |
|        7 | 0.07371225 | ALTER TABLE orders ENGINE = MyISAM           |
|        8 | 0.09714225 | ALTER TABLE orders ENGINE = InnoDB           |
```


## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

## Ответ

```
algus@pc:~$ cd  /etc/mysql
algus@pc:/etc/mysql$ nano my.cnf
```
Далее конфигугрируем MySQL в соответствии с оборудованием и требованиями.

Для требований из задачи 4 необходимо установить следующие параметры:


Скорость IO важнее сохранности данных

```
#Для этого нам потребуется параметр
 
 innodb_flush_log_at_trx_commit  =  0

#Значение “0” даст наибольшую производительность. 
```

Нужна компрессия таблиц для экономии места на диске

```
innodb_file_per_table

или

innodb_file_per_table = 1 
```

Размер буффера с незакомиченными транзакциями 1 Мб 

```
innodb_log_buffer_size = 1M
```

Буффер кеширования 30% от ОЗУ

```
innodb_buffer_pool_size = 300M
#Ещё один важный момент при настройке innodb_buffer_pool_size  — отключение 
#«двойной буферизации» — и операционной системой, и системой InnoDB.
innodb_flush_method=O_DIRECT
```

