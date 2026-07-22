import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _biometric = true;
  bool _pushNotifications = true;
  String _language = 'English';

  Future<void> _pickLanguage() async {
    final selected = await AppBottomSheet.show<String>(
      context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final lang in ['English', 'Bahasa Indonesia'])
              ListTile(
                title: Text(lang),
                trailing: lang == _language ? const Icon(Icons.check) : null,
                onTap: () => Navigator.of(context).pop(lang),
              ),
          ],
        ),
      ),
    );
    if (selected != null) setState(() => _language = selected);
  }

  Future<void> _logout() async {
    final confirmed = await AppDialog.confirm(
      context,
      title: 'Log out?',
      message: "You'll need to verify your identity again to sign back in.",
      confirmLabel: 'Log out',
    );
    if (confirmed == true && mounted) {
      context.go(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(context.spacing.lg),
          children: [
            AppExpressiveCard(
              child: Padding(
                padding: EdgeInsets.all(context.spacing.md),
                child: Row(
                  children: [
                    const AppAvatar(initials: 'AP', size: AppAvatarSize.large),
                    SizedBox(width: context.spacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Aisha Putri',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            'aisha.putri@example.com',
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
            ),
            SizedBox(height: context.spacing.xl),
            Text('Security', style: Theme.of(context).textTheme.titleSmall),
            SizedBox(height: context.spacing.xs),
            AppCard(
              child: Column(
                children: [
                  _SettingsSwitchRow(
                    icon: Icons.fingerprint,
                    label: 'Biometric login',
                    value: _biometric,
                    onChanged: (v) => setState(() => _biometric = v),
                  ),
                  const Divider(height: 1),
                  _SettingsSwitchRow(
                    icon: Icons.notifications_none,
                    label: 'Push notifications',
                    value: _pushNotifications,
                    onChanged: (v) => setState(() => _pushNotifications = v),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.spacing.lg),
            Text('Preferences', style: Theme.of(context).textTheme.titleSmall),
            SizedBox(height: context.spacing.xs),
            AppCard(
              child: Column(
                children: [
                  _SettingsRow(
                    icon: Icons.language,
                    label: 'Language',
                    trailing: _language,
                    onTap: _pickLanguage,
                  ),
                  const Divider(height: 1),
                  _SettingsRow(
                    icon: Icons.help_outline,
                    label: 'Help & support',
                    tooltip: 'Not wired to a real flow in this template',
                    onTap: () => AppSnackBar.showInfo(
                      context,
                      'Help & support is not wired in this template',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.spacing.xl),
            AppButton(label: 'Log out', onPressed: _logout),
          ],
        ),
      ),
    );
  }
}

class _SettingsSwitchRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.sm,
        vertical: context.spacing.xs,
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.onSurfaceVariant),
          SizedBox(width: context.spacing.sm),
          Expanded(child: Text(label)),
          AppSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final String? tooltip;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.icon,
    required this.label,
    this.trailing,
    this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final trailingWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (trailing != null)
          Text(
            trailing!,
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        SizedBox(width: context.spacing.xxs),
        Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
      ],
    );

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing.sm,
          vertical: context.spacing.xs,
        ),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.onSurfaceVariant),
            SizedBox(width: context.spacing.sm),
            Expanded(child: Text(label)),
            if (tooltip != null)
              AppTooltip(message: tooltip!, child: trailingWidget)
            else
              trailingWidget,
          ],
        ),
      ),
    );
  }
}
