## Terraform sample
### 資料
+ [getting-started](https://www.terraform.io/intro/getting-started/install.html)
+ [TerraformによるGCP環境の管理](https://gist.github.com/MisaKondo/cb46b0ecd106e9c824a641b14954b8e1)
  + ちょっと古い
+ [managing-gcp-projects-with-terraform](https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform)



### やりたい事
+ GCR
  + pull / push
+ gcloud compute
  + disks: volume作成
  + addresses: 静的IP割り振り
+ container clusters
  + 作成 / 削除
+ kubectl
  + ns作成
  + apply (configmap, secret, lb, volume, mysql, drone)
  + exec, drone database作成


### json keyを発行する
#### 付けるべき権限
+ [権限一覧](https://cloud.google.com/iam/docs/understanding-roles?hl=ja)
+ GCE
  + Podに割り当てるdiskを作る
  + 静的IPの設定
  + その他, GKEから勝手に使われる
+ GKE
  + roles/container.admin
    + Kubernetesクラスタを作る/削除する
+ GCR: コンテナレジストリ
  + roles/cloudbuild.builds.editor
    + Podで使うimageを登録する
+ ※
  + 一つ一つ付けるのはめんどくさすぎるので, 一旦, roles/owner.

#### 作る
+ IAMのサービスアカウントを作成する
```
gcloudp iam service-accounts create terraform-account \
    --display-name terraform-account
```

+ 作ったサービスアカウントのemailを確認
```
export SA_EMAIL=$(gcloudp iam service-accounts list --filter="displayName:terraform-account" --format='value(email)')
export PROJECT=$(gcloudp info --format='value(config.project)')
```

+ 作ったサービスアカウントに権限を付与
```
gcloudp projects add-iam-policy-binding \
    $PROJECT \
    --role roles/owner \
    --member serviceAccount:$SA_EMAIL
```

+ サービスアカウントのKeyをダウンロード
```
gcloudp iam service-accounts keys create drone-sa.json --iam-account $SA_EMAIL
```

### tfファイルを準備
+ 確認
```
terraform play create_gcp_instance
```
+ 適用
```
terraform apply create_gcp_instance
```

+ 削除
```
terraform destroy create_gcp_instance
```

### backendをGCPにする
+ backend.tfを準備
  + bucketは事前に準備する必要がある
```
terraform {
  backend "gcs" {
    bucket = "terraform-test-bucket"
    prefix = "gcp/terraform.tfstate"
  }
}

```

+ backendを反映
```
terraform init create_gcp_instance
```

### workspace
+ 一覧
```
terraform workspace list create_gcp_instance
```

+ 追加
```
terraform workspace new test create_gcp_instance
```

+ workspace名をnameにつけておいたら、競合せずに作成できる一応.
  + 以下みたいにして参照できる
```
${terraform.workspace}
```



