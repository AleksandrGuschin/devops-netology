
## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде


## Ответ

Так как образ elasticsearch по умолчанию использует centos:7 можно собрать docker-compose.yml с некоторыми правками:
```

   version: '2.2'
services:
  es01:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.13.2
    container_name: es01
    environment: 
      - PATH=/var/lib:$PATH
      - node.name=es01
      - cluster.name=netology_test
      - discovery.seed_hosts=es02,es03
      - cluster.initial_master_nodes=es01,es02,es03
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - data01:/usr/share/elasticsearch/data
    ports:
      - 9200:9200
    networks:
      - elastic
  es02:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.13.2
    container_name: es02
    environment:
      - PATH=/var/lib:$PATH
      - node.name=es02
      - cluster.name=netology_test
      - discovery.seed_hosts=es01,es03
      - cluster.initial_master_nodes=es01,es02,es03
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - data02:/usr/share/elasticsearch/data
    networks:
      - elastic
  es03:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.13.2
    container_name: es03
    environment:
      - PATH=/var/lib:$PATH
      - node.name=es03
      - cluster.name=netology_test
      - discovery.seed_hosts=es01,es02
      - cluster.initial_master_nodes=es01,es02,es03
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - data03:/usr/share/elasticsearch/data
    networks:
      - elastic

volumes:
  data01:
    driver: local
  data02:
    driver: local
  data03:
    driver: local

networks:
  elastic:
    driver: bridge 
 
```
```
algus@pc:~/es$ curl -X GET 'http://localhost:9200/'
{
  "name" : "netology_test1",
  "cluster_name" : "netology_test",
  "cluster_uuid" : "_na_",
  "version" : {
    "number" : "7.12.1",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "3186837139b9c6b6d23c3200870651f10d3343b7",
    "build_date" : "2021-04-20T20:56:39.040728659Z",
    "build_snapshot" : false,
    "lucene_version" : "8.8.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```
<https://hub.docker.com/repository/docker/aleksandrguschin/elasticsearch>

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

## Ответ

```
curl -X PUT 'http://localhost:9200/ind-1?pretty ' -H 'Content-Type: application/json' -d'
 {
   "settings": {
       "number_of_shards": 1,
       "number_of_replicas": 0
     }
   }
   '

curl -X PUT 'http://localhost:9200/ind-1?pretty ' -H 'Content-Type: application/json' -d'
 {
   "settings": {
       "number_of_shards": 2,
       "number_of_replicas": 1
     }
   }
   '
   
   
curl -X PUT 'http://localhost:9200/ind-1?pretty ' -H 'Content-Type: application/json' -d'
 {
   "settings": {
       "number_of_shards": 2,
       "number_of_replicas": 4
     }
   }
   '
   ```
#так как в моем композ файле добавлены три ноды, то реплики работают корректно... Соответственно все индексы в состоянии green. 

```
algus@pc:~/es$ curl 'localhost:9200/_cat/indices?v&pretty'
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 Wmyk4UigQLeMYCy6TOp4Og   1   0          0            0       208b           208b
green  open   ind-3 JR9KYHTdSOe2XYyJxwki8g   4   2          0            0      2.4kb           832b
green  open   ind-2 iZD-kGe_T6W2W4RUa_1Fbg   2   1          0            0       832b           416b
```

```
algus@pc:~/es$ curl -X DELETE "localhost:9200/ind-1?pretty"
{
  "acknowledged" : true
}
algus@pc:~/es$ curl -X DELETE "localhost:9200/ind-2?pretty"
{
  "acknowledged" : true
}
algus@pc:~/es$ curl -X DELETE "localhost:9200/ind-3?pretty"
{
  "acknowledged" : true
}
```

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`


## Ответ

```
[root@a06d1b45870d elasticsearch]# mkdir snapshots
[root@a06d1b45870d elasticsearch]# ls
bin  config  data  jdk	lib  LICENSE.txt  logs	modules  NOTICE.txt  plugins  README.asciidoc  snapshots
```


```
algus@pc:~/es$ sudo docker exec -it es01 bash
[root@bd04b64c889d elasticsearch]# mkdir snapshots

curl -X PUT 'http://localhost:9200/_snapshot?pretty ' -H 'Content-Type: application/json' -d'
{


echo path.repo: /elasticsearch/snapshots >> /elasticsearch-7.12.1/config/elasticsearch.yml
