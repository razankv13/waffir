import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'manage_subscription_controller.freezed.dart';
part 'manage_subscription_controller.g.dart';

@freezed
abstract class SubscriptionSavings with _$SubscriptionSavings {
  const factory SubscriptionSavings({
    required double totalSavings,
    required List<double> monthlySavings,
  }) = _SubscriptionSavings;
}

@freezed
abstract class SubscriptionPlan with _$SubscriptionPlan {
  const factory SubscriptionPlan({
    required String name,
    required String priceDescription,
    required String renewalDate,
    required String features,
  }) = _SubscriptionPlan;
}

@freezed
abstract class FamilyMember with _$FamilyMember {
  const factory FamilyMember({
    required String id,
    required String name,
    required String role,
    required String status,
    required String initials,
    required bool isPending,
    required bool hasError,
    // Using string for colors for now as this is likely coming from backend eventually,
    // but for UI consistency we might map them in the UI or use enums.
    // For this refactor, let's stick to the data needed.
  }) = _FamilyMember;
}

@freezed
abstract class ManageSubscriptionState with _$ManageSubscriptionState {
  const factory ManageSubscriptionState({
    required SubscriptionSavings savings,
    required SubscriptionPlan plan,
    required List<FamilyMember> familyMembers,
    required int maxFamilyMembers,
  }) = _ManageSubscriptionState;
}

@riverpod
class ManageSubscriptionController extends _$ManageSubscriptionController {
  @override
  FutureOr<ManageSubscriptionState> build() {
    // Simulating API call / loading initial data
    return _fetchSubscriptionData();
  }

  Future<ManageSubscriptionState> _fetchSubscriptionData() async {
    // Simulate delay
    await Future.delayed(const Duration(milliseconds: 500));

    return const ManageSubscriptionState(
      savings: SubscriptionSavings(totalSavings: 428, monthlySavings: [72, 156, 113, 187]),
      plan: SubscriptionPlan(
        name: 'Family Annual Plan',
        priceDescription: '\$79.99/year (33% off monthly)',
        renewalDate: 'Dec 15, 2023',
        features: 'Unlimited deals, Family sharing (up to 5)',
      ),
      maxFamilyMembers: 5,
      familyMembers: [
        FamilyMember(
          id: '1',
          name: 'You (Sarah)',
          role: 'Primary Account',
          status: 'Active',
          initials: 'YS',
          isPending: false,
          hasError: false,
        ),
        FamilyMember(
          id: 'error_placeholder', // The red circle equivalent
          name: '',
          role: '',
          status: '',
          initials: '',
          isPending: false,
          hasError: true,
        ),
        FamilyMember(
          id: '2',
          name: 'Emma Miller',
          role: 'Daughter',
          status: 'Pending',
          initials: 'EM',
          isPending: true,
          hasError: false,
        ),
        FamilyMember(
          id: '3',
          name: 'Liam Miller',
          role: 'Son',
          status: 'Active',
          initials: 'LM',
          isPending: false,
          hasError: false,
        ),
      ],
    );
  }

  Future<void> cancelSubscription() async {
    // TODO: Implement cancel subscription logic
    print('Cancel subscription requested');
  }

  Future<void> changePlan() async {
    // TODO: Implement change plan logic
    print('Change plan requested');
  }

  Future<void> addFamilyMember() async {
    // TODO: Implement add family member logic
    print('Add family member requested');
  }
}
