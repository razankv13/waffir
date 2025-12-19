import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:postgrest/postgrest.dart' as pg;
import 'package:supabase/supabase.dart' as supa;
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:waffir/features/deals/data/datasources/supabase_deals_remote_data_source.dart';

class _MockSupabaseClient extends Mock implements sb.SupabaseClient {}

class _MockGoTrueClient extends Mock implements sb.GoTrueClient {}

class _MockSupabaseQueryBuilder extends Mock implements supa.SupabaseQueryBuilder {}

class _MockPostgrestFilterBuilder extends Mock implements pg.PostgrestFilterBuilder<dynamic> {}

class _MockStoresSelectBuilder extends Mock
    implements pg.PostgrestFilterBuilder<List<Map<String, dynamic>>> {}

class _MockLikesSelectBuilder extends Mock implements pg.PostgrestFilterBuilder<List<Map<String, dynamic>>> {}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(<String>[]);
  });

  group('SupabaseDealsRemoteDataSource', () {
    test('fetchHotDeals calls get_frontpage_products with p_limit/p_offset, hydrates store name, and maps rows', () async {
      final client = _MockSupabaseClient();
      final auth = _MockGoTrueClient();
      final storesQuery = _MockSupabaseQueryBuilder();
      final storesSelect = _MockStoresSelectBuilder();
      final frontpageBuilder = _MockPostgrestFilterBuilder();

      when(() => client.auth).thenReturn(auth);
      when(() => auth.currentUser).thenReturn(null);

      when(() => frontpageBuilder.then<dynamic>(any(), onError: any(named: 'onError'))).thenAnswer((invocation) {
        final onValue = invocation.positionalArguments.first as dynamic;
        return Future<dynamic>.value(onValue([
          {
            'id': '00000000-0000-0000-0000-000000000001',
            'store_id': '00000000-0000-0000-0000-0000000000aa',
            'title': 'English Title',
            'title_ar': 'عنوان عربي',
            'description': 'English Desc',
            'description_ar': 'وصف عربي',
            'original_price': 100,
            'discounted_price': 70,
            'discount_percent': 30,
            'image_url': 'https://example.com/1.png',
            'likes_count': 42,
            'views_count': 7,
            'created_at': '2025-01-01T00:00:00.000Z',
            'end_date': '2025-02-01T00:00:00.000Z',
          },
          {
            'id': '00000000-0000-0000-0000-000000000002',
            'title': 'T2',
            'description': 'D2',
            'original_price': '99.5',
            'discounted_price': null,
            'discount_percent': '10',
            'image_url': null,
            'image_urls': ['https://example.com/2.png'],
            'likes_count': '0',
            'views_count': null,
            'created_at': null,
            'end_date': null,
          },
        ]));
      });
      when(() => client.rpc('get_frontpage_products', params: any(named: 'params'))).thenAnswer((_) => frontpageBuilder);

      when(() => client.from('stores')).thenAnswer((_) => storesQuery);
      when(() => storesQuery.select('id,name,name_ar')).thenAnswer((_) => storesSelect);
      when(() => storesSelect.inFilter('id', any())).thenAnswer((_) => storesSelect);
      when(() => storesSelect.then<dynamic>(any(), onError: any(named: 'onError'))).thenAnswer((invocation) {
        final onValue = invocation.positionalArguments.first as dynamic;
        return Future<dynamic>.value(
          onValue([
            {
              'id': '00000000-0000-0000-0000-0000000000aa',
              'name': 'Nike Store',
              'name_ar': 'متجر نايك',
            },
          ]),
        );
      });

      final dataSource = SupabaseDealsRemoteDataSource(client);
      final deals = await dataSource.fetchHotDeals(languageCode: 'en', limit: 20, offset: 0);

      verify(
        () => client.rpc(
          'get_frontpage_products',
          params: {'p_limit': 20, 'p_offset': 0},
        ),
      ).called(1);

      verify(() => client.from('stores')).called(1);
      verify(() => storesQuery.select('id,name,name_ar')).called(1);
      verify(() => storesSelect.inFilter('id', any())).called(1);

      expect(deals, hasLength(2));
      expect(deals.first.id, '00000000-0000-0000-0000-000000000001');
      expect(deals.first.title, 'English Title');
      expect(deals.first.description, 'English Desc');
      expect(deals.first.price, 70);
      expect(deals.first.originalPrice, 100);
      expect(deals.first.discountPercentage, 30);
      expect(deals.first.brand, 'Nike Store');
      expect(deals.first.likesCount, 42);
      expect(deals.first.viewsCount, 7);
      expect(deals.first.isLiked, isFalse);

      expect(deals.last.id, '00000000-0000-0000-0000-000000000002');
      expect(deals.last.price, 99.5);
      expect(deals.last.originalPrice, 99.5);
      expect(deals.last.discountPercentage, 10);
      expect(deals.last.imageUrl, 'https://example.com/2.png');
      expect(deals.last.likesCount, 0);
      expect(deals.last.viewsCount, 0);
    });

    test('fetchHotDeals uses Arabic store name when languageCode=ar', () async {
      final client = _MockSupabaseClient();
      final auth = _MockGoTrueClient();
      final storesQuery = _MockSupabaseQueryBuilder();
      final storesSelect = _MockStoresSelectBuilder();
      final frontpageBuilder = _MockPostgrestFilterBuilder();

      when(() => client.auth).thenReturn(auth);
      when(() => auth.currentUser).thenReturn(null);

      when(() => frontpageBuilder.then<dynamic>(any(), onError: any(named: 'onError'))).thenAnswer((invocation) {
        final onValue = invocation.positionalArguments.first as dynamic;
        return Future<dynamic>.value(onValue([
          {
            'id': '00000000-0000-0000-0000-000000000001',
            'store_id': '00000000-0000-0000-0000-0000000000aa',
            'title': 'English Title',
            'title_ar': 'عنوان عربي',
            'description': 'English Desc',
            'description_ar': 'وصف عربي',
            'original_price': 100,
            'discounted_price': 70,
            'discount_percent': 30,
            'image_url': 'https://example.com/1.png',
            'likes_count': 42,
            'views_count': 7,
          },
        ]));
      });
      when(() => client.rpc('get_frontpage_products', params: any(named: 'params'))).thenAnswer((_) => frontpageBuilder);

      when(() => client.from('stores')).thenAnswer((_) => storesQuery);
      when(() => storesQuery.select('id,name,name_ar')).thenAnswer((_) => storesSelect);
      when(() => storesSelect.inFilter('id', any())).thenAnswer((_) => storesSelect);
      when(() => storesSelect.then<dynamic>(any(), onError: any(named: 'onError'))).thenAnswer((invocation) {
        final onValue = invocation.positionalArguments.first as dynamic;
        return Future<dynamic>.value(
          onValue([
            {
              'id': '00000000-0000-0000-0000-0000000000aa',
              'name': 'Nike Store',
              'name_ar': 'متجر نايك',
            },
          ]),
        );
      });

      final dataSource = SupabaseDealsRemoteDataSource(client);
      final deals = await dataSource.fetchHotDeals(languageCode: 'ar', limit: 20, offset: 0);

      expect(deals, hasLength(1));
      expect(deals.first.brand, 'متجر نايك');
      expect(deals.first.title, 'عنوان عربي');
      expect(deals.first.description, 'وصف عربي');
    });

    test('fetchHotDeals hydrates liked ids when authenticated', () async {
      final client = _MockSupabaseClient();
      final auth = _MockGoTrueClient();
      final likesQuery = _MockSupabaseQueryBuilder();
      final likesSelect = _MockLikesSelectBuilder();
      final frontpageBuilder = _MockPostgrestFilterBuilder();

      const user = sb.User(
        id: 'user-1',
        appMetadata: <String, dynamic>{},
        userMetadata: <String, dynamic>{},
        aud: 'authenticated',
        createdAt: '2025-01-01T00:00:00.000Z',
      );

      when(() => client.auth).thenReturn(auth);
      when(() => auth.currentUser).thenReturn(user);

      when(() => frontpageBuilder.then<dynamic>(any(), onError: any(named: 'onError'))).thenAnswer((invocation) {
        final onValue = invocation.positionalArguments.first as dynamic;
        return Future<dynamic>.value(onValue([
          {
            'id': '00000000-0000-0000-0000-000000000001',
            'title': 'T1',
            'description': 'D1',
            'original_price': 100,
            'discounted_price': 90,
            'discount_percent': 10,
            'image_url': 'https://example.com/1.png',
            'likes_count': 1,
            'views_count': 1,
          },
          {
            'id': '00000000-0000-0000-0000-000000000002',
            'title': 'T2',
            'description': 'D2',
            'original_price': 50,
            'discounted_price': 40,
            'discount_percent': 20,
            'image_url': 'https://example.com/2.png',
            'likes_count': 2,
            'views_count': 3,
          },
        ]));
      });
      when(() => client.rpc('get_frontpage_products', params: any(named: 'params'))).thenAnswer((_) => frontpageBuilder);

      when(() => client.from('user_deal_likes')).thenAnswer((_) => likesQuery);
      when(() => likesQuery.select('deal_id')).thenAnswer((_) => likesSelect);
      when(() => likesSelect.eq('user_id', any())).thenAnswer((_) => likesSelect);
      when(() => likesSelect.eq('deal_type', any())).thenAnswer((_) => likesSelect);
      when(() => likesSelect.inFilter('deal_id', any())).thenAnswer((_) => likesSelect);
      when(() => likesSelect.then<dynamic>(any(), onError: any(named: 'onError'))).thenAnswer((invocation) {
        final onValue = invocation.positionalArguments.first as dynamic;
        return Future<dynamic>.value(
          onValue([
            {'deal_id': '00000000-0000-0000-0000-000000000002'},
          ]),
        );
      });

      final dataSource = SupabaseDealsRemoteDataSource(client);
      final deals = await dataSource.fetchHotDeals(languageCode: 'en', limit: 20, offset: 0);

      expect(deals, hasLength(2));
      expect(deals.first.id, '00000000-0000-0000-0000-000000000001');
      expect(deals.first.isLiked, isFalse);
      expect(deals.last.id, '00000000-0000-0000-0000-000000000002');
      expect(deals.last.isLiked, isTrue);
    });
  });
}

