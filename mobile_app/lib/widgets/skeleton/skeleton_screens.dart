import 'package:flutter/material.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/widgets/skeleton/skeleton_box.dart';

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppTheme.primaryTeal,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(
                  width: 220,
                  height: 26,
                  borderRadius: 6,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
                const SizedBox(height: 16),
                SkeletonBox(
                  width: 150,
                  height: 44,
                  borderRadius: 22,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SkeletonBox(width: 190, height: 24, borderRadius: 6),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildHealthTileSkeleton()),
              const SizedBox(width: 12),
              Expanded(child: _buildHealthTileSkeleton()),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SkeletonBox(width: 145, height: 24, borderRadius: 6),
              SkeletonBox(
                width: 80,
                height: 20,
                borderRadius: 6,
                color: Colors.grey.shade100,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildArticleCardSkeleton(),
          const SizedBox(height: 14),
          _buildArticleCardSkeleton(),
          const SizedBox(height: 14),
          _buildArticleCardSkeleton(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHealthTileSkeleton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 42, height: 42, borderRadius: 14),
          const SizedBox(height: 12),
          SkeletonBox(
            width: 90,
            height: 12,
            borderRadius: 4,
            color: Colors.grey.shade100,
          ),
          const SizedBox(height: 2),
          SkeletonBox(
            width: 120,
            height: 16,
            borderRadius: 4,
            color: Colors.grey.shade100,
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCardSkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(
            width: double.infinity,
            height: 170,
            borderRadius: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(
                  width: 70,
                  height: 10,
                  borderRadius: 4,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(height: 8),
                SkeletonBox(
                  width: double.infinity,
                  height: 16,
                  borderRadius: 4,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(height: 6),
                SkeletonBox(
                  width: double.infinity,
                  height: 12,
                  borderRadius: 4,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(height: 4),
                SkeletonBox(
                  width: 200,
                  height: 12,
                  borderRadius: 4,
                  color: Colors.grey.shade100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HistorySkeleton extends StatelessWidget {
  const HistorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(
            width: double.infinity,
            height: 48,
            borderRadius: 20,
          ),
          const SizedBox(height: 16),
          ...List.generate(
            3,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildRecordCardSkeleton(),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildRecordCardSkeleton() {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SkeletonBox(
                width: 130,
                height: 12,
                borderRadius: 4,
              ),
              SkeletonBox(
                width: 120,
                height: 28,
                borderRadius: 14,
                color: Colors.grey.shade100,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(
                child: SkeletonBox(
                  width: double.infinity,
                  height: 24,
                  borderRadius: 5,
                ),
              ),
              const SizedBox(width: 14),
              SkeletonBox(
                width: 32,
                height: 32,
                borderRadius: 16,
                color: Colors.grey.shade100,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.bgMint,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const SkeletonBox(width: 16, height: 16, borderRadius: 4),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonBox(
                            width: 35,
                            height: 10,
                            borderRadius: 4,
                            color: Colors.grey.shade200,
                          ),
                          const SizedBox(height: 4),
                          SkeletonBox(
                            width: 55,
                            height: 12,
                            borderRadius: 4,
                            color: Colors.grey.shade200,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.bgMint,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const SkeletonBox(width: 16, height: 16, borderRadius: 4),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonBox(
                            width: 30,
                            height: 10,
                            borderRadius: 4,
                            color: Colors.grey.shade200,
                          ),
                          const SizedBox(height: 4),
                          SkeletonBox(
                            width: 50,
                            height: 12,
                            borderRadius: 4,
                            color: Colors.grey.shade200,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryTeal,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              children: [
                SkeletonBox(
                  width: 92,
                  height: 92,
                  borderRadius: 46,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
                const SizedBox(height: 14),
                SkeletonBox(
                  width: 160,
                  height: 22,
                  borderRadius: 6,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(child: _buildBadgeSkeleton()),
                    const SizedBox(width: 12),
                    Expanded(child: _buildBadgeSkeleton()),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SkeletonBox(width: 130, height: 12, borderRadius: 4),
          const SizedBox(height: 10),
          _buildMenuSectionSkeleton(itemCount: 3),
          const SizedBox(height: 24),
          const SkeletonBox(width: 150, height: 12, borderRadius: 4),
          const SizedBox(height: 10),
          _buildMenuSectionSkeleton(itemCount: 2),
          const SizedBox(height: 24),
          const SkeletonBox(width: 70, height: 12, borderRadius: 4),
          const SizedBox(height: 10),
          _buildMenuSectionSkeleton(itemCount: 2),
          const SizedBox(height: 28),
          Center(
            child: SkeletonBox(
              width: 150,
              height: 12,
              borderRadius: 4,
              color: Colors.grey.shade100,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBadgeSkeleton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SkeletonBox(
            width: 80,
            height: 10,
            borderRadius: 4,
            color: Colors.grey.shade200,
          ),
          const SizedBox(height: 6),
          SkeletonBox(
            width: 40,
            height: 20,
            borderRadius: 4,
            color: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSectionSkeleton({required int itemCount}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: List.generate(itemCount, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                const SkeletonBox(width: 42, height: 42, borderRadius: 14),
                const SizedBox(width: 14),
                Expanded(
                  child: SkeletonBox(
                    width: double.infinity,
                    height: 14,
                    borderRadius: 4,
                    color: Colors.grey.shade100,
                  ),
                ),
                SkeletonBox(
                  width: 20,
                  height: 20,
                  borderRadius: 4,
                  color: Colors.grey.shade100,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class AdviceSkeleton extends StatelessWidget {
  const AdviceSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 180, height: 28, borderRadius: 6),
          const SizedBox(height: 16),
          ...List.generate(
            4,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildNewsCardSkeleton(),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildNewsCardSkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AspectRatio(
            aspectRatio: 16 / 8.5,
            child: SkeletonBox(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(
                  width: 80,
                  height: 13,
                  borderRadius: 4,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(height: 6),
                SkeletonBox(
                  width: double.infinity,
                  height: 20,
                  borderRadius: 4,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(height: 6),
                SkeletonBox(
                  width: 250,
                  height: 20,
                  borderRadius: 4,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(height: 8),
                SkeletonBox(
                  width: double.infinity,
                  height: 13,
                  borderRadius: 4,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(height: 5),
                SkeletonBox(
                  width: double.infinity,
                  height: 13,
                  borderRadius: 4,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SkeletonBox(
                        width: double.infinity,
                        height: 12,
                        borderRadius: 4,
                        color: Colors.grey.shade100,
                      ),
                    ),
                    const SizedBox(width: 24),
                    SkeletonBox(
                      width: 70,
                      height: 12,
                      borderRadius: 4,
                      color: Colors.grey.shade100,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationsSkeleton extends StatelessWidget {
  const NotificationsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 50, height: 12, borderRadius: 4),
          const SizedBox(height: 10),
          _buildNotificationTileSkeleton(isLong: true),
          const SizedBox(height: 10),
          _buildNotificationTileSkeleton(isLong: true),
          const SizedBox(height: 24),
          const SkeletonBox(width: 120, height: 12, borderRadius: 4),
          const SizedBox(height: 10),
          ...List.generate(
            4,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildNotificationTileSkeleton(),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNotificationTileSkeleton({bool isLong = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 42, height: 42, borderRadius: 14),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SkeletonBox(
                      width: isLong ? 180 : 140,
                      height: 14,
                      borderRadius: 4,
                      color: Colors.grey.shade100,
                    ),
                    SkeletonBox(
                      width: 45,
                      height: 10,
                      borderRadius: 4,
                      color: Colors.grey.shade100,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SkeletonBox(
                  width: double.infinity,
                  height: 10,
                  borderRadius: 4,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(height: 4),
                SkeletonBox(
                  width: isLong ? double.infinity : 220,
                  height: 10,
                  borderRadius: 4,
                  color: Colors.grey.shade100,
                ),
                if (isLong) ...[
                  const SizedBox(height: 4),
                  SkeletonBox(
                    width: 180,
                    height: 10,
                    borderRadius: 4,
                    color: Colors.grey.shade100,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BeforeRecordingSkeleton extends StatelessWidget {
  const BeforeRecordingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 200, height: 28, borderRadius: 6),
          const SizedBox(height: 8),
          SkeletonBox(
            width: 280,
            height: 14,
            borderRadius: 4,
            color: Colors.grey.shade100,
          ),
          const SizedBox(height: 4),
          SkeletonBox(
            width: 220,
            height: 14,
            borderRadius: 4,
            color: Colors.grey.shade100,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(child: _buildPlacementSkeleton()),
                const SizedBox(width: 14),
                Expanded(child: _buildPlacementSkeleton()),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(
            4,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildStepTileSkeleton(),
            ),
          ),
          const SizedBox(height: 14),
          const SkeletonBox(
            width: double.infinity,
            height: 56,
            borderRadius: 28,
          ),
          const SizedBox(height: 12),
          Center(
            child: SkeletonBox(
              width: 250,
              height: 12,
              borderRadius: 4,
              color: Colors.grey.shade100,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPlacementSkeleton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppTheme.bgMint,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const SkeletonBox(width: 56, height: 56, borderRadius: 28),
          const SizedBox(height: 12),
          SkeletonBox(
            width: 90,
            height: 12,
            borderRadius: 4,
            color: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }

  Widget _buildStepTileSkeleton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const SkeletonBox(width: 46, height: 46, borderRadius: 14),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(
                  width: 140,
                  height: 14,
                  borderRadius: 4,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(height: 4),
                SkeletonBox(
                  width: 200,
                  height: 10,
                  borderRadius: 4,
                  color: Colors.grey.shade100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecordAudioSkeleton extends StatelessWidget {
  const RecordAudioSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        children: [
          const SizedBox(height: 8),
          SkeletonBox(
            width: 280,
            height: 22,
            borderRadius: 6,
            color: Colors.grey.shade100,
          ),
          const SizedBox(height: 8),
          SkeletonBox(
            width: 220,
            height: 14,
            borderRadius: 4,
            color: Colors.grey.shade100,
          ),
          const SizedBox(height: 20),
          const SkeletonBox(width: 100, height: 36, borderRadius: 20),
          const SizedBox(height: 24),
          const SkeletonBox(width: 150, height: 150, borderRadius: 75),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(
              15,
              (i) => SkeletonBox(
                width: 3.5,
                height: 15.0 + (i % 5) * 8,
                borderRadius: 2,
                color: Colors.grey.shade200,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const SkeletonBox(
            width: double.infinity,
            height: 54,
            borderRadius: 27,
          ),
          const SizedBox(height: 10),
          SkeletonBox(
            width: 60,
            height: 14,
            borderRadius: 4,
            color: Colors.grey.shade100,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class ScreeningResultSkeleton extends StatelessWidget {
  const ScreeningResultSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          const SkeletonBox(width: 170, height: 170, borderRadius: 85),
          const SizedBox(height: 20),
          const SkeletonBox(width: 180, height: 24, borderRadius: 6),
          const SizedBox(height: 8),
          SkeletonBox(
            width: 300,
            height: 14,
            borderRadius: 4,
            color: Colors.grey.shade100,
          ),
          const SizedBox(height: 4),
          SkeletonBox(
            width: 260,
            height: 14,
            borderRadius: 4,
            color: Colors.grey.shade100,
          ),
          const SizedBox(height: 24),
          _buildInfoCardSkeleton(),
          const SizedBox(height: 12),
          _buildMetricCardSkeleton(),
          const SizedBox(height: 12),
          _buildMetricCardSkeleton(),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonBox(width: 200, height: 16, borderRadius: 6),
                const SizedBox(height: 14),
                _buildRecommendationSkeleton(),
                const SizedBox(height: 12),
                _buildRecommendationSkeleton(),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SkeletonBox(
            width: double.infinity,
            height: 54,
            borderRadius: 27,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SkeletonBox(
                  width: double.infinity,
                  height: 48,
                  borderRadius: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SkeletonBox(
                  width: double.infinity,
                  height: 48,
                  borderRadius: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const SkeletonBox(width: 42, height: 42, borderRadius: 14),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(
                  width: 90,
                  height: 12,
                  borderRadius: 4,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(height: 6),
                SkeletonBox(
                  width: 140,
                  height: 14,
                  borderRadius: 4,
                  color: Colors.grey.shade100,
                ),
              ],
            ),
          ),
          SkeletonBox(
            width: 80,
            height: 24,
            borderRadius: 14,
            color: Colors.grey.shade100,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(
            width: 120,
            height: 14,
            borderRadius: 4,
            color: Colors.grey.shade100,
          ),
          const SizedBox(height: 10),
          SkeletonBox(
            width: 100,
            height: 20,
            borderRadius: 4,
            color: Colors.grey.shade100,
          ),
          const SizedBox(height: 10),
          SkeletonBox(
            width: double.infinity,
            height: 6,
            borderRadius: 4,
            color: Colors.grey.shade100,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationSkeleton() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.bgMint,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 20, height: 20, borderRadius: 10),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(
                  width: 180,
                  height: 14,
                  borderRadius: 4,
                  color: Colors.grey.shade200,
                ),
                const SizedBox(height: 4),
                SkeletonBox(
                  width: double.infinity,
                  height: 10,
                  borderRadius: 4,
                  color: Colors.grey.shade200,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AboutSvaraSkeleton extends StatelessWidget {
  const AboutSvaraSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 220, height: 28, borderRadius: 6),
          const SizedBox(height: 8),
          SkeletonBox(
            width: 280,
            height: 14,
            borderRadius: 4,
            color: Colors.grey.shade100,
          ),
          const SizedBox(height: 4),
          SkeletonBox(
            width: 240,
            height: 14,
            borderRadius: 4,
            color: Colors.grey.shade100,
          ),
          const SizedBox(height: 24),
          _buildInfoCardSkeleton(),
          const SizedBox(height: 16),
          _buildInfoCardSkeleton(),
          const SizedBox(height: 28),
          const SkeletonBox(width: 160, height: 20, borderRadius: 6),
          const SizedBox(height: 16),
          ...List.generate(
            3,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildStepCardSkeleton(),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 42, height: 42, borderRadius: 14),
          const SizedBox(height: 12),
          SkeletonBox(
            width: 120,
            height: 18,
            borderRadius: 4,
            color: Colors.grey.shade100,
          ),
          const SizedBox(height: 8),
          SkeletonBox(
            width: double.infinity,
            height: 12,
            borderRadius: 4,
            color: Colors.grey.shade100,
          ),
          const SizedBox(height: 4),
          SkeletonBox(
            width: double.infinity,
            height: 12,
            borderRadius: 4,
            color: Colors.grey.shade100,
          ),
          const SizedBox(height: 4),
          SkeletonBox(
            width: 200,
            height: 12,
            borderRadius: 4,
            color: Colors.grey.shade100,
          ),
        ],
      ),
    );
  }

  Widget _buildStepCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 36, height: 36, borderRadius: 10),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(
                  width: 100,
                  height: 14,
                  borderRadius: 4,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(height: 6),
                SkeletonBox(
                  width: double.infinity,
                  height: 10,
                  borderRadius: 4,
                  color: Colors.grey.shade100,
                ),
                const SizedBox(height: 4),
                SkeletonBox(
                  width: 220,
                  height: 10,
                  borderRadius: 4,
                  color: Colors.grey.shade100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
