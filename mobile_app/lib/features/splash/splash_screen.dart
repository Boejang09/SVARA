import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  final String nextRoute;
  final bool enableVideo;

  const SplashScreen({
    super.key,
    required this.nextRoute,
    this.enableVideo = true,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? _videoController;
  Timer? _fallbackTimer;

  bool _isInitialized = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    if (widget.enableVideo) {
      _enterFullscreen();
      _initializeVideo();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _goToNextRoute();
      });
    }
  }

  Future<void> _initializeVideo() async {
    try {
      final controller = VideoPlayerController.asset(
        'assets/videos/svara_splash.mp4',
      );

      _videoController = controller;

      await controller.initialize();
      await controller.setLooping(false);

      if (!mounted) {
        controller.dispose();
        return;
      }

      final duration = controller.value.duration;

      debugPrint('========================================');
      debugPrint('SVARA SPLASH');
      debugPrint('Duration : $duration');
      debugPrint('Size     : ${controller.value.size}');
      debugPrint('Looping  : ${controller.value.isLooping}');
      debugPrint('========================================');

      setState(() {
        _isInitialized = true;
      });

      controller.addListener(_handleVideoUpdate);

      await controller.play();

      debugPrint('SVARA SPLASH: VIDEO PLAY');

      _startFallbackTimer(duration);
    } catch (e) {
      debugPrint('========================================');
      debugPrint('SVARA SPLASH ERROR');
      debugPrint('$e');
      debugPrint('========================================');

      _goToNextRoute();
    }
  }

  void _handleVideoUpdate() {
    final controller = _videoController;

    if (controller == null ||
        _hasNavigated ||
        !controller.value.isInitialized) {
      return;
    }

    final value = controller.value;
    final hasFinished =
        value.duration > Duration.zero &&
        value.position >= value.duration &&
        !value.isPlaying;

    if (hasFinished) {
      debugPrint('SVARA SPLASH: VIDEO FINISHED');
      _goToNextRoute();
    }
  }

  void _startFallbackTimer(Duration duration) {
    if (duration <= Duration.zero) {
      return;
    }

    _fallbackTimer?.cancel();
    _fallbackTimer = Timer(duration + const Duration(milliseconds: 300), () {
      if (!mounted || _hasNavigated) {
        return;
      }

      debugPrint('SVARA SPLASH: FALLBACK FINISH');
      _goToNextRoute();
    });
  }

  void _goToNextRoute() {
    if (!mounted || _hasNavigated) {
      return;
    }

    _hasNavigated = true;
    _fallbackTimer?.cancel();
    _fallbackTimer = null;

    final controller = _videoController;
    controller?.removeListener(_handleVideoUpdate);
    controller?.pause();

    debugPrint('========================================');
    debugPrint('SVARA SPLASH: NAVIGATE');
    debugPrint('NEXT ROUTE: ${widget.nextRoute}');
    debugPrint('========================================');

    _restoreSystemUI();

    Navigator.of(context).pushReplacementNamed(widget.nextRoute);
  }

  // ================================================================
  // FULLSCREEN
  // ================================================================

  void _enterFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _restoreSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  // ================================================================
  // DISPOSE
  // ================================================================

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    _fallbackTimer = null;

    final controller = _videoController;

    if (controller != null) {
      controller.removeListener(_handleVideoUpdate);
      controller.pause();
      controller.dispose();
    }

    _restoreSystemUI();

    super.dispose();
  }

  // ================================================================
  // UI
  // ================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: widget.enableVideo
            ? _buildVideoSplash()
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildVideoSplash() {
    final controller = _videoController;

    if (!_isInitialized || controller == null) {
      return const Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: ClipRect(
            child: FittedBox(
              fit: BoxFit.cover,
              alignment: Alignment.center,
              child: SizedBox.fromSize(
                size: controller.value.size,
                child: VideoPlayer(controller),
              ),
            ),
          ),
        );
      },
    );
  }
}
