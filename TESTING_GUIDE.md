# Testing Guide for Login Fix

## Prerequisites

### Build Environment
- Adobe AIR SDK installed and configured
- `AIR_HOME` environment variable set
- Build tools available (make, etc.)

### Test Accounts
- A valid Niconico Video account (email and password)
- Optional: An account with 2FA enabled for comprehensive testing

## Building NNDD

### Option 1: Using Docker (Recommended)
```bash
make builder-img
make with-docker
```

### Option 2: Local Build
```bash
# Ensure AIR_HOME is set
export AIR_HOME=/path/to/air-sdk

# Build
cd src
make build
```

## Test Scenarios

### 1. Basic Login Test

#### Steps:
1. Launch NNDD
2. Click on the login button
3. Enter valid email address and password
4. Click "ログイン" (Login)

#### Expected Results:
- ✅ Login completes successfully
- ✅ User session is established
- ✅ Main interface shows logged-in state
- ✅ No error messages appear

#### What to Check:
- Network traffic uses `https://secure.nicovideo.jp/secure/login?site=niconico`
- POST data includes `mail` parameter (not `mail_tel`)
- Response headers contain `x-niconico-authflag` with success value

### 2. Invalid Credentials Test

#### Steps:
1. Launch NNDD
2. Click on the login button
3. Enter invalid email address or password
4. Click "ログイン" (Login)

#### Expected Results:
- ✅ Error message displayed: "メールアドレス、もしくはパスワードが間違っています"
- ✅ User remains at login screen
- ✅ Can retry login

### 3. Multi-Factor Authentication (2FA) Test

#### Prerequisites:
- Account with 2FA enabled

#### Steps:
1. Launch NNDD
2. Click on the login button
3. Enter valid email and password
4. Click "ログイン" (Login)
5. System should prompt for OTP
6. Enter the 6-digit OTP code
7. Click login again

#### Expected Results:
- ✅ OTP input field appears after initial login
- ✅ After entering OTP, login completes successfully
- ✅ User session is established

#### What to Check:
- First request goes to `secure.nicovideo.jp/secure/login?site=niconico`
- Response redirects to `account.nicovideo.jp/mfa`
- Second request (with OTP) goes to the MFA URL
- `multiFactorAuthentication()` method is called

### 4. Remember Password Test

#### Steps:
1. Launch NNDD
2. Click on the login button
3. Enter credentials
4. Check "パスワードを保存する" (Save password)
5. Click "ログイン" (Login)
6. Close and reopen NNDD

#### Expected Results:
- ✅ Password is saved in EncryptedLocalStore
- ✅ On next launch, password field is pre-filled
- ✅ Can login without re-entering password

### 5. Auto-Login Test

#### Steps:
1. Launch NNDD
2. Click on the login button
3. Enter credentials
4. Check "次回以降自動的にログインする" (Auto-login)
5. Click "ログイン" (Login)
6. Close and reopen NNDD

#### Expected Results:
- ✅ On next launch, login happens automatically
- ✅ No need to click login button
- ✅ User is logged in after startup

### 6. Logout Test

#### Steps:
1. Login successfully
2. Use the logout function
3. Verify logout completed

#### Expected Results:
- ✅ Logout request goes to `https://account.nicovideo.jp/logout?site=niconico`
- ✅ Session is terminated
- ✅ UI shows logged-out state

### 7. Network Error Test

#### Steps:
1. Disconnect from internet
2. Attempt to login
3. Reconnect
4. Retry login

#### Expected Results:
- ✅ Appropriate error message when disconnected
- ✅ Can retry when reconnected
- ✅ No crashes or hangs

## Debugging

### Enable Trace Logging
The code uses `trace()` statements for debugging. Enable Flash/AIR trace logging to see:
- Request URLs
- Response headers
- Authentication flow steps

### Check Network Traffic
Use a network monitoring tool (like Wireshark or Fiddler) to verify:
- Correct endpoints are being used
- HTTPS connections are secure
- POST parameters are correct

### Common Issues

#### Issue: "ログインに失敗しました"
**Possible Causes:**
- Invalid credentials
- Network connectivity issue
- Niconico server is down

**Check:**
- Verify credentials are correct
- Test network connectivity
- Check Niconico status page

#### Issue: OTP field doesn't appear for 2FA accounts
**Possible Causes:**
- Response URL parsing issue
- MFA detection logic problem

**Check:**
- Response headers contain MFA redirect
- Event handler for `MULTI_FACTOR_AUTHENTICATION_REQUIRED` is working

#### Issue: Session doesn't persist
**Possible Causes:**
- Cookie handling issue
- Session timeout

**Check:**
- Cookies are being stored correctly
- Session duration settings

## Regression Testing

Verify that existing functionality still works:
- [ ] Video playback
- [ ] Download functionality
- [ ] Mylist access
- [ ] Search functionality
- [ ] Rankings display

## Reporting Issues

When reporting issues, please include:
1. NNDD version
2. Operating system
3. Steps to reproduce
4. Expected vs actual behavior
5. Any error messages
6. Network trace logs (if available)

## Success Criteria

All of the following must pass:
- ✅ Basic login works with valid credentials
- ✅ Error shown for invalid credentials
- ✅ 2FA flow works (if applicable)
- ✅ Password save/load works
- ✅ Auto-login works
- ✅ Logout works
- ✅ No regressions in other features
