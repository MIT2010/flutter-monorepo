import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../utils/format.dart';

enum _TransferSpeed { instant, scheduled }

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  Recipient? _recipient;
  final _searchController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  _TransferSpeed _speed = _TransferSpeed.instant;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  List<Recipient> get _filtered {
    if (_query.isEmpty) return MockData.recipients;
    final q = _query.toLowerCase();
    return MockData.recipients
        .where((r) => r.name.toLowerCase().contains(q))
        .toList();
  }

  Future<void> _confirmAndSend() async {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (_recipient == null || amount <= 0) return;

    final confirmed = await AppDialog.confirm(
      context,
      title: 'Send ${Format.rupiah(amount)}?',
      message:
          'To ${_recipient!.name} (${_recipient!.bankName}, '
          '${_recipient!.accountNumber}). This cannot be undone.',
      confirmLabel: 'Send',
    );
    if (confirmed != true || !mounted) return;

    AppSnackBar.showSuccess(context, 'Transfer to ${_recipient!.name} sent');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer'),
        leading: IconButton(
          icon: VerdantIcon(
            VerdantGlyph.chevronLeft,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: _recipient == null ? _buildPickRecipient() : _buildEnterAmount(),
      ),
    );
  }

  Widget _buildPickRecipient() {
    return Padding(
      padding: EdgeInsets.all(context.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Who are you sending to?',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: context.spacing.sm),
          AppSearchField(
            controller: _searchController,
            hintText: 'Search recipients',
            onChanged: (v) => setState(() => _query = v),
          ),
          SizedBox(height: context.spacing.md),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (context, i) {
                final recipient = _filtered[i];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: AppAvatar(initials: recipient.initials),
                  title: Text(recipient.name),
                  subtitle: Text(
                    '${recipient.bankName} • ${recipient.accountNumber}',
                  ),
                  onTap: () => setState(() => _recipient = recipient),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnterAmount() {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(context.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(initials: _recipient!.initials),
              SizedBox(width: context.spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _recipient!.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${_recipient!.bankName} • ${_recipient!.accountNumber}',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _recipient = null),
                child: const Text('Change'),
              ),
            ],
          ),
          SizedBox(height: context.spacing.xl),
          AppTextField(
            label: 'Amount (IDR)',
            controller: _amountController,
            keyboardType: TextInputType.number,
            hintText: '0',
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: context.spacing.md),
          AppTextField(
            label: 'Note (optional)',
            controller: _noteController,
            hintText: 'What is this for?',
          ),
          SizedBox(height: context.spacing.lg),
          Text('Speed', style: Theme.of(context).textTheme.titleSmall),
          SizedBox(height: context.spacing.xs),
          Row(
            children: [
              _SpeedOption(
                label: 'Instant',
                value: _TransferSpeed.instant,
                groupValue: _speed,
                onChanged: (v) => setState(() => _speed = v),
              ),
              SizedBox(width: context.spacing.lg),
              _SpeedOption(
                label: 'Scheduled',
                value: _TransferSpeed.scheduled,
                groupValue: _speed,
                onChanged: (v) => setState(() => _speed = v),
              ),
            ],
          ),
          const Spacer(),
          AppButton(
            label: 'Review and send',
            onPressed: (double.tryParse(_amountController.text) ?? 0) > 0
                ? _confirmAndSend
                : null,
          ),
        ],
      ),
    );
  }
}

class _SpeedOption extends StatelessWidget {
  final String label;
  final _TransferSpeed value;
  final _TransferSpeed groupValue;
  final ValueChanged<_TransferSpeed> onChanged;

  const _SpeedOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppRadio<_TransferSpeed>(
            value: value,
            groupValue: groupValue,
            onChanged: (v) => onChanged(v as _TransferSpeed),
          ),
          SizedBox(width: context.spacing.xxs),
          Text(label),
        ],
      ),
    );
  }
}
