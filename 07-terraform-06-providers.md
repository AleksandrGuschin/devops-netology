## Ответ

1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе.   

`resourse`

<https://github.com/hashicorp/terraform-provider-aws/blob/92f626a8c401d89c1fbc334f064373684c26e281/aws/provider.go#L453>
`data_source`

<https://github.com/hashicorp/terraform-provider-aws/blob/92f626a8c401d89c1fbc334f064373684c26e281/aws/provider.go#L186>



 Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
    
  С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.
        
  <https://github.com/hashicorp/terraform-provider-aws/blob/2747107e43d8821408200c620dcb35c5df1b9672/aws/resource_aws_sqs_queue.go#L61>
   
   ```
    ConflictsWith: []string{"name_prefix"}
   ```
    
  Какая максимальная длина имени? 
  
   
    {1,80}
    
    
  Какому регулярному выражению должно подчиняться имя? 
   ```
   [a-zA-Z0-9_-]
   ```
<https://github.com/hashicorp/terraform-provider-aws/blob/2747107e43d8821408200c620dcb35c5df1b9672/aws/resource_aws_sqs_queue.go#L458>



