## Ответ 1. (необязательное задание)

Создаем аккаунт aws:
```
Account Id:
411766372834 
Seller:
AWS EMEA SARL 
Account Name:
algus90 
Password:
*****
```
Устанавливаем aws cli:
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
Выполняем первичную настройку aws-sli
```
algus@pc:~/tf$ aws configure
AWS Access Key ID [****************L2NY]: 
AWS Secret Access Key [****************7ZrP]: 
Default region name [us-east-1]: 
Default output format [json]: 
```

Для создания IAM политики можно воспользоваться web консолью или добавить код в .tf файл.
Например для AmazonEC2FullAccess он будет такой: 
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "autoscaling.amazonaws.com",
                        "ec2scheduled.amazonaws.com",
                        "elasticloadbalancing.amazonaws.com",
                        "spot.amazonaws.com",
                        "spotfleet.amazonaws.com",
                        "transitgateway.amazonaws.com"
                    ]
                }
            }
        }
    ]
}
```
Вывод команды aws configure list
```
algus@pc:~/tf$ aws configure list
      Name                    Value             Type    Location
      ----                    -----             ----    --------
   profile                <not set>             None    None
access_key     ****************L2NY shared-credentials-file    
secret_key     ****************7ZrP shared-credentials-file    
    region                us-east-1      config-file    ~/.aws/config
    
 ```
    
 ## Ответ 2.
 
 Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?
 с прошлого занятия для создания образа подходит только Packer.
 
 <https://github.com/AleksandrGuschin/terraform>
 
 
