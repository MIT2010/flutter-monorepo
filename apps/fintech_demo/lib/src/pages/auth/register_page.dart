import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/routes.dart';

enum _AccountType { personal, business }

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _step = 0;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  DateTime? _birthDate;

  String? _idType = 'ktp';
  final _idNumberController = TextEditingController();
  final _addressController = TextEditingController();
  _AccountType _accountType = _AccountType.personal;

  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    // Continue/Create is enabled based on live field state (`_canContinueStepN`
    // getters) -- these controllers have no other listener, so without this
    // the button's enabled state would only refresh on some *other*
    // unrelated rebuild instead of on every keystroke.
    for (final controller in [
      _nameController,
      _phoneController,
      _idNumberController,
      _addressController,
    ]) {
      controller.addListener(_refresh);
    }
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    for (final controller in [
      _nameController,
      _phoneController,
      _idNumberController,
      _addressController,
    ]) {
      controller.removeListener(_refresh);
    }
    _nameController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _idNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  bool get _canContinueStep0 =>
      _nameController.text.trim().isNotEmpty &&
      _phoneController.text.trim().isNotEmpty &&
      _birthDate != null;

  bool get _canContinueStep1 =>
      _idNumberController.text.trim().isNotEmpty &&
      _addressController.text.trim().isNotEmpty;

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await AppDatePicker.show(
      context,
      initialDate: _birthDate ?? DateTime(now.year - 20),
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year - 17),
      today: now,
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _birthDateController.text =
            '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _submit() async {
    final confirmed = await AppDialog.confirm(
      context,
      title: 'Create account?',
      message:
          'Your Verdant Bank account for ${_nameController.text.trim()} '
          'will be created with the details you entered.',
      confirmLabel: 'Create',
    );
    if (confirmed != true || !mounted) return;
    AppSnackBar.showSuccess(
      context,
      'Account created -- welcome to Verdant Bank',
    );
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
          onPressed: () {
            if (_step == 0) {
              context.go(Routes.login);
            } else {
              setState(() => _step--);
            }
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppStepper(
                currentStep: _step,
                stepCount: 3,
                labels: const ['Personal', 'Address & ID', 'Review'],
              ),
              SizedBox(height: context.spacing.xl),
              Expanded(
                child: SingleChildScrollView(
                  child: switch (_step) {
                    0 => _PersonalInfoStep(
                      nameController: _nameController,
                      phoneController: _phoneController,
                      birthDateController: _birthDateController,
                      onPickBirthDate: _pickBirthDate,
                    ),
                    1 => _AddressIdStep(
                      idType: _idType,
                      onIdTypeChanged: (v) => setState(() => _idType = v),
                      idNumberController: _idNumberController,
                      addressController: _addressController,
                      accountType: _accountType,
                      onAccountTypeChanged: (v) =>
                          setState(() => _accountType = v),
                    ),
                    _ => _ReviewStep(
                      name: _nameController.text,
                      phone: _phoneController.text,
                      idNumber: _idNumberController.text,
                      address: _addressController.text,
                      accountType: _accountType,
                      agreed: _agreedToTerms,
                      onAgreedChanged: (v) =>
                          setState(() => _agreedToTerms = v ?? false),
                    ),
                  },
                ),
              ),
              SizedBox(height: context.spacing.md),
              AppButton(
                label: _step == 2 ? 'Create account' : 'Continue',
                onPressed: switch (_step) {
                  0 =>
                    _canContinueStep0 ? () => setState(() => _step = 1) : null,
                  1 =>
                    _canContinueStep1 ? () => setState(() => _step = 2) : null,
                  _ => _agreedToTerms ? _submit : null,
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PersonalInfoStep extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController birthDateController;
  final VoidCallback onPickBirthDate;

  const _PersonalInfoStep({
    required this.nameController,
    required this.phoneController,
    required this.birthDateController,
    required this.onPickBirthDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(label: 'Full name', controller: nameController),
        SizedBox(height: context.spacing.md),
        AppTextField(
          label: 'Phone number',
          controller: phoneController,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: context.spacing.md),
        AppTextField(
          label: 'Date of birth',
          readOnly: true,
          onTap: onPickBirthDate,
          controller: birthDateController,
          hintText: 'Tap to select',
          suffixIcon: VerdantIcon(
            VerdantGlyph.chevronDown,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _AddressIdStep extends StatelessWidget {
  final String? idType;
  final ValueChanged<String?> onIdTypeChanged;
  final TextEditingController idNumberController;
  final TextEditingController addressController;
  final _AccountType accountType;
  final ValueChanged<_AccountType> onAccountTypeChanged;

  const _AddressIdStep({
    required this.idType,
    required this.onIdTypeChanged,
    required this.idNumberController,
    required this.addressController,
    required this.accountType,
    required this.onAccountTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDropdown<String>(
          label: 'ID type',
          value: idType,
          items: const [
            AppDropdownItem(value: 'ktp', label: 'KTP'),
            AppDropdownItem(value: 'passport', label: 'Passport'),
            AppDropdownItem(value: 'sim', label: "Driver's license"),
          ],
          onChanged: onIdTypeChanged,
        ),
        SizedBox(height: context.spacing.md),
        AppTextField(label: 'ID number', controller: idNumberController),
        SizedBox(height: context.spacing.md),
        AppTextField(label: 'Home address', controller: addressController),
        SizedBox(height: context.spacing.lg),
        Text('Account type', style: Theme.of(context).textTheme.titleSmall),
        SizedBox(height: context.spacing.xs),
        _RadioOption(
          label: 'Personal',
          value: _AccountType.personal,
          groupValue: accountType,
          onChanged: onAccountTypeChanged,
        ),
        _RadioOption(
          label: 'Business',
          value: _AccountType.business,
          groupValue: accountType,
          onChanged: onAccountTypeChanged,
        ),
      ],
    );
  }
}

class _RadioOption extends StatelessWidget {
  final String label;
  final _AccountType value;
  final _AccountType groupValue;
  final ValueChanged<_AccountType> onChanged;

  const _RadioOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.spacing.xxs),
        child: Row(
          children: [
            AppRadio<_AccountType>(
              value: value,
              groupValue: groupValue,
              onChanged: (v) => onChanged(v as _AccountType),
            ),
            SizedBox(width: context.spacing.xs),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _ReviewStep extends StatelessWidget {
  final String name;
  final String phone;
  final String idNumber;
  final String address;
  final _AccountType accountType;
  final bool agreed;
  final ValueChanged<bool?> onAgreedChanged;

  const _ReviewStep({
    required this.name,
    required this.phone,
    required this.idNumber,
    required this.address,
    required this.accountType,
    required this.agreed,
    required this.onAgreedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReviewRow(label: 'Full name', value: name),
              _ReviewRow(label: 'Phone', value: phone),
              _ReviewRow(label: 'ID number', value: idNumber),
              _ReviewRow(label: 'Address', value: address),
              _ReviewRow(
                label: 'Account type',
                value: accountType == _AccountType.personal
                    ? 'Personal'
                    : 'Business',
              ),
            ],
          ),
        ),
        SizedBox(height: context.spacing.lg),
        InkWell(
          onTap: () => onAgreedChanged(!agreed),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCheckbox(value: agreed, onChanged: onAgreedChanged),
              SizedBox(width: context.spacing.xs),
              Expanded(
                child: Text(
                  'I agree to the Terms of Service and Privacy Policy',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReviewRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.spacing.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
