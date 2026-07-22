import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../utils/format.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  late var _cards = MockData.cards;

  void _toggleFrozen(String cardId) {
    setState(() {
      _cards = [
        for (final card in _cards)
          if (card.id == cardId) card.copyWith(frozen: !card.frozen) else card,
      ];
    });
  }

  Future<void> _showCardMenu(
    BuildContext context,
    Offset position,
    BankCard card,
  ) async {
    final action = await AppMenu.show<String>(
      context,
      position: position,
      items: const [
        AppMenuItem(value: 'limit', label: 'Change limit', icon: Icons.tune),
        AppMenuItem(value: 'pin', label: 'View PIN', icon: Icons.lock_outline),
        AppMenuItem(
          value: 'report',
          label: 'Report lost',
          icon: Icons.report_outlined,
        ),
      ],
    );
    if (action == null || !context.mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    AppSnackBar.showInfo(
      context,
      "'$action' isn't wired to a real flow in this template",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cards')),
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.all(context.spacing.lg),
          itemCount: _cards.length,
          separatorBuilder: (context, i) =>
              SizedBox(height: context.spacing.lg),
          itemBuilder: (context, i) => _CardTile(
            card: _cards[i],
            onToggleFrozen: () => _toggleFrozen(_cards[i].id),
            onMenu: (position) => _showCardMenu(context, position, _cards[i]),
          ),
        ),
      ),
    );
  }
}

class _CardTile extends StatelessWidget {
  final BankCard card;
  final VoidCallback onToggleFrozen;
  final ValueChanged<Offset> onMenu;

  const _CardTile({
    required this.card,
    required this.onToggleFrozen,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = (card.spentThisMonth / card.spendingLimit).clamp(0.0, 1.0);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 30,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(context.shape.radiusXs),
                ),
                child: Center(
                  child: Text(
                    card.network == CardNetwork.verdantVisa ? 'VISA' : 'MC',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: context.spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '•••• •••• •••• ${card.last4}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      card.holderName,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (iconContext) => IconButton(
                  icon: VerdantIcon(
                    VerdantGlyph.chevronDown,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    final box = iconContext.findRenderObject() as RenderBox;
                    final position = box.localToGlobal(
                      Offset(0, box.size.height),
                    );
                    onMenu(position);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: context.spacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.frozen ? 'Card frozen' : 'Card active',
                style: TextStyle(
                  color: card.frozen
                      ? colorScheme.error
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              AppSwitch(value: card.frozen, onChanged: (_) => onToggleFrozen()),
            ],
          ),
          SizedBox(height: context.spacing.sm),
          Text(
            '${Format.rupiah(card.spentThisMonth)} of ${Format.rupiah(card.spendingLimit)} spent',
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
          ),
          SizedBox(height: context.spacing.xxs),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: colorScheme.surfaceContainerHigh,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
