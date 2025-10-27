extension DateTimeExtensions on DateTime {
  // Formatting
  String get dayName {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday', 
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday - 1];
  }
  
  String get shortDayName {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
  
  String get monthName {
    const months = [
      'January',
      'February', 
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
  
  String get shortMonthName {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
  
  // Relative time
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);
    
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
  
  String get timeUntil {
    final now = DateTime.now();
    if (isBefore(now)) return 'Past due';
    
    final difference = this.difference(now);
    
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'In $years year${years > 1 ? 's' : ''}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'In $months month${months > 1 ? 's' : ''}';
    } else if (difference.inDays > 0) {
      return 'In ${difference.inDays} day${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'In ${difference.inHours} hour${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'In ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'Now';
    }
  }
  
  // Date comparisons
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
  
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }
  
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }
  
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
           isBefore(endOfWeek.add(const Duration(days: 1)));
  }
  
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }
  
  bool get isThisYear {
    final now = DateTime.now();
    return year == now.year;
  }
  
  bool get isPast => isBefore(DateTime.now());
  bool get isFuture => isAfter(DateTime.now());
  
  // Date operations
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
  
  DateTime get startOfWeek {
    return subtract(Duration(days: weekday - 1));
  }
  
  DateTime get endOfWeek {
    return startOfWeek.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
  }
  
  DateTime get startOfMonth => DateTime(year, month);
  
  DateTime get endOfMonth => DateTime(year, month + 1).subtract(const Duration(microseconds: 1));
  
  DateTime get startOfYear => DateTime(year);
  
  DateTime get endOfYear => DateTime(year, 12, 31, 23, 59, 59);
  
  // Age calculation
  int ageInYears([DateTime? referenceDate]) {
    final reference = referenceDate ?? DateTime.now();
    int age = reference.year - year;
    if (reference.month < month || (reference.month == month && reference.day < day)) {
      age--;
    }
    return age;
  }
  
  int ageInMonths([DateTime? referenceDate]) {
    final reference = referenceDate ?? DateTime.now();
    int months = (reference.year - year) * 12 + reference.month - month;
    if (reference.day < day) {
      months--;
    }
    return months;
  }
  
  int ageInDays([DateTime? referenceDate]) {
    final reference = referenceDate ?? DateTime.now();
    return reference.difference(this).inDays;
  }
  
  // Weekday utilities
  bool get isWeekday => weekday >= 1 && weekday <= 5;
  bool get isWeekend => weekday == 6 || weekday == 7;
  bool get isMonday => weekday == 1;
  bool get isTuesday => weekday == 2;
  bool get isWednesday => weekday == 3;
  bool get isThursday => weekday == 4;
  bool get isFriday => weekday == 5;
  bool get isSaturday => weekday == 6;
  bool get isSunday => weekday == 7;
  
  // Quarter utilities
  int get quarter {
    if (month <= 3) return 1;
    if (month <= 6) return 2;
    if (month <= 9) return 3;
    return 4;
  }
  
  DateTime get startOfQuarter {
    final quarterStartMonth = ((quarter - 1) * 3) + 1;
    return DateTime(year, quarterStartMonth);
  }
  
  DateTime get endOfQuarter {
    final quarterEndMonth = quarter * 3;
    return DateTime(year, quarterEndMonth + 1).subtract(const Duration(microseconds: 1));
  }
  
  // Day of year
  int get dayOfYear {
    return difference(DateTime(year)).inDays + 1;
  }
  
  // Week of year (ISO 8601)
  int get weekOfYear {
    final dayOfYear = this.dayOfYear;
    final woy = ((dayOfYear - weekday + 10) / 7).floor();
    if (woy < 1) {
      return DateTime(year - 1, 12, 31).weekOfYear;
    } else if (woy > 52) {
      return DateTime(year + 1).weekOfYear == 1 ? 1 : woy;
    }
    return woy;
  }
  
  // Leap year
  bool get isLeapYear {
    return (year % 4 == 0) && (year % 100 != 0 || year % 400 == 0);
  }
  
  int get daysInMonth {
    const daysPerMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month == 2 && isLeapYear) {
      return 29;
    }
    return daysPerMonth[month - 1];
  }
  
  // Business days
  bool get isBusinessDay => isWeekday && !isHoliday;
  
  // Note: This is a basic implementation. In a real app, you'd want to
  // integrate with a proper holiday calendar service
  bool get isHoliday {
    // Basic US holidays (you can extend this)
    final holidays = [
      DateTime(year), // New Year's Day
      DateTime(year, 7, 4), // Independence Day
      DateTime(year, 12, 25), // Christmas
    ];
    
    return holidays.any((holiday) => 
      year == holiday.year && 
      month == holiday.month && 
      day == holiday.day
    );
  }
  
  DateTime addBusinessDays(int businessDays) {
    var date = this;
    var daysToAdd = businessDays.abs();
    var direction = businessDays.isNegative ? -1 : 1;
    
    while (daysToAdd > 0) {
      date = date.add(Duration(days: direction));
      if (date.isBusinessDay) {
        daysToAdd--;
      }
    }
    
    return date;
  }
  
  // Time formatting
  String get timeString => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  
  String get timeString12Hour {
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final period = hour < 12 ? 'AM' : 'PM';
    return '${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }
  
  // Date formatting
  String get dateString => '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  
  String get shortDateString => '${month.toString().padLeft(2, '0')}/${day.toString().padLeft(2, '0')}/${year.toString().substring(2)}';
  
  String get longDateString => '$dayName, $monthName $day, $year';
  
  String get mediumDateString => '$shortMonthName $day, $year';

  // Custom formatted string (used in subscription management)
  String toFormattedString() {
    return '$shortMonthName $day, $year';
  }
  
  // Unix timestamp
  int get unixTimestamp => millisecondsSinceEpoch ~/ 1000;
  
  // Timezone utilities
  DateTime get utc => toUtc();
  DateTime get local => toLocal();
  
  // Copy with modifications
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}