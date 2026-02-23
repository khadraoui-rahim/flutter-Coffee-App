class ApiConfig {
  // API Base URL Configuration
  //
  // Change this based on your environment:
  // - Android Emulator: 'http://10.0.2.2:8080'
  // - iOS Simulator: 'http://localhost:8080'
  // - Web Browser: 'http://localhost:8080'
  // - Physical Device: 'http://YOUR_COMPUTER_IP:8080' (e.g., 'http://192.168.1.100:8080')
  // - Production: 'https://your-domain.com'

  // Default is set for OnePlus physical device
  // Use your computer's IP address: 192.168.1.102
  static const String baseUrl = 'http://192.168.1.65:8080';

  // Timeout duration for API requests
  static const Duration timeout = Duration(seconds: 30);
}
