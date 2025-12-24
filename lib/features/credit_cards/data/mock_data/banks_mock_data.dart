import 'package:waffir/features/credit_cards/data/models/bank_model.dart';
import 'package:waffir/features/credit_cards/data/models/credit_card_model.dart';

/// Mock data for banks (matches Supabase `banks` table schema)
class BanksMockData {
  static List<BankModel> get banks => [
        const BankModel(
          id: 'bank-snb-001',
          name: 'Saudi National Bank',
          nameAr: 'البنك الأهلي السعودي',
          logoUrl: 'https://logo.clearbit.com/alahli.com',
        ),
        const BankModel(
          id: 'bank-rajhi-002',
          name: 'Al Rajhi Bank',
          nameAr: 'مصرف الراجحي',
          logoUrl: 'https://logo.clearbit.com/alrajhibank.com.sa',
        ),
        const BankModel(
          id: 'bank-riyad-003',
          name: 'Riyad Bank',
          nameAr: 'بنك الرياض',
          logoUrl: 'https://logo.clearbit.com/riyadbank.com',
        ),
        const BankModel(
          id: 'bank-alinma-004',
          name: 'Alinma Bank',
          nameAr: 'مصرف الإنماء',
          logoUrl: 'https://logo.clearbit.com/alinma.com',
        ),
        const BankModel(
          id: 'bank-sabb-005',
          name: 'SABB',
          nameAr: 'ساب',
          logoUrl: 'https://logo.clearbit.com/sabb.com',
        ),
        const BankModel(
          id: 'bank-saib-006',
          name: 'Saudi Investment Bank',
          nameAr: 'البنك السعودي للاستثمار',
          logoUrl: 'https://logo.clearbit.com/saib.com.sa',
        ),
        const BankModel(
          id: 'bank-anb-007',
          name: 'Arab National Bank',
          nameAr: 'البنك العربي الوطني',
          logoUrl: 'https://logo.clearbit.com/anb.com.sa',
        ),
        const BankModel(
          id: 'bank-baj-008',
          name: 'Bank AlJazira',
          nameAr: 'بنك الجزيرة',
          logoUrl: 'https://logo.clearbit.com/baj.com.sa',
        ),
        const BankModel(
          id: 'bank-albilad-009',
          name: 'Bank Albilad',
          nameAr: 'بنك البلاد',
          logoUrl: 'https://logo.clearbit.com/bankalbilad.com',
        ),
        const BankModel(
          id: 'bank-gib-010',
          name: 'Gulf International Bank',
          nameAr: 'بنك الخليج الدولي',
          logoUrl: 'https://logo.clearbit.com/gib.com',
        ),
        const BankModel(
          id: 'bank-stc-011',
          name: 'STC Pay',
          nameAr: 'اس تي سي باي',
          logoUrl: 'https://logo.clearbit.com/stcpay.com.sa',
        ),
      ];

  /// Get bank by ID
  static BankModel? getBankById(String id) {
    try {
      return banks.firstWhere((bank) => bank.id == id);
    } catch (e) {
      return null;
    }
  }
}

