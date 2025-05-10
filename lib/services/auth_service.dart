import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';

class AuthService extends ChangeNotifier {
  String? _token;
  UserData? _userData;
  
  String? get token => _token;
  UserData? get userData => _userData;
  bool get isAuthenticated => _token != null;

  // Dummy data for authentication
  final Map<String, String> _dummyUsers = {
    'testStudent@sheshya.in': '123456',
    'student@example.com': '000000',
  };

  Future<bool> login(String email, String phone, String otp) async {
    // Using dummy authentication instead of API
    try {
      // For demo purposes, we'll just check if the email and OTP match our dummy data
      if (_dummyUsers.containsKey(email) && _dummyUsers[email] == otp) {
        // Create dummy token and user data
        _token = 'dummy_token_${DateTime.now().millisecondsSinceEpoch}';
        _userData = UserData(
          id: '123', 
          name: 'Test Student', 
          email: email, 
          phone: phone.isEmpty ? '9876543210' : phone
        );
        
        // Save token to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        
        notifyListeners();
        return true;
      }
      return false;
      
      // Comment out the original API code
      /* 
      final response = await http.post(
        Uri.parse('https://sheshya-backend-f4gndddgadfhc3fy.eastus-01.azurewebsites.net/loginByEmailOrPhone'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'phone': phone,
          'otp': otp
        }),
      );
      
      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
        
        if (authResponse.success) {
          _token = authResponse.token;
          _userData = authResponse.userData;
          
          // Save token to shared preferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', _token!);
          
          notifyListeners();
          return true;
        }
      }
      return false;
      */
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }
  
  Future<bool> checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('auth_token');
    
    if (savedToken != null) {
      _token = savedToken;
      notifyListeners();
      return true;
    }
    return false;
  }
  
  Future<void> logout() async {
    _token = null;
    _userData = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    
    notifyListeners();
  }
}
