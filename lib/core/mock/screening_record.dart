class ScreeningRecord {
  final String id;
  final DateTime date;
  final String title;
  final int riskScore;
  final String riskLevel;
  final bool isLowRisk;
  final String heartStatus;
  final String type;

  const ScreeningRecord({
    required this.id,
    required this.date,
    required this.title,
    required this.riskScore,
    required this.riskLevel,
    required this.isLowRisk,
    required this.heartStatus,
    this.type = 'jantung',
  });

  String get formattedDate {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String get idText => 'ID: $id';
}