/// Mock data for bank cards (matches Supabase `bank_cards` table with `banks` join)
class BankCardsMockData {
  static List<BankCardModel> get bankCards => [
        // Saudi National Bank Cards
        const BankCardModel(
          id: 'card-snb-signature-001',
          bankId: 'bank-snb-001',
          nameEn: 'Signature Card',
          nameAr: 'بطاقة سيجنتشر',
          imageUrl: 'https://images.unsplash.com/photo-1556742212-5b321f3c261b?w=400',
          accountTypeId: 1,
          cardTypeId: 1,
          bankName: 'Saudi National Bank',
          bankNameAr: 'البنك الأهلي السعودي',
          bankLogoUrl: 'https://logo.clearbit.com/alahli.com',
        ),
        const BankCardModel(
          id: 'card-snb-platinum-002',
          bankId: 'bank-snb-001',
          nameEn: 'Platinum Card',
          nameAr: 'بطاقة بلاتينيوم',
          accountTypeId: 1,
          cardTypeId: 2,
          bankName: 'Saudi National Bank',
          bankNameAr: 'البنك الأهلي السعودي',
          bankLogoUrl: 'https://logo.clearbit.com/alahli.com',
        ),
        const BankCardModel(
          id: 'card-snb-gold-003',
          bankId: 'bank-snb-001',
          nameEn: 'Gold Card',
          nameAr: 'بطاقة ذهبية',
          accountTypeId: 1,
          cardTypeId: 3,
          bankName: 'Saudi National Bank',
          bankNameAr: 'البنك الأهلي السعودي',
          bankLogoUrl: 'https://logo.clearbit.com/alahli.com',
        ),

        // Al Rajhi Bank Cards
        const BankCardModel(
          id: 'card-rajhi-titanium-001',
          bankId: 'bank-rajhi-002',
          nameEn: 'Titanium Card',
          nameAr: 'بطاقة تيتانيوم',
          imageUrl: 'https://images.unsplash.com/photo-1589578527966-fdac0f44566c?w=400',
          accountTypeId: 1,
          cardTypeId: 4,
          bankName: 'Al Rajhi Bank',
          bankNameAr: 'مصرف الراجحي',
          bankLogoUrl: 'https://logo.clearbit.com/alrajhibank.com.sa',
        ),
        const BankCardModel(
          id: 'card-rajhi-mada-002',
          bankId: 'bank-rajhi-002',
          nameEn: 'Mada Debit Card',
          nameAr: 'بطاقة مدى',
          accountTypeId: 2,
          cardTypeId: 5,
          bankName: 'Al Rajhi Bank',
          bankNameAr: 'مصرف الراجحي',
          bankLogoUrl: 'https://logo.clearbit.com/alrajhibank.com.sa',
        ),
        const BankCardModel(
          id: 'card-rajhi-world-003',
          bankId: 'bank-rajhi-002',
          nameEn: 'World Mastercard',
          nameAr: 'ماستركارد العالمية',
          accountTypeId: 1,
          cardTypeId: 6,
          bankName: 'Al Rajhi Bank',
          bankNameAr: 'مصرف الراجحي',
          bankLogoUrl: 'https://logo.clearbit.com/alrajhibank.com.sa',
        ),

        // Riyad Bank Cards
        const BankCardModel(
          id: 'card-riyad-elite-001',
          bankId: 'bank-riyad-003',
          nameEn: 'World Elite Mastercard',
          nameAr: 'ماستركارد العالمية إيليت',
          imageUrl: 'https://images.unsplash.com/photo-1565373679003-82a9119bfd85?w=400',
          accountTypeId: 1,
          cardTypeId: 7,
          bankName: 'Riyad Bank',
          bankNameAr: 'بنك الرياض',
          bankLogoUrl: 'https://logo.clearbit.com/riyadbank.com',
        ),
        const BankCardModel(
          id: 'card-riyad-visa-002',
          bankId: 'bank-riyad-003',
          nameEn: 'Visa Infinite',
          nameAr: 'فيزا إنفينيت',
          accountTypeId: 1,
          cardTypeId: 8,
          bankName: 'Riyad Bank',
          bankNameAr: 'بنك الرياض',
          bankLogoUrl: 'https://logo.clearbit.com/riyadbank.com',
        ),

        // Alinma Bank Cards
        const BankCardModel(
          id: 'card-alinma-mumayaz-001',
          bankId: 'bank-alinma-004',
          nameEn: 'Mumayaz Card',
          nameAr: 'بطاقة مميز',
          imageUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=400',
          accountTypeId: 1,
          cardTypeId: 3,
          bankName: 'Alinma Bank',
          bankNameAr: 'مصرف الإنماء',
          bankLogoUrl: 'https://logo.clearbit.com/alinma.com',
        ),
        const BankCardModel(
          id: 'card-alinma-basma-002',
          bankId: 'bank-alinma-004',
          nameEn: 'Basma Card',
          nameAr: 'بطاقة بسمة',
          accountTypeId: 1,
          cardTypeId: 9,
          bankName: 'Alinma Bank',
          bankNameAr: 'مصرف الإنماء',
          bankLogoUrl: 'https://logo.clearbit.com/alinma.com',
        ),

        // SABB Cards
        const BankCardModel(
          id: 'card-sabb-first-001',
          bankId: 'bank-sabb-005',
          nameEn: 'First Card',
          nameAr: 'البطاقة الأولى',
          imageUrl: 'https://images.unsplash.com/photo-1559526324-593bc073d938?w=400',
          accountTypeId: 1,
          cardTypeId: 10,
          bankName: 'SABB',
          bankNameAr: 'ساب',
          bankLogoUrl: 'https://logo.clearbit.com/sabb.com',
        ),
        const BankCardModel(
          id: 'card-sabb-advance-002',
          bankId: 'bank-sabb-005',
          nameEn: 'SABB Advance',
          nameAr: 'ساب أدفانس',
          accountTypeId: 1,
          cardTypeId: 2,
          bankName: 'SABB',
          bankNameAr: 'ساب',
          bankLogoUrl: 'https://logo.clearbit.com/sabb.com',
        ),

        // Saudi Investment Bank Cards
        const BankCardModel(
          id: 'card-saib-visa-001',
          bankId: 'bank-saib-006',
          nameEn: 'Visa Platinum',
          nameAr: 'فيزا بلاتينيوم',
          accountTypeId: 1,
          cardTypeId: 2,
          bankName: 'Saudi Investment Bank',
          bankNameAr: 'البنك السعودي للاستثمار',
          bankLogoUrl: 'https://logo.clearbit.com/saib.com.sa',
        ),

        // Arab National Bank Cards
        const BankCardModel(
          id: 'card-anb-world-001',
          bankId: 'bank-anb-007',
          nameEn: 'World Card',
          nameAr: 'بطاقة العالم',
          accountTypeId: 1,
          cardTypeId: 6,
          bankName: 'Arab National Bank',
          bankNameAr: 'البنك العربي الوطني',
          bankLogoUrl: 'https://logo.clearbit.com/anb.com.sa',
        ),

        // Bank AlJazira Cards
        const BankCardModel(
          id: 'card-baj-platinum-001',
          bankId: 'bank-baj-008',
          nameEn: 'Platinum Card',
          nameAr: 'بطاقة بلاتينيوم',
          accountTypeId: 1,
          cardTypeId: 2,
          bankName: 'Bank AlJazira',
          bankNameAr: 'بنك الجزيرة',
          bankLogoUrl: 'https://logo.clearbit.com/baj.com.sa',
        ),

        // Bank Albilad Cards
        const BankCardModel(
          id: 'card-albilad-rewards-001',
          bankId: 'bank-albilad-009',
          nameEn: 'Rewards Card',
          nameAr: 'بطاقة المكافآت',
          accountTypeId: 1,
          cardTypeId: 3,
          bankName: 'Bank Albilad',
          bankNameAr: 'بنك البلاد',
          bankLogoUrl: 'https://logo.clearbit.com/bankalbilad.com',
        ),

        // STC Pay Cards
        const BankCardModel(
          id: 'card-stc-mada-001',
          bankId: 'bank-stc-011',
          nameEn: 'STC Pay Mada',
          nameAr: 'اس تي سي باي مدى',
          accountTypeId: 2,
          cardTypeId: 5,
          bankName: 'STC Pay',
          bankNameAr: 'اس تي سي باي',
          bankLogoUrl: 'https://logo.clearbit.com/stcpay.com.sa',
        ),
      ];

  /// Get cards by bank ID
  static List<BankCardModel> getCardsByBankId(String bankId) {
    return bankCards.where((card) => card.bankId == bankId).toList();
  }

  /// Get card by ID
  static BankCardModel? getCardById(String id) {
    try {
      return bankCards.firstWhere((card) => card.id == id);
    } catch (e) {
      return null;
    }
  }
}

/// Legacy alias for backwards compatibility
typedef CreditCardsMockData = BankCardsMockData;
