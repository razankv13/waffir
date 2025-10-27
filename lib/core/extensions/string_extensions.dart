extension StringExtensions on String {
  // Validation
  bool get isValidEmail {
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    return RegExp(pattern).hasMatch(this);
  }
  
  bool get isValidPhone {
    const pattern = r'^\+?[1-9]\d{1,14}$';
    return RegExp(pattern).hasMatch(this);
  }
  
  bool get isValidUrl {
    const pattern = r'^(http|https):\/\/[^ "]+$';
    return RegExp(pattern).hasMatch(this);
  }
  
  bool get isValidUsername {
    const pattern = r'^[a-zA-Z0-9_]{3,30}$';
    return RegExp(pattern).hasMatch(this);
  }
  
  bool get isAlphanumeric {
    const pattern = r'^[a-zA-Z0-9]+$';
    return RegExp(pattern).hasMatch(this);
  }
  
  bool get isNumeric {
    return double.tryParse(this) != null;
  }
  
  bool get isAlpha {
    const pattern = r'^[a-zA-Z]+$';
    return RegExp(pattern).hasMatch(this);
  }
  
  // Case transformations
  String get capitalizeFirst {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
  
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isNotEmpty ? word.capitalizeFirst : word)
        .join(' ');
  }
  
  String get camelCase {
    if (isEmpty) return this;
    final words = split(RegExp(r'[_\s]+'));
    if (words.isEmpty) return this;
    
    final first = words.first.toLowerCase();
    final rest = words.skip(1).map((word) => word.capitalizeFirst);
    
    return [first, ...rest].join();
  }
  
  String get pascalCase {
    if (isEmpty) return this;
    return split(RegExp(r'[_\s]+'))
        .map((word) => word.capitalizeFirst)
        .join();
  }
  
  String get snakeCase {
    return replaceAllMapped(RegExp(r'([A-Z])'), (match) => '_${match.group(1)!.toLowerCase()}')
        .replaceFirst(RegExp(r'^_'), '');
  }
  
  String get kebabCase {
    return replaceAllMapped(RegExp(r'([A-Z])'), (match) => '-${match.group(1)!.toLowerCase()}')
        .replaceFirst(RegExp(r'^-'), '');
  }
  
  // Formatting
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');
  
  String get removeNewlines => replaceAll('\n', '').replaceAll('\r', '');
  
  String get cleanWhitespace => replaceAll(RegExp(r'\s+'), ' ').trim();
  
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }
  
  String truncateWords(int maxWords, {String suffix = '...'}) {
    final words = split(' ');
    if (words.length <= maxWords) return this;
    return '${words.take(maxWords).join(' ')}$suffix';
  }
  
  String get reversed => split('').reversed.join();
  
  // Utility
  bool get isBlank => trim().isEmpty;
  
  bool get isNotBlank => !isBlank;
  
  int get wordCount => isBlank ? 0 : trim().split(RegExp(r'\s+')).length;
  
  int get characterCount => length;
  
  int get characterCountNoSpaces => removeWhitespace.length;
  
  // Parsing
  int? get toIntOrNull => int.tryParse(this);
  
  double? get toDoubleOrNull => double.tryParse(this);
  
  bool? get toBoolOrNull {
    final lower = toLowerCase();
    if (lower == 'true' || lower == '1') return true;
    if (lower == 'false' || lower == '0') return false;
    return null;
  }
  
  DateTime? get toDateTimeOrNull => DateTime.tryParse(this);
  
  // File/Path utilities
  String get fileName {
    if (isEmpty) return this;
    return split('/').last;
  }
  
  String get fileExtension {
    if (isEmpty) return '';
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last : '';
  }
  
  String get fileNameWithoutExtension {
    if (isEmpty) return this;
    final name = fileName;
    final parts = name.split('.');
    return parts.length > 1 ? parts.take(parts.length - 1).join('.') : name;
  }
  
  String get directoryPath {
    if (isEmpty) return this;
    final parts = split('/');
    return parts.length > 1 ? parts.take(parts.length - 1).join('/') : '';
  }
  
  // HTML utilities
  String get stripHtmlTags => replaceAll(RegExp(r'<[^>]*>'), '');
  
  String get decodeHtmlEntities => 
    replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#x27;', "'")
        .replaceAll('&#x2F;', '/')
        .replaceAll('&#39;', "'");
  
  // Search utilities
  bool containsIgnoreCase(String other) => 
    toLowerCase().contains(other.toLowerCase());
  
  bool startsWithIgnoreCase(String other) => 
    toLowerCase().startsWith(other.toLowerCase());
  
  bool endsWithIgnoreCase(String other) => 
    toLowerCase().endsWith(other.toLowerCase());
  
  // Mask utilities
  String maskEmail() {
    if (!isValidEmail) return this;
    final parts = split('@');
    if (parts.length != 2) return this;
    
    final username = parts[0];
    final domain = parts[1];
    
    if (username.length <= 3) {
      return '***@$domain';
    }
    
    final masked = username[0] + '*' * (username.length - 2) + username[username.length - 1];
    return '$masked@$domain';
  }
  
  String maskPhone() {
    if (!isValidPhone) return this;
    if (length <= 4) return '*' * length;
    return '${substring(0, 2)}${'*' * (length - 4)}${substring(length - 2)}';
  }
  
  String maskCreditCard() {
    if (length <= 4) return this;
    return '*' * (length - 4) + substring(length - 4);
  }
  
  // Password strength
  bool get hasUppercase => contains(RegExp(r'[A-Z]'));
  bool get hasLowercase => contains(RegExp(r'[a-z]'));
  bool get hasDigits => contains(RegExp(r'[0-9]'));
  bool get hasSpecialCharacters => contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  
  int get passwordStrength {
    int strength = 0;
    if (length >= 8) strength++;
    if (length >= 12) strength++;
    if (hasUppercase) strength++;
    if (hasLowercase) strength++;
    if (hasDigits) strength++;
    if (hasSpecialCharacters) strength++;
    return strength;
  }
  
  bool get isStrongPassword => passwordStrength >= 5;
  
  // Color utilities
  String get hexToColor {
    String hex = replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // Add alpha channel
    }
    return hex.toUpperCase();
  }
  
  // Slug generation
  String get toSlug {
    return toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '') // Remove special characters
        .replaceAll(RegExp(r'\s+'), '-') // Replace spaces with hyphens
        .replaceAll(RegExp(r'-+'), '-') // Replace multiple hyphens with single
        .replaceAll(RegExp(r'^-|-$'), ''); // Remove leading/trailing hyphens
  }
  
  // Initials
  String get initials {
    if (isEmpty) return '';
    final words = trim().split(RegExp(r'\s+'));
    return words
        .take(2)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();
  }
  
  // Lorem ipsum detection
  bool get isLoremIpsum {
    const loremWords = [
      'lorem', 'ipsum', 'dolor', 'sit', 'amet', 'consectetur',
      'adipiscing', 'elit', 'sed', 'do', 'eiusmod', 'tempor'
    ];
    final words = toLowerCase().split(RegExp(r'\s+'));
    return words.any((word) => loremWords.contains(word));
  }
  
  // Levenshtein distance (similarity)
  int levenshteinDistance(String other) {
    if (isEmpty) return other.length;
    if (other.isEmpty) return length;
    
    final matrix = List.generate(
      length + 1,
      (i) => List.generate(other.length + 1, (j) => 0),
    );
    
    for (int i = 0; i <= length; i++) {
      matrix[i][0] = i;
    }
    
    for (int j = 0; j <= other.length; j++) {
      matrix[0][j] = j;
    }
    
    for (int i = 1; i <= length; i++) {
      for (int j = 1; j <= other.length; j++) {
        final cost = this[i - 1] == other[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1, // deletion
          matrix[i][j - 1] + 1, // insertion
          matrix[i - 1][j - 1] + cost, // substitution
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    
    return matrix[length][other.length];
  }
  
  double similarity(String other) {
    final maxLength = length > other.length ? length : other.length;
    if (maxLength == 0) return 1.0;
    return 1.0 - (levenshteinDistance(other) / maxLength);
  }
}