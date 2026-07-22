import '../models/models.dart';

/// Static, hand-authored data for every mock screen -- no network, no
/// persistence. Realistic enough to exercise every design_system
/// component with plausible content, nothing more.
class MockData {
  const MockData._();

  static const account = BankAccount(
    id: 'acc-1',
    name: 'Verdant Prime',
    maskedNumber: '**** 4821',
    balance: 24850000,
  );

  static final cards = <BankCard>[
    const BankCard(
      id: 'card-1',
      holderName: 'AISHA PUTRI',
      last4: '4821',
      network: CardNetwork.verdantVisa,
      spendingLimit: 15000000,
      spentThisMonth: 6420000,
    ),
    const BankCard(
      id: 'card-2',
      holderName: 'AISHA PUTRI',
      last4: '7790',
      network: CardNetwork.verdantMastercard,
      frozen: true,
      spendingLimit: 5000000,
      spentThisMonth: 1200000,
    ),
  ];

  static final transactions = <Transaction>[
    Transaction(
      id: 'tx-1',
      title: 'Kopi Kenangan',
      category: 'Food & Drink',
      amount: 32000,
      date: DateTime(2026, 7, 22, 8, 14),
      direction: TransactionDirection.debit,
    ),
    Transaction(
      id: 'tx-2',
      title: 'Gaji Juli',
      category: 'Income',
      amount: 18500000,
      date: DateTime(2026, 7, 21, 9, 0),
      direction: TransactionDirection.credit,
    ),
    Transaction(
      id: 'tx-3',
      title: 'Transfer ke Budi Santoso',
      category: 'Transfer',
      amount: 500000,
      date: DateTime(2026, 7, 20, 19, 32),
      direction: TransactionDirection.debit,
    ),
    Transaction(
      id: 'tx-4',
      title: 'Listrik PLN',
      category: 'Bills',
      amount: 340000,
      date: DateTime(2026, 7, 19, 14, 2),
      direction: TransactionDirection.debit,
      status: TransactionStatus.pending,
    ),
    Transaction(
      id: 'tx-5',
      title: 'Netflix',
      category: 'Subscription',
      amount: 186000,
      date: DateTime(2026, 7, 18, 6, 0),
      direction: TransactionDirection.debit,
    ),
    Transaction(
      id: 'tx-6',
      title: 'Transfer dari Citra Dewi',
      category: 'Transfer',
      amount: 750000,
      date: DateTime(2026, 7, 17, 11, 20),
      direction: TransactionDirection.credit,
    ),
    Transaction(
      id: 'tx-7',
      title: 'Tokopedia',
      category: 'Shopping',
      amount: 215000,
      date: DateTime(2026, 7, 16, 20, 45),
      direction: TransactionDirection.debit,
      status: TransactionStatus.failed,
    ),
    Transaction(
      id: 'tx-8',
      title: 'Gojek',
      category: 'Transport',
      amount: 28000,
      date: DateTime(2026, 7, 16, 8, 5),
      direction: TransactionDirection.debit,
    ),
  ];

  static const recipients = <Recipient>[
    Recipient(
      id: 'rc-1',
      name: 'Budi Santoso',
      bankName: 'Verdant Bank',
      accountNumber: '1002348821',
      initials: 'BS',
    ),
    Recipient(
      id: 'rc-2',
      name: 'Citra Dewi',
      bankName: 'Bank Mandiri',
      accountNumber: '5590012234',
      initials: 'CD',
    ),
    Recipient(
      id: 'rc-3',
      name: 'Dimas Prasetyo',
      bankName: 'Verdant Bank',
      accountNumber: '1002991823',
      initials: 'DP',
    ),
    Recipient(
      id: 'rc-4',
      name: 'Eka Wulandari',
      bankName: 'BCA',
      accountNumber: '8871234410',
      initials: 'EW',
    ),
    Recipient(
      id: 'rc-5',
      name: 'Fajar Nugroho',
      bankName: 'Verdant Bank',
      accountNumber: '1002774193',
      initials: 'FN',
    ),
  ];

  static const investments = <Investment>[
    Investment(
      id: 'inv-1',
      symbol: 'VRDT',
      name: 'Verdant Growth Fund',
      shares: 120,
      price: 18400,
      changePercent: 2.4,
      history: [
        15200,
        15800,
        16100,
        15900,
        16700,
        17200,
        16950,
        17600,
        18100,
        18400,
      ],
    ),
    Investment(
      id: 'inv-2',
      symbol: 'MOSS',
      name: 'Moss Index Fund',
      shares: 45,
      price: 9820,
      changePercent: -1.1,
      history: [
        10400,
        10250,
        10100,
        10300,
        9950,
        9880,
        10020,
        9900,
        9950,
        9820,
      ],
    ),
    Investment(
      id: 'inv-3',
      symbol: 'STON',
      name: 'Stone Money Market',
      shares: 300,
      price: 1005,
      changePercent: 0.2,
      history: [1000, 1001, 1001, 1002, 1002, 1003, 1003, 1004, 1004, 1005],
    ),
  ];

  static const billers = <Biller>[
    Biller(
      id: 'bl-1',
      name: 'PLN',
      category: 'Electricity',
      logoInitial: 'P',
      savedAccountNumber: '532001887723',
      autoPay: true,
    ),
    Biller(
      id: 'bl-2',
      name: 'PDAM',
      category: 'Water',
      logoInitial: 'W',
      savedAccountNumber: '90012234',
    ),
    Biller(
      id: 'bl-3',
      name: 'IndiHome',
      category: 'Internet',
      logoInitial: 'I',
      savedAccountNumber: '332211009',
      autoPay: true,
    ),
    Biller(
      id: 'bl-4',
      name: 'BPJS Kesehatan',
      category: 'Insurance',
      logoInitial: 'B',
    ),
  ];

  static const billerCategories = [
    'Electricity',
    'Water',
    'Internet',
    'Insurance',
    'Credit Card',
  ];

  static final notifications = <AppNotificationItem>[
    AppNotificationItem(
      id: 'nt-1',
      title: 'Transfer received',
      body: 'Citra Dewi sent you Rp750.000',
      timestamp: DateTime(2026, 7, 22, 7, 10),
      type: NotificationType.transaction,
    ),
    AppNotificationItem(
      id: 'nt-2',
      title: 'New device login',
      body: 'Your account was accessed from a new device in Jakarta',
      timestamp: DateTime(2026, 7, 21, 22, 40),
      type: NotificationType.security,
    ),
    AppNotificationItem(
      id: 'nt-3',
      title: 'Bill due tomorrow',
      body: 'IndiHome autopay of Rp385.000 is scheduled for tomorrow',
      timestamp: DateTime(2026, 7, 21, 9, 0),
      read: true,
      type: NotificationType.transaction,
    ),
    AppNotificationItem(
      id: 'nt-4',
      title: 'Portfolio update',
      body: 'VRDT is up 2.4% this week',
      timestamp: DateTime(2026, 7, 20, 17, 30),
      read: true,
      type: NotificationType.promo,
    ),
  ];
}
