import 'package:flutter/material.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/services/api_services.dart';
import 'registration_step_one.dart';
import 'registration_step_two.dart';
import 'registration_navigation.dart';

class RegistrationForm extends StatefulWidget {
  final Function(Map<String, String>) onComplete;
  final Function(String) onError;
  final Function(String) onSuccess;

  const RegistrationForm({
    super.key,
    required this.onComplete,
    required this.onError,
    required this.onSuccess,
  });

  @override
  State<RegistrationForm> createState() => RegistrationFormState();
}

class RegistrationFormState extends State<RegistrationForm> {
  final _pageController = PageController();
  int currentStep = 0;
  bool isLoading = false;

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  String? selectedCountry;

  @override
  void dispose() {
    _pageController.dispose();
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    SnackBarHelper.showError(context, "Error", message);
  }

  void _showSuccess(String message) {
    SnackBarHelper.showSuccess(context, "Success", message);
  }

  bool _validateStepOne() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (!Validators.isValidEmail(email)) {
      _showError("Please enter a valid email address.");
      return false;
    }

    if (!Validators.isValidPassword(password)) {
      _showError("Password must be at least 8 characters, include upper/lower case letters, and a number or symbol.");
      return false;
    }

    if (password != confirmPassword) {
      _showError("Passwords do not match.");
      return false;
    }

    if (nameController.text.isEmpty) {
      _showError("Please enter your full name.");
      return false;
    }

    return true;
  }

  bool _validateStepTwo() {
    if (selectedCountry == null ||
        addressController.text.isEmpty ||
        phoneController.text.isEmpty) {
      _showError("Please complete all fields in this step.");
      return false;
    }
    return true;
  }

  Future<void> _submitRegistration() async {
    setState(() {
      isLoading = true;
    });

    try {
      // print('📝 Starting registration with data:');
      // print('Email: ${emailController.text.trim()}');
      // print('Name: ${nameController.text.trim()}');
      // print('Country: $selectedCountry');
      // print('Address: ${addressController.text.trim()}');
      // print('Phone: ${phoneController.text.trim()}');

      final result = await ApiService.register(
        fullName: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        country: selectedCountry!,
        address: addressController.text.trim(),
        phoneNumber: phoneController.text.trim(),
      );

      // print('🎯 Registration API Result:');
      // print('Success: ${result['success']}');
      // print('Data: ${result['data']}');
      // print('Error: ${result['error']}');
      // print('Status Code: ${result['statusCode']}');
      // print('Full Result: $result');

      setState(() {
        isLoading = false;
      });

      if (result['success'] == true) {
        _showSuccess("Registration successful! Please verify your email.");
        
        final formData = {
          'email': emailController.text.trim(),
          'name': nameController.text.trim(),
          'password': passwordController.text.trim(),
          'country': selectedCountry!,
          'address': addressController.text.trim(),
          'phone': phoneController.text.trim(),
        };
        widget.onComplete(formData);
      } else {
        // Try multiple error message formats
        String errorMsg = 'Registration failed. Please try again.';
        
        if (result['error'] != null) {
          errorMsg = result['error'].toString();
        } else if (result['message'] != null) {
          errorMsg = result['message'].toString();
        } else if (result['data'] != null && result['data']['message'] != null) {
          errorMsg = result['data']['message'].toString();
        }
        
        // print('❌ Showing error message: $errorMsg');
        _showError(errorMsg);
      }
    } catch (e) {
      // print('💥 Exception during registration: $e');
      // print('Exception type: ${e.runtimeType}');
      
      setState(() {
        isLoading = false;
      });
      _showError('Registration failed. Please check your connection and try again.');
    }
  }

  void nextStep() {
    if (currentStep == 0) {
      if (!_validateStepOne()) return;
    } else if (currentStep == 1) {
      if (!_validateStepTwo()) return;
    }

    if (currentStep < 1) {
      setState(() => currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitRegistration();
    }
  }

  void previousStep() {
    if (currentStep > 0 && !isLoading) {
      setState(() => currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onCountryChanged(String? country) {
    setState(() {
      selectedCountry = country;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 400,
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              RegistrationStepOne(
                emailController: emailController,
                nameController: nameController,
                passwordController: passwordController,
                confirmPasswordController: confirmPasswordController,
              ),
              RegistrationStepTwo(
                selectedCountry: selectedCountry,
                addressController: addressController,
                phoneController: phoneController,
                onCountryChanged: onCountryChanged,
              ),
            ],
          ),
        ),
        RegistrationNavigation(
          currentStep: currentStep,
          onNext: nextStep,
          onPrevious: previousStep,
          isLoading: isLoading,
        ),
      ],
    );
  }
}