import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';
import 'package:waffir/core/widgets/inputs/city_selector.dart';
import 'package:waffir/core/mock/mock_user_data.dart';

/// Change City Screen
///
/// Allows users to change their selected city. Uses the existing CitySelector widget.
class ChangeCityScreen extends ConsumerStatefulWidget {
  const ChangeCityScreen({super.key});

  @override
  ConsumerState<ChangeCityScreen> createState() => _ChangeCityScreenState();
}

class _ChangeCityScreenState extends ConsumerState<ChangeCityScreen> {
  late CityData? _selectedCity;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Find the city from the mock user
    final userCity = currentMockUser.city;
    _selectedCity = kSaudiCities.firstWhere(
      (city) => city.nameEn == userCity || city.nameAr == userCity,
      orElse: () => kSaudiCities[0], // Default to Riyadh
    );
  }

  Future<void> _saveCity() async {
    if (_selectedCity == null) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('City changed to ${_selectedCity!.displayName}'),
          duration: const Duration(seconds: 2),
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background shape
          Positioned(
            top: -85,
            left: -40,
            child: Container(
              width: 468,
              height: 395,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(200),
              ),
            ),
          ),

          // Main content
          Column(
            children: [
              // App bar
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: colorScheme.onSurface,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.surface,
                          elevation: 2,
                          shadowColor: Colors.black.withValues(alpha: 0.1),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Change City',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // City selector
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Select your city to see relevant deals and offers in your area',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 24),
                      CitySelector(
                        cities: kSaudiCities,
                        selectedCity: _selectedCity,
                        onCitySelected: (city) {
                          setState(() {
                            _selectedCity = city;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Save button with gradient fade
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorScheme.surface.withValues(alpha: 0),
                      colorScheme.surface,
                    ],
                    stops: const [0.0, 0.5],
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: AppButton.primary(
                      onPressed: _isLoading ? null : _saveCity,
                      isLoading: _isLoading,
                      child: const Text('Save'),
                    ),
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
