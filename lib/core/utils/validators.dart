import 'package:waffir/core/constants/app_constants.dart';

/// Utility class for common validation functions
class Validators {
  Validators._();

  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Check for consecutive dots which are not allowed
    if (value.contains('..')) {
      return 'Please enter a valid email address';
    }

    if (!RegExp(AppConstants.emailRegex).hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Required field validation
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password must be less than ${AppConstants.maxPasswordLength} characters';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  // Confirm password validation
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// International phone number validation with country code
  static String? internationalPhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove any spaces, hyphens, or parentheses
    final cleanedNumber = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Check if it starts with + and country code
    if (!cleanedNumber.startsWith('+')) {
      return 'Phone number must include country code (e.g., +966)';
    }

    // Check minimum and maximum length (including country code)
    if (cleanedNumber.length < 10) {
      return 'Phone number is too short';
    }

    if (cleanedNumber.length > 16) {
      return 'Phone number is too long';
    }

    // Validate format: + followed by digits only
    if (!RegExp(r'^\+\d{9,15}$').hasMatch(cleanedNumber)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Phone number validation without country code
  static String? phoneNumberOnly(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove any spaces, hyphens, or parentheses
    final cleanedNumber = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Check if it contains only digits
    if (!RegExp(r'^\d+$').hasMatch(cleanedNumber)) {
      return 'Phone number can only contain digits';
    }

    // Check minimum length
    if (cleanedNumber.length < 9) {
      return 'Phone number is too short';
    }

    // Check maximum length
    if (cleanedNumber.length > 15) {
      return 'Phone number is too long';
    }

    return null;
  }

  /// Check if phone number length is valid for international format
  static bool isValidPhoneLength(String phoneNumber) {
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)+]'), '');
    return cleanedNumber.length >= 9 && cleanedNumber.length <= 15;
  }

  /// Check if string contains only digits
  static bool isDigitsOnly(String value) {
    return RegExp(r'^\d+$').hasMatch(value);
  }

  // Phone number validation
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove any spaces, hyphens, or parentheses
    final cleanedNumber = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (!RegExp(AppConstants.phoneRegex).hasMatch(cleanedNumber)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // Username validation
  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    if (value.length < AppConstants.minUsernameLength) {
      return 'Username must be at least ${AppConstants.minUsernameLength} characters';
    }

    if (value.length > AppConstants.maxUsernameLength) {
      return 'Username must be less than ${AppConstants.maxUsernameLength} characters';
    }

    if (!RegExp(AppConstants.usernameRegex).hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null;
  }

  // Name validation
  static String? name(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Name'} is required';
    }

    if (value.trim().length < 2) {
      return '${fieldName ?? 'Name'} must be at least 2 characters';
    }

    if (value.trim().length > 50) {
      return '${fieldName ?? 'Name'} must be less than 50 characters';
    }

    if (!RegExp(r"^[\p{L}\s\-'\.]+$", unicode: true).hasMatch(value)) {
      return '${fieldName ?? 'Name'} can only contain letters, spaces, hyphens, apostrophes, and periods';
    }

    return null;
  }

  // Numeric validation
  static String? numeric(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }

