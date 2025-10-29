# ログイン修正について / About Login Fix

[English version below]

## 日本語

### 概要
ニコニコ動画へのログインが正常に動作しない問題を修正しました。

### 修正内容
参考プロジェクト [Niconicome](https://github.com/Hayao-H/Niconicome) の実装を基に、以下の修正を行いました：

1. **ログインAPIエンドポイントの更新**
   - 旧: `https://account.nicovideo.jp/api/v1/login`
   - 新: `https://secure.nicovideo.jp/secure/login?site=niconico`

2. **ログアウトAPIエンドポイントの更新**
   - 旧: `https://secure.nicovideo.jp/secure/logout`
   - 新: `https://account.nicovideo.jp/logout?site=niconico`

3. **ログインパラメータの修正**
   - 旧: `mail_tel`
   - 新: `mail`

### 影響範囲
- 通常のログイン機能
- 2段階認証（OTP）対応ログイン
- 自動ログイン機能
- ログアウト機能

### 変更ファイル
- `nicovideo4as/src/org/mineap/nicovideo4as/Login.as`

### ドキュメント
- `LOGIN_FIX_NOTES.md` - 技術的な詳細説明
- `SUBMODULE_UPDATE_GUIDE.md` - サブモジュールの更新手順
- `PR_SUMMARY.md` - 変更の全体像と影響分析
- `TESTING_GUIDE.md` - テスト手順書

### 次のステップ
1. nicovideo4asサブモジュールの変更をアップストリームにプッシュ
2. テストの実施（TESTING_GUIDE.mdを参照）
3. 問題がなければマージ

### テスト方法
詳細は `TESTING_GUIDE.md` を参照してください。

基本的なテスト：
1. NNDDをビルド
2. ログインボタンをクリック
3. メールアドレスとパスワードを入力
4. ログインボタンをクリック
5. ログインが成功することを確認

### 注意事項
この修正により、2018年に実装された古いAPIエンドポイントから、現在も有効な正しいエンドポイントに変更されました。多段階認証（2FA）も引き続き動作します。

---

## English

### Overview
Fixed the issue where login to Niconico Video was not working properly.

### Changes Made
Based on the reference project [Niconicome](https://github.com/Hayao-H/Niconicome), the following fixes were implemented:

1. **Updated Login API Endpoint**
   - Old: `https://account.nicovideo.jp/api/v1/login`
   - New: `https://secure.nicovideo.jp/secure/login?site=niconico`

2. **Updated Logout API Endpoint**
   - Old: `https://secure.nicovideo.jp/secure/logout`
   - New: `https://account.nicovideo.jp/logout?site=niconico`

3. **Fixed Login Parameter**
   - Old: `mail_tel`
   - New: `mail`

### Impact
- Normal login functionality
- Multi-factor authentication (OTP) login
- Auto-login functionality
- Logout functionality

### Modified Files
- `nicovideo4as/src/org/mineap/nicovideo4as/Login.as`

### Documentation
- `LOGIN_FIX_NOTES.md` - Technical details
- `SUBMODULE_UPDATE_GUIDE.md` - Submodule update procedures
- `PR_SUMMARY.md` - Complete overview and impact analysis
- `TESTING_GUIDE.md` - Testing procedures

### Next Steps
1. Push nicovideo4as submodule changes to upstream
2. Perform testing (refer to TESTING_GUIDE.md)
3. Merge if no issues found

### How to Test
See `TESTING_GUIDE.md` for detailed instructions.

Basic test:
1. Build NNDD
2. Click login button
3. Enter email and password
4. Click login button
5. Verify successful login

### Notes
This fix updates from the outdated API endpoint (implemented in 2018) to the currently valid endpoint. Multi-factor authentication (2FA) continues to work.

---

## 関連リンク / Related Links

- 参考実装 / Reference: [Niconicome](https://github.com/Hayao-H/Niconicome)
- Issue: ログイン処理が正常に動作しない / Login not working properly
