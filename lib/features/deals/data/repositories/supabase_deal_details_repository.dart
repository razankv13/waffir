import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waffir/core/errors/failures.dart';
import 'package:waffir/core/result/result.dart';
import 'package:waffir/features/deals/data/repositories/deal_details_repository.dart';
import 'package:waffir/features/deals/domain/entities/deal.dart';
import 'package:waffir/features/stores/domain/entities/bank_offer.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';

class SupabaseDealDetailsRepository implements DealDetailsRepository {
  SupabaseDealDetailsRepository(this._client);

  final SupabaseClient _client;

  static const String _productDealsTable = 'product_deals';
  static const String _storeOffersTable = 'store_offers';
  static const String _bankCardOffersTable = 'bank_card_offers';

  @override
  AsyncResult<Deal> fetchProductDealById({
    required String dealId,
    required String languageCode,
  }) async {
    try {
      final row = await _client
          .from(_productDealsTable)
          .select('*')
          .eq('id', dealId)
          .single();
      final data = _normalizeRow(row);
      final isArabic = languageCode.toLowerCase() == 'ar';

      final title = _pickLocalizedText(
        isArabic: isArabic,
        primary: data['title_ar'],
        fallback: data['title'],
      );
      final description = _pickLocalizedText(
        isArabic: isArabic,
        primary: data['description_ar'],
        fallback: data['description'],
      );

      final originalPrice = _toDouble(data['original_price']);
      final discountedPrice = _toDouble(data['discounted_price']);
      final price = discountedPrice ?? originalPrice ?? 0;

      return Result.success(
        Deal(
          id: (data['id'] ?? dealId).toString(),
          title: title ?? '',
          description: description ?? '',
          price: price,
          originalPrice: originalPrice,
          discountPercentage: _toInt(data['discount_percent']),
          imageUrl: _pickImageUrl(data) ?? '',
          brand: data['store_name']?.toString(),
          likesCount: _toInt(data['likes_count']) ?? 0,
          viewsCount: _toInt(data['views_count']) ?? 0,
          isLiked: false,
          isFeatured: true,
          createdAt: _toDateTime(data['created_at']),
          expiresAt: _toDateTime(data['end_date']),
        ),
      );
    } on PostgrestException catch (e) {
      return Result.failure(
        _failureFromPostgrest(
          e,
          fallbackMessage: 'Failed to load deal details',
        ),
      );
    } catch (e, stackTrace) {
      return Result.failure(
        Failure.unknown(
          message: 'Failed to load deal details',
          originalError: e.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  @override
  AsyncResult<StoreOffer> fetchStoreOfferById({
    required String offerId,
    required String languageCode,
  }) async {
    try {
      final row = await _client
          .from(_storeOffersTable)
          .select('*')
          .eq('id', offerId)
          .single();
      final data = _normalizeRow(row);

      return Result.success(
        StoreOffer(
          id: (data['id'] ?? offerId).toString(),
          storeId: (data['store_id'] ?? '').toString(),
          title: (data['title'] ?? '').toString(),
          titleAr: data['title_ar']?.toString(),
          description: data['description']?.toString(),
          descriptionAr: data['description_ar']?.toString(),
          termsText: data['terms_text']?.toString(),
          termsTextAr: data['terms_text_ar']?.toString(),
          discountMinPercent: data['discount_min_percent'] as num?,
          discountMaxPercent: data['discount_max_percent'] as num?,
          promoCode: data['promo_code']?.toString(),
          onlineOrInstore: data['online_or_instore']?.toString(),
          startDate: _toDateTime(data['start_date']),
          endDate: _toDateTime(data['end_date']),
          imageUrl: data['image_url']?.toString(),
          refUrl: data['ref_url']?.toString(),
          popularityScore: _toInt(data['popularity_score']),
          createdAt: _toDateTime(data['created_at']),
        ),
      );
    } on PostgrestException catch (e) {
      return Result.failure(
        _failureFromPostgrest(
          e,
          fallbackMessage: 'Failed to load offer details',
        ),
      );
    } catch (e, stackTrace) {
      return Result.failure(
        Failure.unknown(
          message: 'Failed to load offer details',
          originalError: e.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  @override
  AsyncResult<BankOffer> fetchBankOfferById({
    required String offerId,
    required String languageCode,
  }) async {
    try {
      final row = await _client
          .from(_bankCardOffersTable)
          .select('*')
          .eq('id', offerId)
          .single();
      final data = _normalizeRow(row);

      return Result.success(
        BankOffer(
          id: (data['id'] ?? offerId).toString(),
          bankId: (data['bank_id'] ?? '').toString(),
          bankCardId: data['bank_card_id']?.toString(),
          merchantStoreId: data['merchant_store_id']?.toString(),
          merchantNameText: data['merchant_name_text']?.toString(),
          title: (data['title'] ?? '').toString(),
          titleAr: data['title_ar']?.toString(),
          description: data['description']?.toString(),
          descriptionAr: data['description_ar']?.toString(),
          termsText: data['terms_text']?.toString(),
          termsTextAr: data['terms_text_ar']?.toString(),
          bankName: data['bank_name']?.toString(),
          bankNameAr: data['bank_name_ar']?.toString(),
          bankCardName: data['bank_card_name']?.toString(),
          bankCardNameAr: data['bank_card_name_ar']?.toString(),
          merchantNameAr: data['merchant_name_ar']?.toString(),
          discountMinPercent: data['discount_min_percent'] as num?,
          discountMaxPercent: data['discount_max_percent'] as num?,
          promoCode: data['promo_code']?.toString(),
          onlineOrInstore: data['online_or_instore']?.toString(),
          startDate: _toDateTime(data['start_date']),
          endDate: _toDateTime(data['end_date']),
          imageUrl: data['image_url']?.toString(),
          refUrl: data['ref_url']?.toString(),
          popularityScore: _toInt(data['popularity_score']),
          createdAt: _toDateTime(data['created_at']),
        ),
      );
    } on PostgrestException catch (e) {
      return Result.failure(
        _failureFromPostgrest(
          e,
          fallbackMessage: 'Failed to load offer details',
        ),
      );
    } catch (e, stackTrace) {
      return Result.failure(
        Failure.unknown(
          message: 'Failed to load offer details',
          originalError: e.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  static Map<String, dynamic> _normalizeRow(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.map((key, v) => MapEntry(key.toString(), v));
    throw const Failure.parse(
      message: 'Invalid deal details row.',
      code: 'DEAL_DETAILS_INVALID_ROW',
    );
  }

  static String? _pickLocalizedText({
    required bool isArabic,
    required Object? primary,
    required Object? fallback,
  }) {
    String? normalize(Object? value) {
      final text = value?.toString();
      if (text == null) return null;
      final trimmed = text.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    final primaryText = normalize(primary);
    final fallbackText = normalize(fallback);
    return isArabic
        ? (primaryText ?? fallbackText)
        : (fallbackText ?? primaryText);
  }

  static String? _pickImageUrl(Map<String, dynamic> row) {
    final direct = row['image_url'];
    if (direct is String && direct.trim().isNotEmpty) return direct.trim();

    final urls = row['image_urls'];
    if (urls is List && urls.isNotEmpty) {
      final first = urls.first;
      if (first is String && first.trim().isNotEmpty) return first.trim();
    }
    return null;
  }

  static double? _toDouble(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static int? _toInt(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static DateTime? _toDateTime(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return DateTime.tryParse(value.toString());
  }

  static Failure _failureFromPostgrest(
    PostgrestException exception, {
    required String fallbackMessage,
  }) {
    final message = exception.message;
    final normalized = message.toLowerCase();
    if (normalized.contains('not authenticated')) {
      return Failure.unauthorized(message: message, code: exception.code);
    }

    // Supabase/PostgREST commonly uses PGRST116 for `.single()` when 0 rows are returned.
    if (exception.code == 'PGRST116' ||
        normalized.contains('0 rows') ||
        normalized.contains('results contain 0 rows')) {
      return Failure.notFound(message: fallbackMessage, code: exception.code);
    }

    return Failure.server(message: message, code: exception.code);
  }
}
