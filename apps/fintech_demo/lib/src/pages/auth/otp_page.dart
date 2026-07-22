import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/routes.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String? _error;
  bool _verifying = false;
  int _secondsLeft = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _secondsLeft = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) timer.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _onCompleted(String code) async {
    setState(() {
      _verifying = true;
      _error = null;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _verifying = false);
    if (code == '000000') {
      setState(() => _error = 'Incorrect code, try again');
      return;
    }
    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: VerdantIcon(
            VerdantGlyph.chevronLeft,
            color: colorScheme.onSurface,
          ),
          onPressed: () => context.go(Routes.login),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verify your number',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: context.spacing.xxs),
              Text(
                'Enter the 6-digit code sent to +62 812-****-4821. '
                'Use 000000 to see the error state.',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              SizedBox(height: context.spacing.xl),
              Center(
                child: AppOtpField(
                  errorText: _error,
                  onCompleted: _onCompleted,
                ),
              ),
              SizedBox(height: context.spacing.lg),
              if (_verifying)
                const Center(child: AppLoadingIndicator())
              else
                Center(
                  child: _secondsLeft > 0
                      ? Text(
                          'Resend code in ${_secondsLeft}s',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        )
                      : TextButton(
                          onPressed: () {
                            _startCountdown();
                            setState(() {});
                            AppSnackBar.showInfo(
                              context,
                              'A new code was sent',
                            );
                          },
                          child: const Text('Resend code'),
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
