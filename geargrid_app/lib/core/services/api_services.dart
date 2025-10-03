// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.10.234:5000/api/auth';

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<Map<String, String>> get authHeaders async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh_token', token);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  static Future<Map<String, dynamic>> refreshToken() async {
    final token = await getRefreshToken();
    if (token == null) return {'success': false, 'error': 'No refresh token'};

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/refresh-token'),
        headers: headers,
        body: jsonEncode({'token': token}),
      );

      final result = _handleResponse(response);

      if (result['success'] && result['accessToken'] != null) {
        await saveToken(result['accessToken']);
        if (result['refreshToken'] != null) {
          await saveRefreshToken(result['refreshToken']);
        }
      }

      return result;
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String country,
    required String countryCode,
    required String address,
    required String phoneNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: headers,
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'password': password,
          'confirmPassword': password,
          'country': country,
          'countryCode': countryCode,
          'address': address,
          'phoneNumber': phoneNumber,
        }),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-otp'),
        headers: headers,
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> resendOTP({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/resend-otp'),
        headers: headers,
        body: jsonEncode({'email': email}),
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: headers,
        body: jsonEncode({'email': email, 'password': password}),
      );

      final result = _handleResponse(response);
      if (result['success'] && result['data']?['accessToken'] != null) {
        await saveToken(result['data']['accessToken']);
        if (result['data']['refreshToken'] != null) {
          await saveRefreshToken(result['data']['refreshToken']);
        }
        if (result['data']['user'] != null) {
          await saveUser(result['data']['user']);
        }
      }
      return result;
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: headers,
        body: jsonEncode({'email': email}),
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: headers,
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
          'confirmPassword': newPassword,
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: await authHeaders,
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? country,
    String? countryCode,
    String? address,
    String? oldPassword,
    String? newPassword,
    File? avatarFile,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/update-profile');
      final request = http.MultipartRequest('PUT', uri);
      final authMap = await authHeaders;
      authMap.remove('Content-Type');
      request.headers.addAll(authMap);

      if (fullName != null) request.fields['fullName'] = fullName;
      if (email != null) request.fields['email'] = email;
      if (phoneNumber != null) request.fields['phoneNumber'] = phoneNumber;
      if (country != null) request.fields['country'] = country;
      if (countryCode != null) request.fields['countryCode'] = countryCode;
      if (address != null) request.fields['address'] = address;
      if (oldPassword != null) request.fields['oldPassword'] = oldPassword;
      if (newPassword != null) request.fields['newPassword'] = newPassword;

      if (avatarFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('avatar', avatarFile.path),
        );
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: await authHeaders,
      );

      await removeToken();
      await removeRefreshToken();
      await removeUser();
      return _handleResponse(response);
    } catch (e) {
      await removeToken();
      await removeRefreshToken();
      await removeUser();
      return _handleError(e);
    }
  }

  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user));
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      return jsonDecode(userString);
    }
    return null;
  }

  static Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }

  static Future<void> removeRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('refresh_token');
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': data['success'] ?? true,
          'data': data,
          'message': data['message'] ?? '',
          'statusCode': response.statusCode,
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? data['message'] ?? 'Unknown error',
          'data': data,
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Invalid response format',
        'data': null,
      };
    }
  }

  static Map<String, dynamic> _handleError(dynamic error) {
    String errorMessage = 'Network error';
    if (error is SocketException)
      errorMessage = 'No internet connection';
    else if (error is http.ClientException)
      errorMessage = 'Failed to connect';
    else
      errorMessage = error.toString();
    return {'success': false, 'error': errorMessage, 'data': null};
  }
}