/// Plain, immutable view-data models for the mock screens in this app.
/// No JSON (de)serialization, no repository/DI abstraction on top of
/// these -- this is a static UI template, not a real backend integration
/// (see this package's own pubspec description).
library;

enum TransactionDirection { credit, debit }

enum TransactionStatus { success, pending, failed }

class BankAccount {
  final String id;
  final String name;
  final String maskedNumber;
  final double balance;
  final String currency;

  const BankAccount({
    required this.id,
    required this.name,
    required this.maskedNumber,
    required this.balance,
    this.currency = 'IDR',
  });
}

enum CardNetwork { verdantVisa, verdantMastercard }

class BankCard {
  final String id;
  final String holderName;
  final String last4;
  final CardNetwork network;
  final bool frozen;
  final double spendingLimit;
  final double spentThisMonth;

  const BankCard({
    required this.id,
    required this.holderName,
    required this.last4,
    required this.network,
    this.frozen = false,
    required this.spendingLimit,
    required this.spentThisMonth,
  });

  BankCard copyWith({bool? frozen}) => BankCard(
    id: id,
    holderName: holderName,
    last4: last4,
    network: network,
    frozen: frozen ?? this.frozen,
    spendingLimit: spendingLimit,
    spentThisMonth: spentThisMonth,
  );
}

class Transaction {
  final String id;
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final TransactionDirection direction;
  final TransactionStatus status;

  const Transaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.direction,
    this.status = TransactionStatus.success,
  });
}

class Recipient {
  final String id;
  final String name;
  final String bankName;
  final String accountNumber;
  final String initials;

  const Recipient({
    required this.id,
    required this.name,
    required this.bankName,
    required this.accountNumber,
    required this.initials,
  });
}

class Investment {
  final String id;
  final String symbol;
  final String name;
  final double shares;
  final double price;
  final double changePercent;
  final List<double> history;

  const Investment({
    required this.id,
    required this.symbol,
    required this.name,
    required this.shares,
    required this.price,
    required this.changePercent,
    required this.history,
  });

  double get value => shares * price;
}

class Biller {
  final String id;
  final String name;
  final String category;
  final String logoInitial;
  final String? savedAccountNumber;
  final bool autoPay;

  const Biller({
    required this.id,
    required this.name,
    required this.category,
    required this.logoInitial,
    this.savedAccountNumber,
    this.autoPay = false,
  });
}

enum NotificationType { transaction, security, promo, system }

class AppNotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool read;
  final NotificationType type;

  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.read = false,
    required this.type,
  });
}
