import 'package:flutter_test/flutter_test.dart';
import 'package:waffir/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('Email validation', () {
      test('should return null for valid email addresses', () {
        const validEmails = [
          'test@example.com',
          'user.name@domain.co.uk',
          'test+tag@example.org',
          'user123@test-domain.com',
        ];

        for (final email in validEmails) {
          expect(Validators.email(email), null,
              reason: 'Email $email should be valid');
        }
      });

      test('should return error message for invalid email addresses', () {
        const invalidEmails = [
          '',
          'invalid',
          'test@',
          '@example.com',
          'test..email@example.com',
          'test@example',
          'test@.com',
          'test space@example.com',
        ];

        for (final email in invalidEmails) {
          expect(Validators.email(email), isA<String>(),
              reason: 'Email $email should be invalid');
        }
      });
    });

    group('Password validation', () {
      test('should return null for strong passwords', () {
        const strongPasswords = [
          'MyStr0ngP@ssw0rd',
          'Complex123!',
          'P@ssw0rd123',
          'MySecure#Pass1',
        ];

        for (final password in strongPasswords) {
          expect(Validators.password(password), null,
              reason: 'Password $password should be strong');
        }
      });

      test('should return error message for weak passwords', () {
        const weakPasswords = [
          '',
          '123',
          'password',
          'PASSWORD',
          '12345678',
          'weakpass',
          'NoNumbers!',
          'nonumbers123',
          'NOLOWERCASE123!',
        ];

        for (final password in weakPasswords) {
          expect(Validators.password(password), isA<String>(),
              reason: 'Password $password should be weak');
        }
      });

      test('should check minimum length', () {
        expect(Validators.minLength('short', 10), isA<String>());
        expect(Validators.minLength('longenough', 10), null);
        expect(Validators.minLength('exactly10!', 10), null);
      });
    });

    group('Phone number validation', () {
      test('should return null for valid phone numbers', () {
        const validPhones = [
          '+1234567890',
          '1234567890',
          '+44 20 7946 0958',
          '+33 1 42 86 83 26',
        ];

        for (final phone in validPhones) {
          expect(Validators.phoneNumber(phone), null,
              reason: 'Phone $phone should be valid');
        }
      });

      test('should return error message for invalid phone numbers', () {
        const invalidPhones = [
          '',
          '123',
          'abc123',
          '++1234567890',
          '+',
          '123-abc-7890',
        ];

        for (final phone in invalidPhones) {
          expect(Validators.phoneNumber(phone), isA<String>(),
              reason: 'Phone $phone should be invalid');
        }
      });
    });

    group('Name validation', () {
      test('should return null for valid names', () {
        const validNames = [
          'John',
          'Mary Jane',
          'Jean-Pierre',
          "O'Connor",
          'José María',
        ];

        for (final name in validNames) {
          expect(Validators.name(name), null,
              reason: 'Name $name should be valid');
        }
      });

      test('should return error message for invalid names', () {
        const invalidNames = [
          '',
          '   ',
          '123',
          'John123',
          'Name!',
          '@name',
          'A', // Too short
        ];

        for (final name in invalidNames) {
          expect(Validators.name(name), isA<String>(),
              reason: 'Name $name should be invalid');
        }
      });
    });

    group('URL validation', () {
      test('should return null for valid URLs', () {
        const validUrls = [
          'https://example.com',
          'http://test.org',
          'https://sub.domain.co.uk/path?param=value',
          'https://example.com:8080/path',
        ];

        for (final url in validUrls) {
          expect(Validators.url(url), null,
              reason: 'URL $url should be valid');
        }
      });

      test('should return error message for invalid URLs', () {
        const invalidUrls = [
          '',
          'not-a-url',
          'ftp://example.com',
          'example.com',
          'https://',
          'https://.',
        ];

        for (final url in invalidUrls) {
          expect(Validators.url(url), isA<String>(),
              reason: 'URL $url should be invalid');
        }
      });
    });

    group('Required field validation', () {
      test('should return null for non-empty values', () {
        expect(Validators.required('valid value'), null);
        expect(Validators.required('  spaces  '), null);
        expect(Validators.required('123'), null);
      });

      test('should return error for empty values', () {
        expect(Validators.required(''), isA<String>());
        expect(Validators.required('   '), isA<String>());
        expect(Validators.required(null), isA<String>());
      });

      test('should use custom field name in error message', () {
        final error = Validators.required('', 'Email');
        expect(error, contains('Email'));
      });
    });

    group('Numeric validation', () {
      test('should return null for valid numbers', () {
        expect(Validators.numeric('123'), null);
        expect(Validators.numeric('123.45'), null);
        expect(Validators.numeric('-123'), null);
        expect(Validators.numeric('0'), null);
      });

      test('should return error for invalid numbers', () {
        expect(Validators.numeric('abc'), isA<String>());
        expect(Validators.numeric('123abc'), isA<String>());
        expect(Validators.numeric(''), isA<String>());
        expect(Validators.numeric(null), isA<String>());
      });
    });

    group('Password strength', () {
      test('should calculate password strength correctly', () {
        expect(Validators.getPasswordStrength('123'), lessThan(3));
        expect(Validators.getPasswordStrength('password'), lessThan(3));
        expect(Validators.getPasswordStrength('Password1'), greaterThanOrEqualTo(3));
        expect(Validators.getPasswordStrength('Password1!'), greaterThanOrEqualTo(4));
        expect(Validators.getPasswordStrength('VeryLongPassword123!'), equals(5));
      });

      test('should return appropriate strength text', () {
        expect(Validators.getPasswordStrengthText('123'), contains('Weak'));
        expect(Validators.getPasswordStrengthText('Password1!'), contains('Strong'));
      });
    });

    group('Combine validators', () {
      test('should combine multiple validators correctly', () {
        final combinedValidator = Validators.combine([
          Validators.required,
          (value) => Validators.minLength(value, 5),
        ]);

        expect(combinedValidator(''), isA<String>()); // Fails required
        expect(combinedValidator('123'), isA<String>()); // Fails min length
        expect(combinedValidator('12345'), null); // Passes both
      });
    });

    group('Custom validators', () {
      test('should create custom validator correctly', () {
        final customValidator = Validators.custom(
          condition: (value) => value != null && value.contains('@'),
          errorMessage: 'Must contain @',
        );

        expect(customValidator('test'), equals('Must contain @'));
        expect(customValidator('test@example'), null);
      });
    });

    group('Credit card validation', () {
      test('should validate credit card numbers', () {
        // These are test numbers that pass Luhn algorithm
        expect(Validators.creditCard('4111111111111111'), null); // Visa test number
        expect(Validators.creditCard('5555555555554444'), null); // Mastercard test number

        expect(Validators.creditCard(''), isA<String>());
        expect(Validators.creditCard('123'), isA<String>());
        expect(Validators.creditCard('4111111111111112'), isA<String>()); // Invalid Luhn
      });
    });

    group('Date validation', () {
      test('should validate dates correctly', () {
        expect(Validators.date('2023-12-25'), null);
        expect(Validators.date('2023-01-01'), null);

        expect(Validators.date(''), isA<String>());
        expect(Validators.date('invalid-date'), isA<String>());
        expect(Validators.date('2023-13-01'), isA<String>()); // Invalid month
      });

      test('should validate future dates', () {
        final futureDate = DateTime.now().add(const Duration(days: 1));
        final pastDate = DateTime.now().subtract(const Duration(days: 1));

        expect(Validators.futureDate(futureDate.toIso8601String().split('T')[0]), null);
        expect(Validators.futureDate(pastDate.toIso8601String().split('T')[0]), isA<String>());
      });
    });
  });
}