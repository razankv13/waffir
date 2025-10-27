import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waffir/features/auth/domain/entities/auth_state.dart';
import 'package:waffir/features/auth/domain/entities/user_model.dart';
import 'package:waffir/features/auth/data/providers/auth_providers.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/core/errors/failures.dart';
import '../../../../../mocks/mock_services.dart';
import '../../../../../helpers/test_helpers.dart';

void main() {
  group('AuthController', () {
    late MockAuthRepository mockAuthRepository;
    late ProviderContainer container;

    setUp(() {
      mockAuthRepository = MockSetup.createMockAuthRepository();
      MockSetup.setUpMockFallbacks();

      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((_) => mockAuthRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('Email Sign In', () {
      test('should emit loading then authenticated state on successful login', () async {
        // Arrange
        final user = UserModel(
          id: TestConstants.mockUserId,
          email: TestConstants.validEmail,
          displayName: TestConstants.mockUserName,
          emailVerified: true,
          createdAt: DateTime.now(),
        );
        final successState = AuthState.authenticated(user: user);

        when(() => mockAuthRepository.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Result.success(successState));

        // Act
        final controller = container.read(authControllerProvider.notifier);
        await controller.signInWithEmailAndPassword(
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
        );

        // Assert
        final state = container.read(authControllerProvider);
        expect(state.hasValue, true);
        expect(state.value, isA<AuthState>());
        expect(state.value, successState);
      });

      test('should emit loading then error state on failed login', () async {
        // Arrange
        const errorMessage = 'Login failed';
        const failure = Failure.auth(message: errorMessage);

        when(() => mockAuthRepository.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const Result.failure(failure));

        // Act
        final controller = container.read(authControllerProvider.notifier);
        await controller.signInWithEmailAndPassword(
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
        );

        // Assert
        final state = container.read(authControllerProvider);
        expect(state.hasError, true);
        expect(state.error, isA<Failure>());
      });

      test('should call repository with correct parameters', () async {
        // Arrange
        const email = TestConstants.validEmail;
        const password = TestConstants.validPassword;

        when(() => mockAuthRepository.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const Result.success(AuthState.initial()));

        // Act
        final controller = container.read(authControllerProvider.notifier);
        await controller.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Assert
        verify(() => mockAuthRepository.signInWithEmailAndPassword(
              email: email,
              password: password,
            )).called(1);
      });

      test('should handle network failure with appropriate error', () async {
        // Arrange
        const failure = Failure.network(message: 'No internet connection');

        when(() => mockAuthRepository.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const Result.failure(failure));

        // Act
        final controller = container.read(authControllerProvider.notifier);
        await controller.signInWithEmailAndPassword(
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
        );

        // Assert
        final state = container.read(authControllerProvider);
        expect(state.hasError, true);
        final error = state.error;
        expect(error, isA<NetworkFailure>());
        expect((error as NetworkFailure).message, 'No internet connection');
      });
    });

    group('User Registration', () {
      test('should emit loading then authenticated state on successful registration', () async {
        // Arrange
        final user = UserModel(
          id: TestConstants.mockUserId,
          email: TestConstants.validEmail,
          displayName: TestConstants.mockUserName,
          createdAt: DateTime.now(),
        );
        final successState = AuthState.authenticated(user: user);

        when(() => mockAuthRepository.createUserWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
              displayName: any(named: 'displayName'),
            )).thenAnswer((_) async => Result.success(successState));

        // Act
        final controller = container.read(authControllerProvider.notifier);
        await controller.createUserWithEmailAndPassword(
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
          displayName: TestConstants.mockUserName,
        );

        // Assert
        final state = container.read(authControllerProvider);
        expect(state.hasValue, true);
        expect(state.value, isA<AuthState>());
        expect(state.value, successState);
      });

      test('should handle registration failure', () async {
        // Arrange
        const failure = Failure.auth(
          message: 'Email already in use',
          code: 'email-already-in-use',
        );

        when(() => mockAuthRepository.createUserWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
              displayName: any(named: 'displayName'),
            )).thenAnswer((_) async => const Result.failure(failure));

        // Act
        final controller = container.read(authControllerProvider.notifier);
        await controller.createUserWithEmailAndPassword(
          email: TestConstants.validEmail,
          password: TestConstants.validPassword,
          displayName: TestConstants.mockUserName,
        );

        // Assert
        final state = container.read(authControllerProvider);
        expect(state.hasError, true);
        expect(state.error, isA<AuthFailure>());
      });
    });

    group('Social Sign In', () {
      test('should handle Google sign in successfully', () async {
        // Arrange
        final user = UserModel(
          id: TestConstants.mockUserId,
          email: TestConstants.validEmail,
          displayName: TestConstants.mockUserName,
          photoURL: TestConstants.mockUserPhotoUrl,
          emailVerified: true,
          createdAt: DateTime.now(),
        );
        final successState = AuthState.authenticated(user: user);

        when(() => mockAuthRepository.signInWithGoogle())
            .thenAnswer((_) async => Result.success(successState));

        // Act
        final controller = container.read(authControllerProvider.notifier);
        await controller.signInWithGoogle();

        // Assert
        final state = container.read(authControllerProvider);
        expect(state.hasValue, true);
        expect(state.value, successState);
        verify(() => mockAuthRepository.signInWithGoogle()).called(1);
      });

      test('should handle Google sign in cancellation', () async {
        // Arrange
        const failure = Failure.auth(
          message: 'Sign in cancelled by user',
          code: 'sign-in-cancelled',
        );

        when(() => mockAuthRepository.signInWithGoogle())
            .thenAnswer((_) async => const Result.failure(failure));

        // Act
        final controller = container.read(authControllerProvider.notifier);
        await controller.signInWithGoogle();

        // Assert
        final state = container.read(authControllerProvider);
        expect(state.hasError, true);
        verify(() => mockAuthRepository.signInWithGoogle()).called(1);
      });

      test('should handle Apple sign in successfully', () async {
        // Arrange
        final user = UserModel(
          id: TestConstants.mockUserId,
          email: TestConstants.validEmail,
          displayName: TestConstants.mockUserName,
          emailVerified: true,
          createdAt: DateTime.now(),
        );
        final successState = AuthState.authenticated(user: user);

        when(() => mockAuthRepository.signInWithApple())
            .thenAnswer((_) async => Result.success(successState));

        // Act
        final controller = container.read(authControllerProvider.notifier);
        await controller.signInWithApple();

        // Assert
        final state = container.read(authControllerProvider);
        expect(state.hasValue, true);
        expect(state.value, successState);
        verify(() => mockAuthRepository.signInWithApple()).called(1);
      });

      test('should handle Apple sign in failure', () async {
        // Arrange
        const failure = Failure.platform(
          message: 'Apple Sign In not available',
          platformCode: 'not-available',
        );

        when(() => mockAuthRepository.signInWithApple())
            .thenAnswer((_) async => const Result.failure(failure));

        // Act
        final controller = container.read(authControllerProvider.notifier);
        await controller.signInWithApple();

        // Assert
        final state = container.read(authControllerProvider);
        expect(state.hasError, true);
        verify(() => mockAuthRepository.signInWithApple()).called(1);
      });
    });

    group('Sign Out', () {
      test('should call repository sign out method successfully', () async {
        // Arrange
        when(() => mockAuthRepository.signOut())
            .thenAnswer((_) async => const Result.success(null));

        // Act
        final controller = container.read(authControllerProvider.notifier);
        await controller.signOut();

        // Assert
        verify(() => mockAuthRepository.signOut()).called(1);
      });

      test('should handle sign out errors', () async {
        // Arrange
        const failure = Failure.unknown(message: 'Sign out failed');

        when(() => mockAuthRepository.signOut())
            .thenAnswer((_) async => const Result.failure(failure));

        // Act & Assert
        final controller = container.read(authControllerProvider.notifier);
        expect(
          () => controller.signOut(),
          throwsA(isA<Failure>()),
        );
      });
    });

    group('Password Reset', () {
      test('should call repository password reset method successfully', () async {
        // Arrange
        const email = TestConstants.validEmail;
        when(() => mockAuthRepository.sendPasswordResetEmail(
              email: any(named: 'email'),
            )).thenAnswer((_) async => const Result.success(null));

        // Act
        final controller = container.read(authControllerProvider.notifier);
        await controller.sendPasswordResetEmail(email: email);

        // Assert
        verify(() => mockAuthRepository.sendPasswordResetEmail(
              email: email,
            )).called(1);
      });

      test('should handle password reset errors', () async {
        // Arrange
        const failure = Failure.auth(
          message: 'User not found',
          code: 'user-not-found',
        );

        when(() => mockAuthRepository.sendPasswordResetEmail(
              email: any(named: 'email'),
            )).thenAnswer((_) async => const Result.failure(failure));

        // Act & Assert
        final controller = container.read(authControllerProvider.notifier);
        expect(
          () => controller.sendPasswordResetEmail(
            email: TestConstants.validEmail,
          ),
          throwsA(isA<Failure>()),
        );
      });

      test('should handle invalid email format', () async {
        // Arrange
        const failure = Failure.validation(
          message: 'Invalid email format',
          field: 'email',
        );

        when(() => mockAuthRepository.sendPasswordResetEmail(
              email: any(named: 'email'),
            )).thenAnswer((_) async => const Result.failure(failure));

        // Act & Assert
        final controller = container.read(authControllerProvider.notifier);
        expect(
          () => controller.sendPasswordResetEmail(
            email: 'invalid-email',
          ),
          throwsA(isA<ValidationFailure>()),
        );
      });
    });

    group('Email Verification', () {
      test('should call repository email verification method successfully', () async {
        // Arrange
        when(() => mockAuthRepository.sendEmailVerification())
            .thenAnswer((_) async => const Result.success(null));

        // Act
        final controller = container.read(authControllerProvider.notifier);
        await controller.sendEmailVerification();

        // Assert
        verify(() => mockAuthRepository.sendEmailVerification()).called(1);
      });

      test('should handle email verification errors', () async {
        // Arrange
        const failure = Failure.auth(
          message: 'Too many requests',
          code: 'too-many-requests',
        );

        when(() => mockAuthRepository.sendEmailVerification())
            .thenAnswer((_) async => const Result.failure(failure));

        // Act & Assert
        final controller = container.read(authControllerProvider.notifier);
        expect(
          () => controller.sendEmailVerification(),
          throwsA(isA<Failure>()),
        );
      });
    });

    group('Anonymous Sign In', () {
      test('should handle anonymous sign in successfully', () async {
        // Arrange
        final user = UserModel(
          id: TestConstants.mockUserId,
          email: 'anonymous@guest.com', // Anonymous users have a placeholder email
          displayName: 'Guest',
          isAnonymous: true,
          createdAt: DateTime.now(),
        );
        final successState = AuthState.authenticated(user: user);

        when(() => mockAuthRepository.signInAnonymously())
            .thenAnswer((_) async => Result.success(successState));

        // Act
        final controller = container.read(authControllerProvider.notifier);
        await controller.signInAnonymously();

        // Assert
        final state = container.read(authControllerProvider);
        expect(state.hasValue, true);
        expect(state.value, successState);
        verify(() => mockAuthRepository.signInAnonymously()).called(1);
      });

      test('should handle anonymous sign in failure', () async {
        // Arrange
        const failure = Failure.auth(
          message: 'Anonymous sign in disabled',
          code: 'operation-not-allowed',
        );

        when(() => mockAuthRepository.signInAnonymously())
            .thenAnswer((_) async => const Result.failure(failure));

        // Act
        final controller = container.read(authControllerProvider.notifier);
        await controller.signInAnonymously();

        // Assert
        final state = container.read(authControllerProvider);
        expect(state.hasError, true);
        expect(state.error, isA<AuthFailure>());
      });
    });

    group('Email Availability Check', () {
      test('should return true for available email', () async {
        // Arrange
        const email = 'available@example.com';
        when(() => mockAuthRepository.isEmailAvailable(any()))
            .thenAnswer((_) async => const Result.success(true));

        // Act
        final controller = container.read(authControllerProvider.notifier);
        final isAvailable = await controller.isEmailAvailable(email);

        // Assert
        expect(isAvailable, true);
        verify(() => mockAuthRepository.isEmailAvailable(email)).called(1);
      });

      test('should return false for unavailable email', () async {
        // Arrange
        const email = 'taken@example.com';
        when(() => mockAuthRepository.isEmailAvailable(any()))
            .thenAnswer((_) async => const Result.success(false));

        // Act
        final controller = container.read(authControllerProvider.notifier);
        final isAvailable = await controller.isEmailAvailable(email);

        // Assert
        expect(isAvailable, false);
        verify(() => mockAuthRepository.isEmailAvailable(email)).called(1);
      });

      test('should return false on error', () async {
        // Arrange
        const failure = Failure.network(message: 'Connection failed');
        when(() => mockAuthRepository.isEmailAvailable(any()))
            .thenAnswer((_) async => const Result.failure(failure));

        // Act
        final controller = container.read(authControllerProvider.notifier);
        final isAvailable = await controller.isEmailAvailable('test@example.com');

        // Assert
        expect(isAvailable, false);
      });
    });

    group('Update Profile', () {
      test('should update profile successfully', () async {
        // Arrange
        const displayName = 'New Name';
        const photoURL = 'https://example.com/photo.jpg';

        final updatedUser = UserModel(
          id: TestConstants.mockUserId,
          email: TestConstants.validEmail,
          displayName: displayName,
          photoURL: photoURL,
          createdAt: DateTime.now(),
        );
        final updatedState = AuthState.authenticated(user: updatedUser);

        when(() => mockAuthRepository.updateProfile(
              displayName: any(named: 'displayName'),
              photoURL: any(named: 'photoURL'),
            )).thenAnswer((_) async => Result.success(updatedState));

        // Act
        final controller = container.read(authControllerProvider.notifier);
        await controller.updateProfile(
          displayName: displayName,
          photoURL: photoURL,
        );

        // Assert
        final state = container.read(authControllerProvider);
        expect(state.hasValue, true);
        expect(state.value, updatedState);
        verify(() => mockAuthRepository.updateProfile(
              displayName: displayName,
              photoURL: photoURL,
            )).called(1);
      });

      test('should handle profile update failure', () async {
        // Arrange
        const failure = Failure.network(message: 'Failed to update profile');

        when(() => mockAuthRepository.updateProfile(
              displayName: any(named: 'displayName'),
              photoURL: any(named: 'photoURL'),
            )).thenAnswer((_) async => const Result.failure(failure));

        // Act
        final controller = container.read(authControllerProvider.notifier);
        await controller.updateProfile(displayName: 'New Name');

        // Assert
        final state = container.read(authControllerProvider);
        expect(state.hasError, true);
        expect(state.error, isA<NetworkFailure>());
      });
    });
  });
}
