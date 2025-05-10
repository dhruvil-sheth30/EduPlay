class AuthResponse {
  final String token;
  final bool success;
  final String message;
  final UserData? userData;

  AuthResponse({
    required this.token,
    required this.success,
    required this.message,
    this.userData,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      userData: json['userData'] != null
          ? UserData.fromJson(json['userData'])
          : null,
    );
  }
}

class UserData {
  final String id;
  final String name;
  final String email;
  final String phone;
  
  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });
  
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
