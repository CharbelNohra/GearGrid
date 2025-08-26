import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_texTfield.dart';
import '../../../core/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validate email and password
    if (password.isEmpty || email.isEmpty) {
      _showError("All fields are required.");
      return;
    } else if (!Validators.isValidEmail(email)) {
      _showError("Please enter a valid email address.");
      return;
    } 

    setState(() {
      isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Call API to log in
      // await AuthService.login(email, password);
      
      setState(() {
        isLoading = false;
      });
      
      _showSuccess("Login successful!");
      
      // On success, navigate to home or next step
      // context.go('/main-layout');

      await Future.delayed(const Duration(seconds: 4));
      if (mounted) {
        context.go('/main-layout');
      }
      
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showError("Login failed. Please check your credentials.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/GearGrid.png'),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome back 👋",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Log in to your account",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),

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
                    onPressed: () {
                      context.go('/forgot-password');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: theme.primaryColor,
                    ),
                    child: const Text("Forgot password?"),
                  ),
                ),

                const SizedBox(height: 16),

                CustomButton(
                  text: isLoading ? "Logging in..." : "Login", 
                  onPressed: isLoading ? () {} : login,
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
                      onPressed: () {
                        context.go('/register');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: theme.primaryColor,
                      ),
                      child: const Text("Register"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}