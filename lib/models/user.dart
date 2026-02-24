class User {
  final int id;
  final String email;
  final String role;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print('🔵 [USER] Parsing user from JSON: $json');
    try {
      return User(
        id: json['id'] as int,
        email: json['email'] as String,
        role: (json['role'] as String?) ?? 'user', // Default to 'user' if null
        createdAt: DateTime.parse(json['created_at'] as String),
      );
    } catch (e) {
      print('❌ [USER] Error parsing user: $e');
      print('❌ [USER] JSON was: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final User user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    print('🔵 [AUTH_RESPONSE] Parsing auth response from JSON');
    print('🔵 [AUTH_RESPONSE] Keys: ${json.keys.toList()}');
    try {
      return AuthResponse(
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String,
        user: User.fromJson(json['user'] as Map<String, dynamic>),
      );
    } catch (e) {
      print('❌ [AUTH_RESPONSE] Error parsing auth response: $e');
      print('❌ [AUTH_RESPONSE] JSON was: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user': user.toJson(),
    };
  }
}
