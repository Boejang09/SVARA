import 'package:flutter/foundation.dart';
import 'package:svara_app/core/mock/screening_record.dart';

/// In-memory mock store untuk MVP frontend (tanpa backend).
class ScreeningStore {
  ScreeningStore._();

  static final ValueNotifier<List<ScreeningRecord>> records =
      ValueNotifier<List<ScreeningRecord>>(_seedRecords);

  static final List<ScreeningRecord> _seedRecords = [
    ScreeningRecord(
      id: 'SV-4492-B',
      date: ScreeningRecordDate.oct24_2023,
      title: 'Skrining Jantung Penuh',
      riskScore: 92,
      riskLevel: 'Risiko Rendah',
      isLowRisk: true,
      heartStatus: 'Normal',
    ),
    ScreeningRecord(
      id: 'SV-3821-A',
      date: ScreeningRecordDate.oct12_2023,
      title: 'Pemeriksaan Pagi',
      riskScore: 68,
      riskLevel: 'Sedang',
      isLowRisk: false,
      heartStatus: 'Takikardia',
      type: 'jantung',
    ),
    ScreeningRecord(
      id: 'SV-2910-C',
      date: ScreeningRecordDate.sep28_2023,
      title: 'Catatan Pasca-Olahraga',
      riskScore: 88,
      riskLevel: 'Risiko Rendah',
      isLowRisk: true,
      heartStatus: 'Normal',
    ),
    ScreeningRecord(
      id: 'SV-1842-X',
      date: ScreeningRecordDate.sep15_2023,
      title: 'Baseline Bulanan',
      riskScore: 91,
      riskLevel: 'Risiko Rendah',
      isLowRisk: true,
      heartStatus: 'Normal',
    ),
  ];

  static void addLatestResult() {
    final now = DateTime.now();
    final id =
        'SV-${now.millisecondsSinceEpoch % 10000}-${String.fromCharCode(65 + now.second % 26)}';

    records.value = [
      ScreeningRecord(
        id: id,
        date: now,
        title: 'Skrining Jantung',
        riskScore: 92,
        riskLevel: 'Risiko Rendah',
        isLowRisk: true,
        heartStatus: 'Normal',
      ),
      ...records.value,
    ];
  }

  static List<ScreeningRecord> filtered({int filterIndex = 0}) {
    final all = records.value;
    return switch (filterIndex) {
      1 =>
        all
            .where((r) => r.type == 'jantung' || r.heartStatus != 'Normal')
            .toList(),
      _ => all,
    };
  }
}

/// Tanggal tetap untuk data awal (const-friendly).
abstract final class ScreeningRecordDate {
  static final oct24_2023 = DateTime(2023, 10, 24);
  static final oct12_2023 = DateTime(2023, 10, 12);
  static final sep28_2023 = DateTime(2023, 9, 28);
  static final sep15_2023 = DateTime(2023, 9, 15);
}
