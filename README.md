# pub_ecs_laravel_infra

## 構成図

![](./docs/インフラ構成図.png)

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

## RDSのパスワード
system managerに手動で作成

```
$ aws ssm get-parameters --name "dev-db" --region=us-east-1 | jq  -r ".Parameters[].Value"
```