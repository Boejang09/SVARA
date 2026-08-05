import 'package:flutter/material.dart';
import 'package:svara_app/widgets/skeleton/skeleton.dart';

/// Delays data loading until [shouldLoadNow] is true.
/// Use on tab screens with `shouldLoadNow => widget.isActive`.
mixin ScreenLoadMixin<T extends StatefulWidget> on State<T> {
  bool isLoading = true;
  bool _loadStarted = false;

  bool get shouldLoadNow => true;

  @override
  void initState() {
    super.initState();
    _tryLoad();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    _tryLoad();
  }

  void _tryLoad() {
    if (shouldLoadNow && !_loadStarted) {
      _loadStarted = true;
      _performLoad();
    }
  }

  Future<void> _performLoad() async {
    await onLoad();
    if (mounted) setState(() => isLoading = false);
  }

  Future<void> onLoad() => simulateLoading();
}
