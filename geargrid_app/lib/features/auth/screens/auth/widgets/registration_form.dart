import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/countries_phone_code.dart';
import '../../../../../core/providers/flutter_riverpod.dart';
import '../../../../../core/utils/snackbar_helper.dart';
import '../../../../../core/utils/validators.dart';
import 'registration_step_one.dart';
import 'registration_step_two.dart';
import 'registration_navigation.dart';

class RegistrationForm extends ConsumerStatefulWidget {
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
  ConsumerState<RegistrationForm> createState() => RegistrationFormState();
}

class RegistrationFormState extends ConsumerState<RegistrationForm> {
  final _pageController = PageController();
  int currentStep = 0;

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final countryCodeController = TextEditingController();
  String? selectedCountry;

  bool get isLoading => ref.watch(authControllerProvider).isLoading;

  @override
  void dispose() {
    _pageController.dispose();
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    addressController.dispose();
    phoneController.dispose();
    countryCodeController.dispose();
    super.dispose();
  }

  void _showError(String message) => SnackBarHelper.showError(context, "Error", message);
  void _showSuccess(String message) => SnackBarHelper.showSuccess(context, "Success", message);

  bool _validateStepOne() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (!Validators.isValidEmail(email)) {
      _showError("Please enter a valid email address.");
      return false;
    }

    if (!Validators.isValidPassword(password)) {
      _showError(
          "Password must be at least 8 characters, include upper/lower case letters, and a number or symbol.");
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
        phoneController.text.isEmpty ||
        countryCodeController.text.isEmpty) {
      _showError("Please complete all fields in this step.");
      return false;
    }
    return true;
  }

  Future<void> _submitRegistration() async {
    final authController = ref.read(authControllerProvider);

    final success = await authController.register(
      fullName: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      country: selectedCountry!,
      address: addressController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      countryCode: countryCodeController.text,
    );

    if (success) {
      _showSuccess("Registration successful! Please verify your email.");

      final formData = {
        'email': emailController.text.trim(),
        'name': nameController.text.trim(),
        'password': passwordController.text.trim(),
        'country': selectedCountry!,
        'address': addressController.text.trim(),
        'phone': phoneController.text.trim(),
        'countryCode': countryCodeController.text,
      };
      widget.onComplete(formData);
    } else {
      _showError(authController.error ?? 'Registration failed. Please try again.');
    }
  }

  void nextStep() {
    if (currentStep == 0 && !_validateStepOne()) return;
    if (currentStep == 1 && !_validateStepTwo()) return;

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
      countryCodeController.text = country != null
          ? (countryPhoneData[country]?['code'] ?? '')
          : '';
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
                countryCodeController: countryCodeController,
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