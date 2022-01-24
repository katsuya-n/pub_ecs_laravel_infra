# pub_ecs_laravel_infra

## 構成図

![](./docs/インフラ構成図.png)

## 起動

```bash
$ cd envs/dev/ 
$ touch terraform.tfvars
```

terraform.tfvarsを編集

```
# ALBにアクセスするIPを記載
allow_cidr_block = "XXX.XXX.XXX.XXX/32"
```


```bash
$ terraform init
$ terraform apply
```

ECRには手動でdocker imageをpushしておく

```Dockerfile
FROM httpd:2.4
```

ALBのDNS名にブラウザからアクセスすると`It works!`が表示されることを確認

## ECS Exec

```bash
$ aws ecs execute-command --cluster ecs_laravel_pj_dev-ecs \                                                                                                               56.9s  月  1/24 23:00:50 2022
  --task [タスクID] \
  --container app \
  --interactive \
  --command "/bin/bash"
  --region=us-east-1
```