    return null;
  }

  // Integer validation
  static String? integer(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (int.tryParse(value) == null) {
      return 'Please enter a valid whole number';
    }

    return null;
  }

  // Minimum length validation
  static String? minLength(String? value, int minLength, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }

    return null;
  }

  // Maximum length validation
  static String? maxLength(String? value, int maxLength, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return null; // Allow empty for max length validation
    }

    if (value.length > maxLength) {
      return '${fieldName ?? 'This field'} must be less than $maxLength characters';
    }

    return null;
  }

  // Range validation for numbers
  static String? numberRange(String? value, double min, double max, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (number < min || number > max) {
      return '${fieldName ?? 'This field'} must be between $min and $max';
    }

    return null;
  }

  // URL validation
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }

    const pattern =
        r'^https?:\/\/(?:[-\w.])+(?:\.[a-zA-Z]{2,})+(?::\d+)?(?:\/[^?\s]*)?(?:\?[^#\s]*)?(?:#[^\s]*)?$';
    if (!RegExp(pattern).hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  // Age validation
  static String? age(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }

    final ageValue = int.tryParse(value);
    if (ageValue == null) {
      return 'Please enter a valid age';
    }

    if (ageValue < 13) {
      return 'You must be at least 13 years old';
    }

    if (ageValue > 120) {
      return 'Please enter a valid age';
    }

    return null;
  }

  // Credit card validation (basic Luhn algorithm)
  static String? creditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credit card number is required';
    }

    // Remove spaces and hyphens
    final cleanedNumber = value.replaceAll(RegExp(r'[\s\-]'), '');

    if (cleanedNumber.length < 13 || cleanedNumber.length > 19) {
      return 'Credit card number must be between 13 and 19 digits';
    }

    if (!RegExp(r'^\d+$').hasMatch(cleanedNumber)) {
      return 'Credit card number can only contain digits';
    }

    // Luhn algorithm validation
    if (!_isValidLuhn(cleanedNumber)) {
      return 'Please enter a valid credit card number';
    }

    return null;
  }

  // CVV validation
  static String? cvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }

    if (!RegExp(r'^\d{3,4}$').hasMatch(value)) {
      return 'CVV must be 3 or 4 digits';
    }

    return null;
  }

  // Date validation (YYYY-MM-DD format)
  static String? date(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }

    try {
      final date = DateTime.parse(value);

      // Additional validation to ensure the parsed date matches the input
      // This catches cases like '2023-13-01' which DateTime.parse might interpret differently
      final parts = value.split('-');
      if (parts.length == 3) {
        final year = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final day = int.tryParse(parts[2]);

        if (year == null ||
            month == null ||
            day == null ||
            month < 1 ||
            month > 12 ||
            day < 1 ||
            day > 31 ||
            date.year != year ||
            date.month != month ||
            date.day != day) {
          return 'Please enter a valid date (YYYY-MM-DD)';
        }
      }

      return null;
    } catch (e) {
      return 'Please enter a valid date (YYYY-MM-DD)';
    }
  }

  // Future date validation
  static String? futureDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }

    try {
      final date = DateTime.parse(value);

      // Apply same strict validation as date() method
      final parts = value.split('-');
      if (parts.length == 3) {
        final year = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final day = int.tryParse(parts[2]);

        if (year == null ||
            month == null ||
            day == null ||
            month < 1 ||
            month > 12 ||
            day < 1 ||
            day > 31 ||
            date.year != year ||
            date.month != month ||
            date.day != day) {
          return 'Please enter a valid date (YYYY-MM-DD)';
        }
      }

      if (date.isBefore(DateTime.now())) {
        return 'Date must be in the future';
      }
      return null;
    } catch (e) {
      return 'Please enter a valid date (YYYY-MM-DD)';
    }
  }

  // Past date validation
  static String? pastDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }

    try {
      final date = DateTime.parse(value);

      // Apply same strict validation as date() method
      final parts = value.split('-');
      if (parts.length == 3) {
        final year = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final day = int.tryParse(parts[2]);

        if (year == null ||
            month == null ||
            day == null ||
            month < 1 ||
            month > 12 ||
            day < 1 ||
            day > 31 ||
            date.year != year ||
            date.month != month ||
            date.day != day) {
          return 'Please enter a valid date (YYYY-MM-DD)';
        }
      }

      if (date.isAfter(DateTime.now())) {
        return 'Date must be in the past';
      }
      return null;
    } catch (e) {
      return 'Please enter a valid date (YYYY-MM-DD)';
    }
  }

  // Combine multiple validators
  static String? Function(String?) combine(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }

  // Custom validator builder
  static String? Function(String?) custom({
    required bool Function(String?) condition,
    required String errorMessage,
  }) {
    return (String? value) {
      if (!condition(value)) {
        return errorMessage;
      }
      return null;
    };
  }

  // Helper method for Luhn algorithm
  static bool _isValidLuhn(String cardNumber) {
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  // Password strength calculator
  static int getPasswordStrength(String password) {
    int score = 0;

    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Character variety checks
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    // Bonus for very long passwords
    if (password.length >= 16) score++;

    return score.clamp(0, 5);
  }

  // Password strength description
  static String getPasswordStrengthText(String password) {
    final strength = getPasswordStrength(password);

    switch (strength) {
      case 0:
      case 1:
        return 'Very Weak';
      case 2:
        return 'Weak';
      case 3:
        return 'Fair';
      case 4:
        return 'Strong';
      case 5:
        return 'Very Strong';
      default:
        return 'Unknown';
    }
  }
}
