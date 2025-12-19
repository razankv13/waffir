import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/features/profile/domain/entities/user_profile.dart';

part 'profile_state.freezed.dart';

/// Immutable state for profile feature.
///
/// Holds the user profile data along with saving status and error info.
@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    required UserProfile profile,
    @Default(false) bool isSaving,
    Failure? lastError,
  }) = _ProfileState;

  const ProfileState._();

  /// Check if profile is currently being saved.
  bool get isLoading => isSaving;

  /// Check if there was an error in the last operation.
  bool get hasError => lastError != null;
}
