# Authentication Setup

This document describes the authentication implementation in the Coffee App.

## Overview

The app uses JWT-based authentication with access and refresh tokens provided by the Rust backend API.

## Features

- User registration (sign up)
- User login (sign in)
- Token-based authentication
- Secure token storage using SharedPreferences
- Form validation
- Error handling with user-friendly messages
- Loading states during API calls

## Flow

1. **Onboarding** → **Login Screen** → **Home Screen**
2. Users can toggle between Login and Sign Up modes
3. On successful authentication, tokens are stored locally
4. Access token is used for authenticated API requests
5. Refresh token can be used to obtain new access tokens

## Files

### Models
- `lib/models/user.dart` - User and AuthResponse models

### Services
- `lib/services/auth_service.dart` - Authentication API service
  - `register(email, password)` - Register new user
  - `login(email, password)` - Login existing user
  - `refreshToken()` - Refresh access token
  - `getCurrentUser()` - Get current user info
  - `logout()` - Clear stored tokens
  - `isLoggedIn()` - Check if user is authenticated

### Screens
- `lib/screens/login_screen.dart` - Login/Sign up UI

## API Endpoints

The app connects to the following backend endpoints:

- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `POST /api/auth/refresh` - Refresh access token
- `GET /api/auth/me` - Get current user (requires authentication)

## Configuration

Update the API base URL in `lib/config/api_config.dart`:

```dart
static const String baseUrl = 'http://localhost:8080';
```

For physical devices, use your computer's IP address:
```dart
static const String baseUrl = 'http://192.168.1.XXX:8080';
```

## Validation Rules

### Email
- Must be a valid email format
- Required field

### Password
- Minimum 8 characters
- At least one uppercase letter (A-Z)
- At least one lowercase letter (a-z)
- At least one digit (0-9)
- Required field

### Confirm Password (Sign Up only)
- Must match password field
- Required field

## Token Storage

Tokens are stored securely using the `shared_preferences` package:
- `access_token` - JWT access token
- `refresh_token` - JWT refresh token
- `user` - User information (JSON)

## Error Handling

The app handles various error scenarios:
- Invalid credentials (401)
- Email already exists (409)
- Validation errors (400)
- Network errors
- Server errors

Errors are displayed in a styled dialog matching the app's design.

## Next Steps

To use authentication in other parts of the app:

1. Get the access token:
```dart
final authService = AuthService();
final token = await authService.getAccessToken();
```

2. Include it in API requests:
```dart
headers: {
  'Authorization': 'Bearer $token',
}
```

3. Handle 401 responses by refreshing the token:
```dart
if (response.statusCode == 401) {
  await authService.refreshToken();
  // Retry the request
}
```
