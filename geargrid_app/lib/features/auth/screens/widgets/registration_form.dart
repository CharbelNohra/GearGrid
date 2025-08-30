import 'package:flutter/material.dart';
import '../../../../core/utils/validators.dart';
import 'registration_step_one.dart';
import 'registration_step_two.dart';
import 'registration_navigation.dart';

class RegistrationForm extends StatefulWidget {
  final Function(Map<String, String>) onComplete;
  final Function(String) onError;

  const RegistrationForm({
    super.key,
    required this.onComplete,
    required this.onError,
  });

  @override
  State<RegistrationForm> createState() => RegistrationFormState();
}

class RegistrationFormState extends State<RegistrationForm> {
  final _pageController = PageController();
  int currentStep = 0;

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

  bool _validateStepOne() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (!Validators.isValidEmail(email)) {
      widget.onError("Please enter a valid email address.");
      return false;
    }

    if (!Validators.isValidPassword(password)) {
      widget.onError(
        "Password must be at least 8 characters, include upper/lower case letters, and a number or symbol.",
      );
      return false;
    }

    if (password != confirmPassword) {
      widget.onError("Passwords do not match.");
      return false;
    }

    if (nameController.text.isEmpty) {
      widget.onError("Full name is required.");
      return false;
    }

    return true;
  }

  bool _validateStepTwo() {
    if (selectedCountry == null ||
        addressController.text.isEmpty ||
        phoneController.text.isEmpty) {
      widget.onError("Please complete all fields.");
      return false;
    }
    return true;
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
      final formData = {
        'email': emailController.text.trim(),
        'name': nameController.text.trim(),
        'password': passwordController.text.trim(),
        'country': selectedCountry!,
        'address': addressController.text.trim(),
        'phone': phoneController.text.trim(),
      };
      widget.onComplete(formData);
    }
  }

  void previousStep() {
    if (currentStep > 0) {
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
        ),
      ],
    );
  }
}