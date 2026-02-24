# Debugging Guide

## Debug Output Legend

The authentication system now includes comprehensive debug logging to help you track what's happening during login and registration.

### Emoji Legend

- 🔵 **[AUTH]** - Authentication service operations
- 🟢 **[LOGIN]** - Login screen UI operations
- ✅ Success indicator
- ❌ Error indicator
- ⚠️ Warning indicator

### What Gets Logged

#### Login Screen (`login_screen.dart`)
- 🟢 Submit button pressed
- 🟢 Current mode (Login/Sign Up)
- ⚠️ Form validation failures
- ✅ Form validation success
- 🟢 Email being used
- 🟢 Password length (not the actual password)
- ❌ Password mismatch errors
- 🟢 Navigation events
- ❌ Any errors that occur

#### Auth Service (`auth_service.dart`)

**Registration:**
- 🔵 Starting registration with email
- 🔵 Password length
- 🔵 Request body (email only, not password)
- 🔵 API endpoint URL
- 🔵 Response status code
- 🔵 Response body
- ✅ Registration success
- ❌ Email already exists (409)
- ❌ Bad request errors (400)
- ❌ Other errors

**Login:**
- 🔵 Starting login with email
- 🔵 Request body (email only, not password)
- 🔵 API endpoint URL
- 🔵 Response status code
- 🔵 Response body
- ✅ Login success
- ❌ Invalid credentials (401)
- ❌ Bad request errors (400)
- ❌ Other errors

**Token Storage:**
- 🔵 Saving auth data
- ✅ Access token saved (first 20 chars only)
- ✅ Refresh token saved (first 20 chars only)
- ✅ User email saved

**Token Retrieval:**
- 🔵 Retrieved tokens from storage
- 🔵 Is logged in status

**Logout:**
- 🔵 Logging out user
- ✅ Tokens cleared

## How to View Debug Output

### Flutter DevTools
1. Run your app in debug mode
2. Open Flutter DevTools
3. Go to the "Logging" tab
4. Watch the console output

### VS Code / Android Studio
- Debug output appears in the "Debug Console" panel
- Look for the emoji indicators to quickly find relevant logs

### Command Line
If running with `flutter run`, debug output appears directly in the terminal.

## Common Debug Scenarios

### Successful Registration
```
🟢 [LOGIN] Submit button pressed
🟢 [LOGIN] Mode: Sign Up
✅ [LOGIN] Form validation passed
🟢 [LOGIN] Email: user@example.com
🟢 [LOGIN] Password length: 12
🟢 [LOGIN] Attempting registration...
🔵 [AUTH] Starting registration for: user@example.com
🔵 [AUTH] Password length: 12
🔵 [AUTH] Request body: {email: user@example.com, password: ********}
🔵 [AUTH] Sending POST to: http://localhost:8080/api/auth/register
🔵 [AUTH] Response status: 201
🔵 [AUTH] Response body: {"access_token":"...","refresh_token":"...","user":{...}}
✅ [AUTH] Registration successful
🔵 [AUTH] Saving auth data to local storage
✅ [AUTH] Access token saved: eyJhbGciOiJIUzI1NiIsIn...
✅ [AUTH] Refresh token saved: eyJhbGciOiJIUzI1NiIsIn...
✅ [AUTH] User saved: user@example.com
✅ [AUTH] Auth data saved
✅ [LOGIN] Registration completed successfully
🟢 [LOGIN] Navigating to home screen
🟢 [LOGIN] Loading state cleared
```

### Failed Registration (Weak Password)
```
🟢 [LOGIN] Submit button pressed
🟢 [LOGIN] Mode: Sign Up
⚠️ [LOGIN] Form validation failed
```
(Form validation catches it before API call)

### Failed Registration (Email Exists)
```
🟢 [LOGIN] Attempting registration...
🔵 [AUTH] Starting registration for: existing@example.com
🔵 [AUTH] Response status: 409
❌ [AUTH] Email already exists
❌ [LOGIN] Error occurred: Email already exists
❌ [LOGIN] Showing error dialog: Email already exists
```

### Failed Login (Invalid Credentials)
```
🟢 [LOGIN] Attempting login...
🔵 [AUTH] Starting login for: user@example.com
🔵 [AUTH] Response status: 401
❌ [AUTH] Invalid credentials
❌ [LOGIN] Error occurred: Invalid email or password
❌ [LOGIN] Showing error dialog: Invalid email or password
```

### Network Error
```
🟢 [LOGIN] Attempting login...
🔵 [AUTH] Starting login for: user@example.com
❌ [AUTH] Exception during login: SocketException: Failed host lookup...
❌ [LOGIN] Error occurred: Error during login: SocketException...
```

## Troubleshooting Tips

1. **Check API URL**: Look for the "Sending POST to:" line to verify the correct endpoint
2. **Check Response Status**: 
   - 200/201 = Success
   - 400 = Bad request (validation error)
   - 401 = Unauthorized (wrong credentials)
   - 409 = Conflict (email exists)
   - 500 = Server error
3. **Check Response Body**: Contains the actual error message from the backend
4. **Check Password Requirements**: Form validation should catch weak passwords before API call
5. **Check Network**: SocketException means the app can't reach the backend

## Security Note

The debug logs intentionally:
- ✅ Show email addresses (for debugging)
- ✅ Show password LENGTH (for debugging)
- ❌ DO NOT show actual passwords
- ✅ Show only first 20 characters of tokens
- ✅ Show response bodies (which may contain error details)

**Remember to disable or remove debug logging in production builds!**
