/// Small formatting helpers shared across screens. Hand-rolled rather than
/// pulling in `intl` -- this app only ever formats one locale's currency
/// and a handful of relative-time strings, not worth a whole dependency.
class Format {
  const Format._();

  static String rupiah(double amount, {bool showSign = false}) {
    final negative = amount < 0;
    final rounded = amount.abs().round();
    final digits = rounded.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    final sign = negative ? '-' : (showSign ? '+' : '');
    return '${sign}Rp$buffer';
  }

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String date(DateTime date) =>
      '${date.day} ${_months[date.month - 1]} ${date.year}';

  static String dateTime(DateTime date) =>
      '${Format.date(date)}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

  static String relativeTime(DateTime date, DateTime now) {
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return Format.date(date);
  }
}
