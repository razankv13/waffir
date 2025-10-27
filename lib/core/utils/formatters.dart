import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Utility class for common formatting functions
class Formatters {
  Formatters._();

  // Phone number formatters
  static TextInputFormatter get phoneFormatter {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
      
      if (text.length <= 3) {
        return TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      } else if (text.length <= 6) {
        return TextEditingValue(
          text: '(${text.substring(0, 3)}) ${text.substring(3)}',
          selection: TextSelection.collapsed(offset: text.length + 5),
        );
      } else if (text.length <= 10) {
        return TextEditingValue(
          text: '(${text.substring(0, 3)}) ${text.substring(3, 6)}-${text.substring(6)}',
          selection: TextSelection.collapsed(offset: text.length + 6),
        );
      } else {
        return oldValue;
      }
    });
  }

  // Credit card formatters
  static TextInputFormatter get creditCardFormatter {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
      
      if (text.length <= 16) {
        String formatted = '';
        for (int i = 0; i < text.length; i += 4) {
          if (i + 4 < text.length) {
            formatted += '${text.substring(i, i + 4)} ';
          } else {
            formatted += text.substring(i);
          }
        }
        
        return TextEditingValue(
          text: formatted.trim(),
          selection: TextSelection.collapsed(offset: formatted.trim().length),
        );
      } else {
        return oldValue;
      }
    });
  }

  // CVV formatter
  static TextInputFormatter get cvvFormatter {
    return LengthLimitingTextInputFormatter(4);
  }

  // Expiry date formatter (MM/YY)
  static TextInputFormatter get expiryDateFormatter {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
      
      if (text.length <= 2) {
        return TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      } else if (text.length <= 4) {
        return TextEditingValue(
          text: '${text.substring(0, 2)}/${text.substring(2)}',
          selection: TextSelection.collapsed(offset: text.length + 1),
        );
      } else {
        return oldValue;
      }
    });
  }

  // Decimal formatter with specified decimal places
  static TextInputFormatter decimalFormatter({int decimalPlaces = 2}) {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final regex = RegExp(r'^\d+\.?\d{0,' + decimalPlaces.toString() + r'}');
      final match = regex.firstMatch(newValue.text);
      
      if (match != null) {
        return TextEditingValue(
          text: match.group(0)!,
          selection: TextSelection.collapsed(offset: match.group(0)!.length),
        );
      }
      
      return oldValue;
    });
  }

  // Currency formatter
  static TextInputFormatter get currencyFormatter {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      if (newValue.text.isEmpty) {
        return newValue;
      }

      final value = double.tryParse(newValue.text.replaceAll(RegExp(r'[^\d.]'), ''));
      if (value == null) {
        return oldValue;
      }

      final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
      final formatted = formatter.format(value);

      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    });
  }

  // Percentage formatter
  static TextInputFormatter get percentageFormatter {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      if (newValue.text.isEmpty) {
        return newValue;
      }

      final text = newValue.text.replaceAll('%', '');
      final value = double.tryParse(text);
      
      if (value == null || value < 0 || value > 100) {
        return oldValue;
      }

      return TextEditingValue(
        text: '$text%',
        selection: TextSelection.collapsed(offset: text.length),
      );
    });
  }

  // Uppercase formatter
  static TextInputFormatter get uppercaseFormatter {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      return TextEditingValue(
        text: newValue.text.toUpperCase(),
        selection: newValue.selection,
      );
    });
  }

  // Lowercase formatter
  static TextInputFormatter get lowercaseFormatter {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      return TextEditingValue(
        text: newValue.text.toLowerCase(),
        selection: newValue.selection,
      );
    });
  }

  // Alphanumeric only formatter
  static TextInputFormatter get alphanumericFormatter {
    return FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'));
  }

  // Numbers only formatter
  static TextInputFormatter get numbersOnlyFormatter {
    return FilteringTextInputFormatter.digitsOnly;
  }

  // Letters only formatter
  static TextInputFormatter get lettersOnlyFormatter {
    return FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'));
  }

  // Custom mask formatter
  static TextInputFormatter maskFormatter(String mask) {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final text = newValue.text;
      String result = '';
      int textIndex = 0;

      for (int i = 0; i < mask.length && textIndex < text.length; i++) {
        if (mask[i] == '#') {
          result += text[textIndex];
          textIndex++;
        } else {
          result += mask[i];
        }
      }

      return TextEditingValue(
        text: result,
        selection: TextSelection.collapsed(offset: result.length),
      );
    });
  }

  // String formatting utilities
  static String formatCurrency(
    double amount, {
    String symbol = '\$',
    int decimalDigits = 2,
    String locale = 'en_US',
  }) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
      locale: locale,
    );
    return formatter.format(amount);
  }

  static String formatNumber(
    num number, {
    int? decimalDigits,
    String locale = 'en_US',
  }) {
    final formatter = NumberFormat('#,##0${decimalDigits != null ? '.${'0' * decimalDigits}' : ''}', locale);
    return formatter.format(number);
  }

  static String formatPercentage(
    double value, {
    int decimalDigits = 1,
    String locale = 'en_US',
  }) {
    final formatter = NumberFormat.percentPattern(locale);
    formatter.minimumFractionDigits = decimalDigits;
    formatter.maximumFractionDigits = decimalDigits;
    return formatter.format(value);
  }

  // Date formatting utilities
  static String formatDate(
    DateTime date, {
    String pattern = 'yyyy-MM-dd',
    String? locale,
  }) {
    final formatter = DateFormat(pattern, locale);
    return formatter.format(date);
  }

  static String formatTime(
    DateTime date, {
    String pattern = 'HH:mm',
    String? locale,
  }) {
    final formatter = DateFormat(pattern, locale);
    return formatter.format(date);
  }

  static String formatDateTime(
    DateTime date, {
    String pattern = 'yyyy-MM-dd HH:mm',
    String? locale,
  }) {
    final formatter = DateFormat(pattern, locale);
    return formatter.format(date);
  }

  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  // File size formatting
  static String formatFileSize(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    int i = 0;
    double size = bytes.toDouble();

    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }

    return '${size.toStringAsFixed(i == 0 ? 0 : 1)} ${suffixes[i]}';
  }

  // Duration formatting
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  // Phone number formatting for display
  static String formatPhoneNumber(String phoneNumber) {
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cleaned.length == 10) {
      return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
    } else if (cleaned.length == 11 && cleaned.startsWith('1')) {
      return '+1 (${cleaned.substring(1, 4)}) ${cleaned.substring(4, 7)}-${cleaned.substring(7)}';
    } else {
      return phoneNumber; // Return as-is if format not recognized
    }
  }

  // Credit card number formatting for display
  static String formatCreditCardNumber(String cardNumber) {
    final cleaned = cardNumber.replaceAll(RegExp(r'[^0-9]'), '');
    String formatted = '';
    
    for (int i = 0; i < cleaned.length; i += 4) {
      if (i + 4 < cleaned.length) {
        formatted += '${cleaned.substring(i, i + 4)} ';
      } else {
        formatted += cleaned.substring(i);
      }
    }
    
    return formatted.trim();
  }

  // Mask sensitive information
  static String maskString(String value, {int visibleStart = 0, int visibleEnd = 4}) {
    if (value.length <= visibleStart + visibleEnd) {
      return value;
    }
    
    final start = value.substring(0, visibleStart);
    final end = value.substring(value.length - visibleEnd);
    final masked = '*' * (value.length - visibleStart - visibleEnd);
    
    return '$start$masked$end';
  }

  // Mask credit card number
  static String maskCreditCard(String cardNumber) {
    final cleaned = cardNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length < 4) return cardNumber;
    
    return '**** **** **** ${cleaned.substring(cleaned.length - 4)}';
  }

  // Mask email
  static String maskEmail(String email) {
    if (!email.contains('@')) return email;
    
    final parts = email.split('@');
    final username = parts[0];
    final domain = parts[1];
    
    if (username.length <= 2) {
      return '***@$domain';
    }
    
    return '${username[0]}${'*' * (username.length - 2)}${username[username.length - 1]}@$domain';
  }

  // Convert string to title case
  static String toTitleCase(String text) {
    return text.split(' ')
        .map((word) => word.isNotEmpty 
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : word)
        .join(' ');
  }

  // Convert string to sentence case
  static String toSentenceCase(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}';
  }

  // Truncate text with ellipsis
  static String truncateText(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - suffix.length)}$suffix';
  }

  // Generate initials from name
  static String generateInitials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    return words
        .take(2)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();
  }
}