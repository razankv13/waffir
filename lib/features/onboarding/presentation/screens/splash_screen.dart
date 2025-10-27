import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/storage/settings_service.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/gen/assets.gen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateAfterDelay();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    if (mounted) {
      final settingsService = ref.read(settingsServiceProvider);
      final selectedCity = settingsService.getPreference<String>('selected_city');

      if (selectedCity != null) {
        // City is selected, navigate to login
        context.go(AppRoutes.login);
      } else {
        // No city selected, navigate to city selection
        context.go(AppRoutes.citySelection);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use fixed brand colors from app_colors.dart for consistent splash screen
    final splashColors = AppColors.darkColorScheme;

    return Scaffold(
      backgroundColor: splashColors.surface, // Always #121535 (blue wafir)
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                _buildLogo(),
                const SizedBox(height: 24),
                _buildAppName(),
                const Spacer(),
                _buildLoadingIndicator(),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Hero(
      tag: 'app_logo',
      child: Image.asset(
        Assets.icons.appIconNoBg.path,
        width: 200,
        height: 200,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildAppName() {
    // Use fixed brand color from app_colors.dart
    final splashColors = AppColors.darkColorScheme;

    return Hero(
      tag: 'app_name',
      child: Material(
        color: Colors.transparent,
        child: Text(
          'وفــــــر',
          style: TextStyle(
            fontFamily: 'Parkinsans',
            fontSize: 59.4,
            fontWeight: FontWeight.w900, // ExtraBold
            color: splashColors.primary, // Always #00FF88 (green wafir)
            height: 0.6, // Leading 36px for 59.4px font
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    // Use fixed brand color from app_colors.dart
    final splashColors = AppColors.darkColorScheme;

    return SizedBox(
      width: 32,
      height: 32,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(
          splashColors.primary, // Always #00FF88 (green wafir)
        ),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .fadeIn(duration: 600.ms);
  }
}