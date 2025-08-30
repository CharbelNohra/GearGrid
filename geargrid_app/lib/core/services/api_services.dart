import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // - For Android emulator: 'http://10.0.2.2:5000'
  static const String baseUrl = 'http://192.168.1.133:5000/api/auth';

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

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String country,
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
          'country': country,
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

      final result = _handleResponse(response);

      if (result['success'] == true && result['data']?['token'] != null) {
        await saveToken(result['data']['token']);
      }

      return result;
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

      if (result['success'] == true && result['data']?['token'] != null) {
        await saveToken(result['data']['token']);
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
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? country,
    String? address,
    File? avatarFile,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/profile');
      final request = http.MultipartRequest('PUT', uri);

      final authHeadersMap = await authHeaders;
      request.headers.addAll(authHeadersMap);

      if (fullName != null) request.fields['fullName'] = fullName;
      if (phoneNumber != null) request.fields['phoneNumber'] = phoneNumber;
      if (country != null) request.fields['country'] = country;
      if (address != null) request.fields['address'] = address;

      if (avatarFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('avatar', avatarFile.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

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

      final result = _handleResponse(response);

      await removeToken();

      return result;
    } catch (e) {
      await removeToken();
      return _handleError(e);
    }
  }

  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return {'success': true, 'data': data, 'statusCode': response.statusCode};
    } else {
      return {
        'success': false,
        'error': data['message'] ?? data['error'] ?? 'Unknown error occurred',
        'data': data,
        'statusCode': response.statusCode,
      };
    }
  }

  static Map<String, dynamic> _handleError(dynamic error) {
    String errorMessage = 'Network error occurred';

    if (error is SocketException) {
      errorMessage = 'No internet connection';
    } else if (error is http.ClientException) {
      errorMessage = 'Failed to connect to server';
    } else if (error is FormatException) {
      errorMessage = 'Invalid response format';
    } else {
      errorMessage = error.toString();
    }

    return {'success': false, 'error': errorMessage, 'data': null};
  }
}