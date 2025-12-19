import 'package:flutter/foundation.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';

@immutable
class OffsetPaginatedListState<T> {
  const OffsetPaginatedListState({
    required this.items,
    required this.searchQuery,
    required this.selectedCategoryId,
    required this.isLoadingInitial,
    required this.isLoadingMore,
    required this.hasMore,
    this.failure,
  });

  const OffsetPaginatedListState.initial()
    : items = const [],
      searchQuery = '',
      selectedCategoryId = null,
      isLoadingInitial = true,
      isLoadingMore = false,
      hasMore = true,
      failure = null;

  final List<T> items;
  final String searchQuery;
  final String? selectedCategoryId;
  final bool isLoadingInitial;
  final bool isLoadingMore;
  final bool hasMore;
  final Failure? failure;

  OffsetPaginatedListState<T> copyWith({
    List<T>? items,
    String? searchQuery,
    String? selectedCategoryId,
    bool? isLoadingInitial,
    bool? isLoadingMore,
    bool? hasMore,
    Failure? failure,
  }) {
    return OffsetPaginatedListState<T>(
      items: items ?? this.items,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      failure: failure,
    );
  }
}

typedef OffsetPageFetcher<T> =
    Future<Result<List<T>>> Function({
      required int limit,
      required int offset,
      String? searchQuery,
      String? categoryId,
    });

class OffsetPaginatedListController<T> {
  const OffsetPaginatedListController({
    required this.fetchPage,
    this.pageSize = 20,
  });

  final OffsetPageFetcher<T> fetchPage;
  final int pageSize;

  OffsetPaginatedListState<T> resetForQuery({
    required OffsetPaginatedListState<T> current,
    required String searchQuery,
    required String? categoryId,
  }) {
    return current.copyWith(
      searchQuery: searchQuery,
      selectedCategoryId: categoryId,
      items: const [],
      isLoadingInitial: true,
      isLoadingMore: false,
      hasMore: true,
      failure: null,
    );
  }

  Future<OffsetPaginatedListState<T>> loadInitial(
    OffsetPaginatedListState<T> current,
  ) async {
    if (current.isLoadingInitial) {
      // Still allow re-entry if state is "initial" and has no items yet.
    }

    final result = await fetchPage(
      limit: pageSize,
      offset: 0,
      searchQuery: current.searchQuery.isEmpty ? null : current.searchQuery,
      categoryId: current.selectedCategoryId,
    );

    return result.when(
      success: (items) => current.copyWith(
        items: items,
        isLoadingInitial: false,
        hasMore: items.length == pageSize,
        failure: null,
      ),
      failure: (failure) => current.copyWith(
        items: const [],
        isLoadingInitial: false,
        hasMore: false,
        failure: failure,
      ),
    );
  }

  Future<OffsetPaginatedListState<T>> loadMore(
    OffsetPaginatedListState<T> current,
  ) async {
    if (current.isLoadingInitial || current.isLoadingMore || !current.hasMore) {
      return current;
    }

    final loading = current.copyWith(isLoadingMore: true, failure: null);

    final result = await fetchPage(
      limit: pageSize,
      offset: current.items.length,
      searchQuery: current.searchQuery.isEmpty ? null : current.searchQuery,
      categoryId: current.selectedCategoryId,
    );

    return result.when(
      success: (items) => loading.copyWith(
        items: [...loading.items, ...items],
        isLoadingMore: false,
        hasMore: items.length == pageSize,
        failure: null,
      ),
      failure: (failure) => loading.copyWith(
        isLoadingMore: false,
        hasMore: false,
        failure: failure,
      ),
    );
  }

  Future<OffsetPaginatedListState<T>> applySearch(
    OffsetPaginatedListState<T> current, {
    required String searchQuery,
  }) async {
    final normalized = searchQuery.trim();
    if (normalized == current.searchQuery) return current;

    final reset = resetForQuery(
      current: current,
      searchQuery: normalized,
      categoryId: current.selectedCategoryId,
    );
    return loadInitial(reset);
  }

  Future<OffsetPaginatedListState<T>> applyCategoryFilter(
    OffsetPaginatedListState<T> current, {
    required String? categoryId,
  }) async {
    final normalized = (categoryId == null || categoryId.trim().isEmpty)
        ? null
        : categoryId.trim();
    if (normalized == current.selectedCategoryId) return current;

    final reset = resetForQuery(
      current: current,
      searchQuery: current.searchQuery,
      categoryId: normalized,
    );
    return loadInitial(reset);
  }
}

