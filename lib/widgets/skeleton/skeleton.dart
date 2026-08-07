export 'screen_load_mixin.dart';
export 'skeleton_box.dart';
export 'skeleton_screens.dart';
export 'skeleton_shimmer.dart';

/// Simulates an async data fetch. Replace with real API calls when ready.
Future<void> simulateLoading({
  Duration duration = const Duration(milliseconds: 1500),
}) {
  return Future.delayed(duration);
}
