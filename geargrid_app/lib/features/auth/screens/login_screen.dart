import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_texTfield.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
                Image.asset(
                  'assets/images/GearGrid.png',
                  height: 100,
                ),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome back 👋",
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Log in to your account",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                CustomTextField(
                  controller: emailController,
                  hintText: "Email",
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: passwordController,
                  hintText: "Password",
                  isPassword: true,
                ),
                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: theme.primaryColor,
                    ),
                    child: const Text("Forgot password?"),
                  ),
                ),

                const SizedBox(height: 16),

                CustomButton(
                  text: "Login",
                  onPressed: () {},
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