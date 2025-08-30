import 'package:flutter/material.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/services/api_services.dart';
import '../../../../features/auth/models/user_model.dart';
import 'login_welcome_header.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final Function(String) onLoginError;
  final VoidCallback onForgotPassword;
  final VoidCallback onNavigateToRegister;

  const LoginForm({
    super.key,
    required this.onLoginSuccess,
    required this.onLoginError,
    required this.onForgotPassword,
    required this.onNavigateToRegister,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (password.isEmpty || email.isEmpty) {
      widget.onLoginError("All fields are required.");
      return;
    }
    
    if (!Validators.isValidEmail(email)) {
      widget.onLoginError("Please enter a valid email address.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiService.login(
        email: email,
        password: password,
      );

      setState(() {
        isLoading = false;
      });

      if (result['success']) {
        final userData = result['data'];
        if (userData != null) {
          final user = User.fromJson(userData);
          
          if (user.role == 'admin') {
            SnackBarHelper.showError(
              context, 
              "Access Denied", 
              "This app is for clients only. Admin access is not allowed."
            );
            
            await ApiService.removeToken();
            return;
          }
        }
        
        widget.onLoginSuccess();
      } else {
        widget.onLoginError(result['error'] ?? "Login failed. Please try again.");
      }
      
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      widget.onLoginError("Network error. Please check your connection and try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        const LoginWelcomeHeader(),
        const SizedBox(height: 32),

        CustomTextField(
          controller: emailController,
          hintText: "Email",
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(
            Icons.email_outlined,
            color: colors.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
        ),
        const SizedBox(height: 16),

        CustomTextField(
          controller: passwordController,
          hintText: "Password",
          isPassword: true,
          prefixIcon: Icon(
            Icons.lock_outline,
            color: colors.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
        ),
        const SizedBox(height: 8),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: widget.onForgotPassword,
            style: TextButton.styleFrom(
              foregroundColor: colors.primary,
            ),
            child: const Text("Forgot password?"),
          ),
        ),

        const SizedBox(height: 16),

        CustomButton(
          text: isLoading ? "Logging in..." : "Login",
          onPressed: isLoading ? null : _login,
        ),

        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?",
              style: theme.textTheme.bodyMedium,
            ),
            TextButton(
              onPressed: widget.onNavigateToRegister,
              style: TextButton.styleFrom(
                foregroundColor: colors.primary,
              ),
              child: const Text("Register"),
            ),
          ],
        ),
      ],
    );
  }
}