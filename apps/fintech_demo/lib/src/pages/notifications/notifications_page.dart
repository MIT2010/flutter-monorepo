import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../../utils/format.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late var _notifications = MockData.notifications;

  void _markAllRead() {
    setState(() {
      _notifications = [
        for (final n in _notifications)
          AppNotificationItem(
            id: n.id,
            title: n.title,
            body: n.body,
            timestamp: n.timestamp,
            read: true,
            type: n.type,
          ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: SafeArea(
        child: _notifications.isEmpty
            ? const AppStateView(
                message: "You're all caught up",
                icon: Icons.notifications_none,
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: context.spacing.sm),
                itemCount: _notifications.length,
                itemBuilder: (context, i) =>
                    _NotificationRow(item: _notifications[i], now: now),
              ),
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  final AppNotificationItem item;
  final DateTime now;

  const _NotificationRow({required this.item, required this.now});

  IconData get _icon => switch (item.type) {
    NotificationType.transaction => Icons.receipt_long_outlined,
    NotificationType.security => Icons.shield_outlined,
    NotificationType.promo => Icons.local_offer_outlined,
    NotificationType.system => Icons.info_outline,
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: item.read
          ? null
          : colorScheme.primaryContainer.withValues(alpha: 0.35),
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.lg,
        vertical: context.spacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.surfaceContainerHigh,
            ),
            child: Icon(_icon, size: 18, color: colorScheme.onSurfaceVariant),
          ),
          SizedBox(width: context.spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: context.spacing.xxxs),
                Text(
                  item.body,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                SizedBox(height: context.spacing.xxxs),
                Text(
                  Format.relativeTime(item.timestamp, now),
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
