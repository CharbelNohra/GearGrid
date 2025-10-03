import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/services/api_services.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  bool _isResending = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isResending => _isResending;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setResending(bool value) {
    _isResending = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  void _setUser(User? value) {
    _currentUser = value;
    notifyListeners();
  }

  Future<void> initialize() async {
    _setLoading(true);
    try {
      final savedUser = await ApiService.getUser();
      if (savedUser != null) {
        _setUser(User.fromJson(savedUser));
      }

      if (await ApiService.isAuthenticated()) {
        final result = await ApiService.getProfile();
        if (result['success']) {
          _setUser(User.fromJson(result['data']['user']));
        } else {
          await ApiService.removeToken();
          await ApiService.removeRefreshToken();
          await ApiService.removeUser();
          _setUser(null);
        }
      }
    } catch (e) {
      _setError(e.toString());
      await ApiService.removeToken();
      await ApiService.removeRefreshToken();
      await ApiService.removeUser();
      _setUser(null);
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String country,
    required String countryCode,
    required String address,
    required String phoneNumber,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final result = await ApiService.register(
        fullName: fullName,
        email: email,
        password: password,
        country: country,
        countryCode: countryCode,
        address: address,
        phoneNumber: phoneNumber,
      );
      if (result['success']) return true;
      _setError(result['error']);
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> verifyOTP({required String email, required String otp}) async {
    _setLoading(true);
    _setError(null);
    try {
      final result = await ApiService.verifyOTP(email: email, otp: otp);
      if (result['success']) {
        await getProfile();
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resendOTP({
    required String email,
    bool isPasswordReset = false,
  }) async {
    _setResending(true);
    _setError(null);
    try {
      final result =
          isPasswordReset
              ? await ApiService.forgotPassword(email: email)
              : await ApiService.resendOTP(email: email);

      if (result['success']) return true;
      _setError(result['error']);
      return false;
    } catch (e) {
      _setError('Failed to resend OTP: ${e.toString()}');
      return false;
    } finally {
      _setResending(false);
    }
  }

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _setError(null);
    try {
      final result = await ApiService.login(email: email, password: password);
      if (result['success']) {
        _setUser(User.fromJson(result['data']['user']));
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> forgotPassword({required String email}) async {
    _setResending(true);
    _setError(null);
    try {
      final result = await ApiService.forgotPassword(email: email);
      if (result['success']) return true;
      _setError(result['error']);
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setResending(false);
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final result = await ApiService.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      if (result['success']) return true;
      _setError(result['error']);
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> getProfile() async {
    _setLoading(true);
    _setError(null);
    try {
      final result = await ApiService.getProfile();
      if (result['success']) {
        _setUser(User.fromJson(result['data']['user']));
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile({
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
    _setLoading(true);
    _setError(null);
    try {
      final result = await ApiService.updateProfile(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        country: country,
        countryCode: countryCode,
        address: address,
        oldPassword: oldPassword,
        newPassword: newPassword,
        avatarFile: avatarFile,
      );

      if (result['success'] == true) {
        // Extract user from the data
        final userData = result['data']['user'];
        if (userData != null) {
          _setUser(User.fromJson(userData));
        }
        return true;
      } else {
        _setError(result['error'] ?? 'Failed to update profile');
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    _setError(null);
    try {
      await ApiService.logout();
      _setUser(null);
    } catch (e) {
      _setError(e.toString());
      _setUser(null);
    } finally {
      _setLoading(false);
    }
  }

  void clearError() => _setError(null);
}
