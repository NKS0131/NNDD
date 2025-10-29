# nicovideo4as Submodule 更新ガイド

## 現状

このPRでは、nicovideo4asサブモジュール内のLogin.asファイルに変更を加えています。
サブモジュールは別リポジトリ（https://github.com/NKS0131/nicovideo4as）で管理されているため、
以下の手順で変更を適用する必要があります。

## 手順

### 1. nicovideo4asリポジトリでの作業

nicovideo4asサブモジュール内で以下のコマンドを実行して、変更をプッシュします：

```bash
cd nicovideo4as
git checkout fix-login-endpoint
git push origin fix-login-endpoint
```

### 2. nicovideo4asリポジトリでのPR作成

nicovideo4asリポジトリでプルリクエストを作成してマージします：
- ブランチ: `fix-login-endpoint`
- 変更ファイル: `src/org/mineap/nicovideo4as/Login.as`
- 変更内容:
  - LOGIN_URL を更新
  - LOGOUT_URL を更新
  - POSTパラメータを `mail_tel` から `mail` に変更

### 3. NNDDリポジトリでのサブモジュール参照更新

nicovideo4asの変更がマージされたら、NNDDリポジトリで以下を実行：

```bash
cd nicovideo4as
git checkout master
git pull origin master
cd ..
git add nicovideo4as
git commit -m "Update nicovideo4as submodule to include login fixes"
git push
```

## 現在のサブモジュール状態

- 現在のコミット: `2ea60cb` (ローカルのfix-login-endpointブランチ)
- マスターのコミット: `2bb1517`

## 代替方法（手動適用）

サブモジュールへのプッシュ権限がない場合、以下の方法で変更を適用できます：

1. nicovideo4asリポジトリをフォーク
2. フォークしたリポジトリに変更をプッシュ
3. 元のnicovideo4asリポジトリにプルリクエストを作成
4. マージ後、NNDDの.gitmodulesを更新してフォークを参照

または、変更が小さいため、nicovideo4asのメンテナーに直接連絡して変更を適用してもらうこともできます。
