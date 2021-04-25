

Ответ на 1:

Какое значение будет присвоено переменной c?
```
Ответ: никакое, так как складываем цифру и текст.
```
Как получить для переменной c значение 12?
```
a = 1
b = '2'
c = str(a) + b
print (c)
```
Как получить для переменной c значение 3?
```
a = 1
b = '2'
c = a + int(b)
print (c)
```

Ответ сразу на 2 и 3 задания:


``` 
import os 
a = input("enter DIR: ")
                                                                                                      
bash_command = [ a, "git status -s"] 
result_os = os.popen (' && '.join(bash_command)).read() 
is_change = False 
                                                                                                      
for result in result_os.split('\n'): 
    if result.find('??') !=-1: 
        prepare_result = result.replace('??', 'Не отслеживаемые:')                                    
        print(prepare_result)                                                                         
    elif result.find('M') !=-1: 
            prepare_result2 = result.replace('M', 'Новые измененные:')                                
            print(prepare_result2)                                                                    
    elif result.find('A') != -1: 
            prepare_result3 = result.replace('A', 'Новые не измененные:')                             
            print(prepare_result3)                                                                    
   ```                                                                       

ответ на 4:

``` 
import socket

lookupList = []

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
        line = file.readline()

with open('/home/algus/py.txt', 'wt') as file:
    for line in lookupList:
        file.write(line + '\n')
```
