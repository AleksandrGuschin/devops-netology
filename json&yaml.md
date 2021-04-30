Задача 1. 

С ошибками:

```
{ "info" : "Sample JSON output from our service\t",
    "elements" :[
        { "name" : "first",
        "type" : "server",
        "ip" : 7175 
        },
        { "name" : "second",
        "type" : "proxy",
        "ip : 71.78.22.43
        }
    ]
}
```

Без:
```
{
  "info" : "Sample JSON output from our service\t",
  "elements": [
    {
      "name": "first",
      "type": "server",
      "port": 7175
    },
    {
      "name": "second",
      "type": "proxy",
      "ip": "71.78.22.43"
    }
  ]
}
```

Задача 2.

Создаем два доп.файла, дополняем предыдущий код:

```
import socket
import json
import yaml

lookupList = []
jsonList = []
yamlList = []

with open('/home/algus/py.txt', 'rt') as file:
    line = file.readline()

    while line:
        line = line.split(' ')
        if len(line) > 1:

            try:
                newIp = socket.gethostbyname(line[0])
            except socket.SO_ERROR:
                print('Lookup error!')


            if newIp != line[1].strip():
                print(f'[ERROR] {line[0]} IP mismatch: {line[1].strip()} {newIp}')
            lookupList.append(line[0] + ' ' + newIp)
            jsonList.append({line[0]: newIp})
            yamlList.append(line[0] + ' ' + newIp)
        line = file.readline()

with open('/home/algus/py.txt', 'wt') as file:
    for line in lookupList:
        file.write(line + '\n')

with open('/home/algus/list.json', 'wt') as file:
        json.dump(jsonList, fp=file, indent=2)

with open('/home/algus/list.yaml', 'wt') as file:
        yaml.dump(yamlList, file, default_flow_style=False, explicit_start=True, explicit_end=True)

```
