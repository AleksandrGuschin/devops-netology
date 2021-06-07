## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

## Ответ

```
version: '3.1'

services:

  db:
    image: postgres:12
    restart: always
    volumes:   
       - ./home/algus/sqlbackup
    environment:
      POSTGRES_PASSWORD: example

  adminer:
    image: adminer
    restart: always
    ports:
      - 8080:8080   
```
![](https://github.com/AleksandrGuschin/devops-netology/blob/main/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%20%D0%BE%D1%82%202021-06-06%2018-59-02.png)


## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

## ответ
итоговый список БД после выполнения пунктов выше

![](https://github.com/AleksandrGuschin/devops-netology/blob/main/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%20%D0%BE%D1%82%202021-06-06%2019-34-21.png)

описание таблиц (describe)

![](https://github.com/AleksandrGuschin/devops-netology/blob/main/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%20%D0%BE%D1%82%202021-06-06%2020-44-11.png)


SQL-запрос для выдачи списка пользователей с правами над таблицами test_d
и
список пользователей с правами над таблицами test_db

![](https://github.com/AleksandrGuschin/devops-netology/blob/main/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%20%D0%BE%D1%82%202021-06-06%2020-38-33.png)

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.


## Ответ

вычислите количество записей для каждой таблицы 
```
test_db=# SELECT COUNT(*) from clients;
     5

test_db=# SELECT COUNT(*) from orders;
     5
```

- приведите в ответе:
    - запросы 
    - результаты их выполнения.
```

INSERT INTO orders (id, наименование, цена) VALUES (
1, 'Шоколад', 10), 
(2, 'Принтер', 3000), 
(3, 'Книга', 500), 
(4, 'Монитор', 7000), 
(5, 'Гитара', 4000);
```
```
INSERT INTO clients (id, ФИО, страна_проживания) VALUES 
(1, 'Иванов Иван Иванович', 'USA'), 
(2, 'Петров Петр Петрович', 'Canada'), 
(3, 'Иоганн Себастьян Бах', 'Japan'), 
(4, 'Ронни Джеймс Дио', 'Russia'),
(5, 'Ritchie Blackmore', 'Russia');
```


![](https://github.com/AleksandrGuschin/devops-netology/blob/main/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%20%D0%BE%D1%82%202021-06-07%2021-10-03.png)

![](https://github.com/AleksandrGuschin/devops-netology/blob/main/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%20%D0%BE%D1%82%202021-06-07%2021-11-44.png)




## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 


