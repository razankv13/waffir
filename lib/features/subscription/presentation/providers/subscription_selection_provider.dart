import 'package:flutter_riverpod/legacy.dart';
import 'package:waffir/features/subscription/presentation/widgets/subscription_tab_switcher.dart';
/// UI selection state for the subscription management screen.
class SubscriptionSelectionState {
  const SubscriptionSelectionState({
    this.period = SubscriptionPeriod.monthly,
    this.option = AppSubscriptionOption.individual,
    this.promoCode = '',
  });

  final SubscriptionPeriod period;
  final AppSubscriptionOption option;
  final String promoCode;

  SubscriptionSelectionState copyWith({
    SubscriptionPeriod? period,
    AppSubscriptionOption? option,
    String? promoCode,
  }) {
    return SubscriptionSelectionState(
      period: period ?? this.period,
      option: option ?? this.option,
      promoCode: promoCode ?? this.promoCode,
    );
  }
}

/// Subscription option enum.
enum AppSubscriptionOption { individual, family }

/// StateNotifier controlling subscription selection interactions.
class SubscriptionSelectionNotifier extends StateNotifier<SubscriptionSelectionState> {
  SubscriptionSelectionNotifier() : super(const SubscriptionSelectionState());

  void selectPeriod(SubscriptionPeriod period) {
    state = state.copyWith(period: period);
  }

  void selectOption(AppSubscriptionOption option) {
    state = state.copyWith(option: option);
  }

  void updatePromoCode(String value) {
    state = state.copyWith(promoCode: value);
  }

  void clearPromoCode() {
    state = state.copyWith(promoCode: '');
  }
}

final subscriptionSelectionProvider =
    StateNotifierProvider<SubscriptionSelectionNotifier, SubscriptionSelectionState>(
  (ref) => SubscriptionSelectionNotifier(),
);
