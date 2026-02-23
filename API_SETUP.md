# Coffee App - API Integration Setup

## Overview
The Flutter app now fetches coffee data from the Rust backend API instead of using hardcoded data.

## Configuration

### 1. Update API URL
Edit `lib/config/api_config.dart` and change the `baseUrl` based on your environment:

**Android Emulator:**
```dart
static const String baseUrl = 'http://10.0.2.2:8080/api';
```

**iOS Simulator:**
```dart
static const String baseUrl = 'http://localhost:8080/api';
```

**Physical Device:**
```dart
static const String baseUrl = 'http://YOUR_COMPUTER_IP:8080/api';
// Example: 'http://192.168.1.100:8080/api'
```

**Production:**
```dart
static const String baseUrl = 'https://your-domain.com/api';
```

### 2. Find Your Computer's IP Address

**Windows:**
```cmd
ipconfig
```
Look for "IPv4 Address" under your active network adapter.

**Mac/Linux:**
```bash
ifconfig
```
Look for "inet" under your active network interface (usually en0 or wlan0).

### 3. Install Dependencies
```bash
cd coffee_app-front
flutter pub get
```

### 4. Run the Backend
Make sure your Rust backend is running:
```bash
cd coffee_app-backend
docker-compose up --build -d
```

Verify it's working:
```bash
curl http://localhost:8080/api/coffees
```

### 5. Run the Flutter App
```bash
flutter run
```

## Features

### API Service (`lib/services/api_service.dart`)
- `getAllCoffees()` - Fetch all coffee items
- `getCoffeeById(id)` - Fetch a specific coffee
- `createCoffee(coffee)` - Create a new coffee
- `updateCoffee(id, coffee)` - Update a coffee
- `deleteCoffee(id)` - Delete a coffee

### Home Screen Updates
- Shows loading spinner while fetching data
- Displays error message with retry button if API fails
- Shows "No coffees available" if the list is empty
- Automatically loads coffees when the screen opens

## Troubleshooting

### "Failed to load coffees" Error
1. Check that the backend is running: `docker-compose ps`
2. Verify the API URL in `lib/config/api_config.dart`
3. Test the API directly: `curl http://YOUR_IP:8080/api/coffees`
4. Check backend logs: `docker-compose logs -f app`

### Connection Refused
- Make sure you're using the correct IP address
- Ensure your phone/emulator and computer are on the same network
- Check firewall settings (port 8080 should be open)

### Timeout Errors
- Increase timeout in `lib/config/api_config.dart`:
  ```dart
  static const Duration timeout = Duration(seconds: 60);
  ```

## Testing the API

You can test the API endpoints using curl or the Swagger UI at `http://localhost:8080/swagger-ui`

**Get all coffees:**
```bash
curl http://localhost:8080/api/coffees
```

**Get coffee by ID:**
```bash
curl http://localhost:8080/api/coffees/1
```

**Create a coffee:**
```bash
curl -X POST http://localhost:8080/api/coffees \
  -H "Content-Type: application/json" \
  -d '{
    "image_url": "https://example.com/image.jpg",
    "name": "Test Coffee",
    "coffee_type": "Espresso",
    "price": 3.99,
    "rating": 4.5
  }'
```
