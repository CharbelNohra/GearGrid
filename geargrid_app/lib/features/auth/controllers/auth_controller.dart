import 'package:flutter/material.dart';
import '../../../core/services/api_services.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  // Initialize - Check if user is already logged in and fetch profile
  Future<void> initialize() async {
    _setLoading(true);
    try {
      if (await ApiService.isAuthenticated()) {
        // Fetch user profile from backend
        final result = await ApiService.getProfile();
        if (result['success']) {
          final userData = result['data']['user'];
          _setUser(User.fromJson(userData));
        } else {
          // If profile fetch fails, clear token and set user to null
          await ApiService.removeToken();
          _setUser(null);
        }
      }
    } catch (e) {
      _setError(e.toString());
      // If error occurs, clear token and set user to null
      await ApiService.removeToken();
      _setUser(null);
    } finally {
      _setLoading(false);
    }
  }

  // Get current user profile
  Future<bool> getProfile() async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await ApiService.getProfile();

      if (result['success']) {
        final userData = result['data']['user'];
        _setUser(User.fromJson(userData));
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError('Failed to get profile: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register new user
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String country,
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
        address: address,
        phoneNumber: phoneNumber,
      );

      if (result['success']) {
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError('Registration failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Verify OTP
  Future<bool> verifyOTP({required String email, required String otp}) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await ApiService.verifyOTP(email: email, otp: otp);

      if (result['success']) {
        // After successful OTP verification, get user profile
        await getProfile();
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError('OTP verification failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Login user
  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await ApiService.login(email: email, password: password);

      if (result['success']) {
        // Create user object from login response
        final userData = result['data']['user'];
        if (userData != null) {
          _setUser(User.fromJson(userData));
        }
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError('Login failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Forgot password
  Future<bool> forgotPassword({required String email}) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await ApiService.forgotPassword(email: email);

      if (result['success']) {
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError('Failed to send reset email: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Reset password
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

      if (result['success']) {
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError('Password reset failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? country,
    String? address,
    String? oldPassword,
    String? newPassword,
    dynamic avatarFile,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final result = await ApiService.updateProfile(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        country: country,
        address: address,
        oldPassword: oldPassword,
        newPassword: newPassword,
        avatarFile: avatarFile,
      );

      if (result['success']) {
        // Update current user data from response
        final userData = result['data']['user'];
        if (userData != null) {
          _setUser(User.fromJson(userData));
        }
        return true;
      } else {
        _setError(result['error']);
        return false;
      }
    } catch (e) {
      _setError('Profile update failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout user
  Future<void> logout() async {
    _setLoading(true);
    _setError(null);

    try {
      await ApiService.logout();
      _setUser(null);
    } catch (e) {
      _setError('Logout failed: ${e.toString()}');
      // Still clear user data even if logout request fails
      _setUser(null);
    } finally {
      _setLoading(false);
    }
  }

  // Clear error
  void clearError() {
    _setError(null);
  }
}