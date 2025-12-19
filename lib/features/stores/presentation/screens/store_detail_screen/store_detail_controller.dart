import 'package:flutter_riverpod/legacy.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';

final storeDetailUiControllerProvider = StateNotifierProvider.autoDispose
    .family<StoreDetailUiController, StoreDetailUiState, String>(
      (ref, _) => StoreDetailUiController(),
    );

class StoreDetailUiController extends StateNotifier<StoreDetailUiState> {
  StoreDetailUiController() : super(StoreDetailUiState.initial());

  void seedFromStore(StoreModel store) {
    if (state.hasSeededFromStore) {
      return;
    }

    state = state.copyWith(
      isFollowing: store.isFollowing,
      hasSeededFromStore: true,
    );
  }

  void toggleFavorite() {
    state = state.copyWith(isFavorite: !state.isFavorite);
  }

  void setFavorite(bool value) {
    state = state.copyWith(isFavorite: value);
  }

  void toggleFollowing() {
    state = state.copyWith(isFollowing: !state.isFollowing);
  }
}

class StoreDetailUiState {
  const StoreDetailUiState({
    required this.isFavorite,
    required this.isFollowing,
    required this.hasSeededFromStore,
    required this.testimonials,
  });

  factory StoreDetailUiState.initial() {
    return const StoreDetailUiState(
      isFavorite: false,
      isFollowing: false,
      hasSeededFromStore: false,
      testimonials: [
        StoreTestimonial(
          author: 'Omar',
          body:
              'We were only sad not to stay longer. Service was smooth and the staff was super helpful. We will definitely be back.',
          location: 'Riyadh, Saudi Arabia',
        ),
        StoreTestimonial(
          author: 'Sara',
          body:
              'The location was perfect for us and the curated deals saved me a lot. Loved the in-store pickup experience!',
          location: 'Jeddah, Saudi Arabia',
        ),
        StoreTestimonial(
          author: 'Ali',
          body:
              'Nice assortment with good availability. Communication with the store team was quick and friendly.',
          location: 'Dammam, Saudi Arabia',
        ),
        StoreTestimonial(
          author: 'Emma',
          body:
              'We were only sad not to stay longer. We hope to be back to explore Nantes some more and would love to stay again! :)',
          location: 'May 2023',
        ),
      ],
    );
  }

  final bool isFavorite;
  final bool isFollowing;
  final bool hasSeededFromStore;
  final List<StoreTestimonial> testimonials;

  StoreDetailUiState copyWith({
    bool? isFavorite,
    bool? isFollowing,
    bool? hasSeededFromStore,
    List<StoreTestimonial>? testimonials,
  }) {
    return StoreDetailUiState(
      isFavorite: isFavorite ?? this.isFavorite,
      isFollowing: isFollowing ?? this.isFollowing,
      hasSeededFromStore: hasSeededFromStore ?? this.hasSeededFromStore,
      testimonials: testimonials ?? this.testimonials,
    );
  }
}

class StoreTestimonial {
  const StoreTestimonial({
    required this.author,
    required this.body,
    required this.location,
  });

  final String author;
  final String body;
  final String location;
}
