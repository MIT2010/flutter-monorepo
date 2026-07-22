import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/routes.dart';

class _Slide {
  final VerdantGlyph glyph;
  final String title;
  final String body;

  const _Slide({required this.glyph, required this.title, required this.body});
}

const _slides = [
  _Slide(
    glyph: VerdantGlyph.check,
    title: 'One account, everything money',
    body: 'Send, save, invest, and pay bills without leaving Verdant Bank.',
  ),
  _Slide(
    glyph: VerdantGlyph.eye,
    title: 'See where your money goes',
    body:
        'Real-time spending charts and a full transaction history, always in reach.',
  ),
  _Slide(
    glyph: VerdantGlyph.chevronDown,
    title: 'Grow it, deliberately',
    body:
        'Track a simple, low-fee investment portfolio alongside your everyday balance.',
  ),
];

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index == _slides.length - 1) {
      context.go(Routes.login);
      return;
    }
    _controller.nextPage(
      duration: context.motion.durationStandard,
      curve: context.motion.curveEnter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(context.spacing.md),
                child: TextButton(
                  onPressed: () => context.go(Routes.login),
                  child: const Text('Skip'),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                children: [
                  for (final slide in _slides)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spacing.xl,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.primaryContainer,
                            ),
                            child: Center(
                              child: VerdantIcon(
                                slide.glyph,
                                size: 40,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          SizedBox(height: context.spacing.xl),
                          Text(
                            slide.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(height: context.spacing.sm),
                          Text(
                            slide.body,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _slides.length; i++)
                  AnimatedContainer(
                    duration: context.motion.durationMicro,
                    margin: EdgeInsets.symmetric(
                      horizontal: context.spacing.xxxs,
                    ),
                    width: i == _index ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == _index
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(context.spacing.lg),
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: _index == _slides.length - 1 ? 'Get started' : 'Next',
                  onPressed: _next,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
