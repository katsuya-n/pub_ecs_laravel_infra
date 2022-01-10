# pub_ecs_laravel_infra

## 起動

```
$ cd envs/dev/ 
$ touch terraform.tfvars
```

terraform.tfvarsを編集

```
# ALBにアクセスするIPを記載
allow_cidr_block = "XXX.XXX.XXX.XXX/32"
```


```
$ terraform init
$ terraform apply
```

ECRには手動でdocker imageをpushしておく

```Dockerfile
FROM httpd:2.4
```

ALBのDNS名にブラウザからアクセスすると`It works!`が表示されることを確認