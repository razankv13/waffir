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
    return Scaffold(
      // Figma design: Dark green background #0F352D (Waffir-Green-04)
      backgroundColor: AppColors.primaryColorDarkest,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                const SizedBox(height: 40), // Figma gap: 40px
                _buildAppName(),
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
        width: 220, // Figma: 220px
        height: 217, // Figma: 217px
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildAppName() {
    return Hero(
      tag: 'app_name',
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Arabic text "وفـــــــر"
            Text(
              'وفـــــــر', // 7 dashes as per Figma
              style: TextStyle(
                fontFamily: 'Parkinsans',
                fontSize: 52, // Proportional to Figma design
                fontWeight: FontWeight.w900, // ExtraBold
                color: AppColors.primaryColor, // #00FF88 (green wafir)
                height: 1.0,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 8),
            // English text "waffir"
            Text(
              'waffir',
              style: TextStyle(
                fontFamily: 'Parkinsans',
                fontSize: 40, // Based on Figma proportions (93px total height)
                fontWeight: FontWeight.w700, // Bold
                color: AppColors.primaryColor, // #00FF88 (green wafir)
                height: 1.0,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
