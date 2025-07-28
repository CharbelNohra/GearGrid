import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/custom_phonefield.dart';
import '../../../common/widgets/custom_textfield.dart';
import '../../../common/widgets/dropdown_list.dart';
import '../../../core/constants/countries.dart';
import '../../../core/constants/countries_phone_code.dart';
import '../../../core/utils/validators.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _pageController = PageController();

  // Step 1
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Step 2
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  String? selectedCountry;

  int currentStep = 0;

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

  void nextStep() {
    if (currentStep == 0) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();

      if (!Validators.isValidEmail(email)) {
        _showError("Please enter a valid email address.");
        return;
      }

      if (!Validators.isValidPassword(password)) {
        _showError(
          "Password must be at least 8 characters, include upper/lower case letters, and a number or symbol.",
        );
        return;
      }

      if (password != confirmPassword) {
        _showError("Passwords do not match.");
        return;
      }

      if (nameController.text.isEmpty) {
        _showError("Full name is required.");
        return;
      }
    } else if (currentStep == 1) {
      if (selectedCountry == null ||
          addressController.text.isEmpty ||
          phoneController.text.isEmpty) {
        _showError("Please complete all fields.");
        return;
      }
    }

    if (currentStep < 1) {
      setState(() => currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => OTPVerificationScreen(
                email: emailController.text.trim(),
                phoneNumber: phoneController.text.trim(),
              ),
        ),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
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

  Widget buildLogo() {
    return Column(
      children: [Image.asset('assets/images/GearGrid.png', height: 100)],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          // <-- Center entire content vertically + horizontally
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 400, // max width for better layout on wide screens
                minHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // vertical centering
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // horizontal centering
                  children: [
                    buildLogo(),
                    SizedBox(
                      height: 400,
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // Step 1
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Step 1 of 2",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colors.primary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: emailController,
                                hintText: "Email",
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: colors.onSurface.withValues(alpha: 0.6),
                                  size: 20,
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: nameController,
                                hintText: "Full Name",
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: colors.onSurface.withValues(alpha: 0.6),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: passwordController,
                                hintText: "Password",
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: colors.onSurface.withValues(alpha: 0.6),
                                  size: 20,
                                ),
                                isPassword: true,
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: confirmPasswordController,
                                hintText: "Confirm Password",
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: colors.onSurface.withValues(alpha: 0.6),
                                  size: 20,
                                ),
                                isPassword: true,
                              ),
                            ],
                          ),

                          // Step 2
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Step 2 of 2",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colors.primary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              CustomDropdownField<String>(
                                value: selectedCountry,
                                hintText: "Select your country",
                                items:
                                    countries
                                        .map(
                                          (country) => DropdownMenuItem(
                                            value: country,
                                            child: Text(country),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    selectedCountry = val;
                                  });
                                }
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: addressController,
                                hintText: "Address",
                                prefixIcon: Icon(
                                  Icons.location_on_outlined,
                                  color: colors.onSurface.withValues(alpha: 0.6),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(height: 16),
                              CustomPhoneField(
                                controller: phoneController,
                                hintText: "Enter phone number",
                                countryCode:
                                    selectedCountry != null
                                        ? countryPhoneCodes[selectedCountry!]
                                        : null,
                                onCountryTap: () {
                                  // Optional: You can add logic to open country selector here
                                  // For now, it just shows the country code is tappable
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Navigation arrows instead of buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back arrow - only if currentStep > 0
                        if (currentStep > 0)
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: colors.primary,
                            ),
                            onPressed: previousStep,
                          )
                        else
                          SizedBox(width: 48), // spacer to keep alignment
                        // Next or Submit arrow
                        IconButton(
                          icon: Icon(
                            currentStep == 1
                                ? Icons.check_circle
                                : Icons.arrow_forward_ios,
                            color: colors.primary,
                            size: 28,
                          ),
                          onPressed: nextStep,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: theme.textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          style: TextButton.styleFrom(
                            foregroundColor: colors.primary,
                          ),
                          child: const Text("Login"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}