import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(
    text: 'aisha.putri@example.com',
  );
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    setState(() {
      _emailError = email.contains('@') ? null : 'Enter a valid email';
      _passwordError = password.length >= 6
          ? null
          : 'Password must be at least 6 characters';
    });
    if (_emailError != null || _passwordError != null) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _loading = false);
    AppSnackBar.showInfo(context, 'OTP sent to your registered number');
    context.go(Routes.otp);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.spacing.xxl),
              Text(
                'Welcome back',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: context.spacing.xxs),
              Text(
                'Log in to continue to Verdant Bank',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              SizedBox(height: context.spacing.xl),
              AppTextField(
                label: 'Email',
                controller: _emailController,
                errorText: _emailError,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: context.spacing.md),
              AppPasswordField(
                label: 'Password',
                controller: _passwordController,
                errorText: _passwordError,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => AppDialog.confirm(
                    context,
                    title: 'Reset password',
                    message:
                        'A password reset link would be sent to your email in a real app.',
                    confirmLabel: 'OK',
                    cancelLabel: 'Cancel',
                  ),
                  child: const Text('Forgot password?'),
                ),
              ),
              SizedBox(height: context.spacing.md),
              AppButton(label: 'Log in', loading: _loading, onPressed: _submit),
              SizedBox(height: context.spacing.lg),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () => context.go(Routes.register),
                      child: const Text('Sign up'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
