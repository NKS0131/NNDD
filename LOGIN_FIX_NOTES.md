# ログイン処理の修正について

## 概要

ニコニコ動画へのログインが正常に動作しない問題を修正しました。
参考: https://github.com/Hayao-H/Niconicome

## 変更内容

### nicovideo4as/src/org/mineap/nicovideo4as/Login.as

以下の3つの変更を行いました：

1. **ログインURLの変更**
   - 変更前: `https://account.nicovideo.jp/api/v1/login`
   - 変更後: `https://secure.nicovideo.jp/secure/login?site=niconico`

2. **ログアウトURLの変更**
   - 変更前: `https://secure.nicovideo.jp/secure/logout`
   - 変更後: `https://account.nicovideo.jp/logout?site=niconico`

3. **ログインPOSTパラメータの変更**
   - 変更前: `variables.mail_tel = this._user;`
   - 変更後: `variables.mail = this._user;`

## 理由

2018年に多段階認証対応のために変更された`account.nicovideo.jp/api/v1/login`エンドポイントは、
現在のニコニコ動画のログインシステムでは正常に動作しません。

Niconicomeプロジェクト（最新のニコニコ動画ダウンローダー）では、
`secure.nicovideo.jp/secure/login?site=niconico`エンドポイントを使用しており、
このエンドポイントが現在も有効であることが確認されています。

## 多段階認証（2FA）への影響

多段階認証機能は引き続き動作する想定です：

1. 通常のログインで`secure.nicovideo.jp/secure/login?site=niconico`にアクセス
2. 2FAが必要な場合、レスポンスに`account.nicovideo.jp/mfa`のURLが含まれる
3. OTPとデバイス名を使って`multiFactorAuthentication()`メソッドで認証

## テスト方法

1. メールアドレスとパスワードでログイン
2. 2FA有効アカウントでのログイン
3. ログアウト機能の確認

## 注意事項

nicovideo4asは別リポジトリのsubmoduleであるため、以下の対応が必要です：

1. nicovideo4asリポジトリへのプルリクエストを作成
2. マージ後、NNDDリポジトリのsubmodule参照を更新

## 参考リンク

- Niconicome: https://github.com/Hayao-H/Niconicome
- Niconicome NetConstant.cs: https://github.com/Hayao-H/Niconicome/blob/master/Niconicome/Models/Const/NetConstant.cs
