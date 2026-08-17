import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:svara_app/core/router/app_routes.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/services/api_service.dart';
import 'package:svara_app/widgets/skeleton/skeleton.dart';
import 'package:svara_app/widgets/svara_logo.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isLoading = true;
  List<dynamic> _histories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await ApiService.getHistory();

    if (mounted) {
      setState(() {
        _histories = data ?? [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgMint,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const SvaraWordmark(markSize: 32, fontSize: 20),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppTheme.primaryDarkTeal,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.notifications);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const HistorySkeleton()
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari skrining...',
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppTheme.textMuted,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (_histories.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text(
                            'Belum ada riwayat skrining.',
                            style: TextStyle(color: AppTheme.textMuted),
                          ),
                        ),
                      )
                    else
                      Column(
                        children: _histories
                            .map(
                              (record) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _HistoryRecordCard(record: record),
                              ),
                            )
                            .toList(),
                      ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }
}

class _HistoryRecordCard extends StatefulWidget {
  final Map<String, dynamic> record;

  const _HistoryRecordCard({required this.record});

  @override
  State<_HistoryRecordCard> createState() => _HistoryRecordCardState();
}

class _HistoryRecordCardState extends State<_HistoryRecordCard> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  PlayerState _playerState = PlayerState.stopped;

  bool _isPreparingAudio = false;

  String? _audioError;

  String? _localAudioPath;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _playerState = state;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _playerState = PlayerState.stopped;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();

    final localPath = _localAudioPath;

    if (localPath != null) {
      File(localPath).delete().catchError((_) => File(localPath));
    }

    super.dispose();
  }

  Future<void> _toggleAudio(String audioUrl) async {
    if (audioUrl.isEmpty) {
      setState(() {
        _audioError = 'Audio tidak tersedia.';
      });
      return;
    }

    try {
      setState(() {
        _isPreparingAudio = true;
        _audioError = null;
      });

      if (_playerState == PlayerState.playing) {
        await _audioPlayer.pause();
      } else if (_playerState == PlayerState.paused) {
        await _audioPlayer.resume();
      } else {
        await _audioPlayer.stop();

        /*
         * Jangan memutar WAV HTTP secara langsung menggunakan
         * UrlSource pada Android.
         *
         * Audio terlebih dahulu di-download ke temporary file,
         * kemudian diputar menggunakan DeviceFileSource.
         */
        _localAudioPath ??= await ApiService.downloadAudioToTempFile(audioUrl);

        if (_localAudioPath == null) {
          throw Exception('Audio gagal diunduh dari server.');
        }

        await _audioPlayer.play(DeviceFileSource(_localAudioPath!));
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _audioError = 'Gagal memutar audio.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPreparingAudio = false;
        });
      }
    }
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();

    if (mounted) {
      setState(() {
        _playerState = PlayerState.stopped;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final record = widget.record;

    final screening = record['screening'] as Map<String, dynamic>?;

    final status = ((screening?['status'] as String?) ?? 'uploaded')
        .toLowerCase();

    final rawRiskLevel = screening?['risk_analysis'];

    final riskLevel = rawRiskLevel is num ? rawRiskLevel.toDouble() : null;

    final isLowRisk = riskLevel != null && riskLevel > 80;

    final rawHeartStatus =
        (screening?['heart_status'] ??
                screening?['nama_penyakit'] ??
                'Belum tersedia')
            .toString();

    final heartStatus = status == 'retry'
        ? 'Rekaman tidak jelas'
        : rawHeartStatus;

    final audioUrl = ApiService.resolveUrl(record['audio_url'] as String?);

    final hasAudio = audioUrl.isNotEmpty;

    String formattedDate = '';

    final dt = ApiService.parseServerDateTime(record['created_at']);

    if (dt != null) {
      formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(dt);
    }

    final riskColor = status == 'completed'
        ? AppTheme.primaryTeal
        : status == 'retry'
        ? Colors.orangeAccent
        : status == 'failed'
        ? Colors.redAccent
        : AppTheme.statusWarning;

    final riskText = _statusLabel(status, riskLevel, isLowRisk);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  formattedDate,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: riskColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  riskText,
                  style: TextStyle(
                    color: status == 'completed'
                        ? AppTheme.primaryDarkTeal
                        : (status == 'failed'
                              ? Colors.redAccent
                              : Colors.orange.shade900),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Pemeriksaan Vitalitas',
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              if (hasAudio)
                IconButton(
                  tooltip: _playerState == PlayerState.playing
                      ? 'Jeda'
                      : 'Putar',
                  onPressed: _isPreparingAudio
                      ? null
                      : () => _toggleAudio(audioUrl),
                  icon: _isPreparingAudio
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          _playerState == PlayerState.playing
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_fill_rounded,
                          color: AppTheme.primaryTeal,
                          size: 32,
                        ),
                ),

              if (_playerState == PlayerState.playing ||
                  _playerState == PlayerState.paused)
                IconButton(
                  tooltip: 'Stop',
                  onPressed: _stopAudio,
                  icon: const Icon(
                    Icons.stop_circle_rounded,
                    color: AppTheme.textMuted,
                    size: 28,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _MetricMini(
                  icon: Icons.favorite_border_rounded,
                  label: 'Jantung',
                  value: heartStatus,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _MetricMini(
                  icon: Icons.air_rounded,
                  label: 'Status',
                  value: _secondaryStatus(status, riskLevel, isLowRisk),
                ),
              ),
            ],
          ),

          if (_audioError != null) ...[
            const SizedBox(height: 8),
            Text(
              _audioError!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  String _statusLabel(String status, double? riskLevel, bool isLowRisk) {
    return switch (status) {
      'completed' =>
        riskLevel == null
            ? 'Selesai'
            : (isLowRisk ? 'Risiko Rendah' : 'Perlu Perhatian'),

      'processing' => 'Sedang Dianalisis',

      'retry' => 'Rekam Ulang',

      'failed' => 'Analisis Gagal',

      _ => 'Menunggu Analisis',
    };
  }

  String _secondaryStatus(String status, double? riskLevel, bool isLowRisk) {
    return switch (status) {
      'completed' =>
        riskLevel == null
            ? 'Selesai'
            : (isLowRisk ? 'Optimal' : 'Perlu Perhatian'),

      'processing' => 'Sedang Dianalisis',

      'retry' => 'Rekam Ulang',

      'failed' => 'Gagal',

      _ => 'Diunggah',
    };
  }
}

class _MetricMini extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetricMini({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.bgMint,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryDarkTeal, size: 16),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.primaryDarkTeal,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
