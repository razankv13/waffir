import '../models/bank_model.dart';
import '../models/credit_card_model.dart';

/// Mock data for banks
class BanksMockData {
  static List<BankModel> get banks => [
        const BankModel(
          id: '1',
          name: 'Saudi National Bank',
          nameAr: 'البنك الأهلي السعودي',
          logoUrl: 'https://images.unsplash.com/photo-1541354329998-f4d9a9f9297f?w=400',
          description: 'The largest bank in Saudi Arabia',
          website: 'https://www.alahli.com',
          phoneNumber: '+966 920000232',
          cardTypes: ['Credit', 'Debit', 'Prepaid'],
          isPopular: true,
        ),

        const BankModel(
          id: '2',
          name: 'Al Rajhi Bank',
          nameAr: 'مصرف الراجحي',
          logoUrl: 'https://images.unsplash.com/photo-1589578527966-fdac0f44566c?w=400',
          description: 'Leading Islamic bank',
          website: 'https://www.alrajhibank.com.sa',
          phoneNumber: '+966 920003344',
          cardTypes: ['Credit', 'Debit'],
          isPopular: true,
        ),

        const BankModel(
          id: '3',
          name: 'Riyad Bank',
          nameAr: 'بنك الرياض',
          logoUrl: 'https://images.unsplash.com/photo-1565373679003-82a9119bfd85?w=400',
          description: 'One of the oldest Saudi banks',
          website: 'https://www.riyadbank.com',
          phoneNumber: '+966 920002470',
          cardTypes: ['Credit', 'Debit', 'Corporate'],
          isPopular: true,
        ),

        const BankModel(
          id: '4',
          name: 'Alinma Bank',
          nameAr: 'مصرف الإنماء',
          logoUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=400',
          description: 'Sharia-compliant banking',
          website: 'https://www.alinma.com',
          phoneNumber: '+966 920000232',
          cardTypes: ['Credit', 'Debit'],
          isPopular: false,
        ),

        const BankModel(
          id: '5',
          name: 'SABB',
          nameAr: 'ساب',
          logoUrl: 'https://images.unsplash.com/photo-1559526324-593bc073d938?w=400',
          description: 'The Saudi British Bank',
          website: 'https://www.sabb.com',
          phoneNumber: '+966 920008888',
          cardTypes: ['Credit', 'Debit', 'Business'],
          isPopular: true,
        ),

        const BankModel(
          id: '6',
          name: 'Saudi Investment Bank',
          nameAr: 'البنك السعودي للاستثمار',
          logoUrl: 'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=400',
          description: 'Investment and banking solutions',
          website: 'https://www.saib.com.sa',
          phoneNumber: '+966 920001595',
          cardTypes: ['Credit', 'Debit'],
          isPopular: false,
        ),

        const BankModel(
          id: '7',
          name: 'Arab National Bank',
          nameAr: 'البنك العربي الوطني',
          logoUrl: 'https://images.unsplash.com/photo-1553729459-efe14ef6055d?w=400',
          description: 'Trusted banking partner',
          website: 'https://www.anb.com.sa',
          phoneNumber: '+966 920003456',
          cardTypes: ['Credit', 'Debit'],
          isPopular: false,
        ),

        const BankModel(
          id: '8',
          name: 'Bank AlJazira',
          nameAr: 'بنك الجزيرة',
          logoUrl: 'https://images.unsplash.com/photo-1599508704512-2f19efd1e35f?w=400',
          description: 'Modern Islamic banking',
          website: 'https://www.baj.com.sa',
          phoneNumber: '+966 920002229',
          cardTypes: ['Credit', 'Debit'],
          isPopular: false,
        ),

        const BankModel(
          id: '9',
          name: 'Bank Albilad',
          nameAr: 'بنك البلاد',
          logoUrl: 'https://images.unsplash.com/photo-1550565118-3a14e8d0386f?w=400',
          description: 'Innovative banking services',
          website: 'https://www.bankalbilad.com',
          phoneNumber: '+966 920003344',
          cardTypes: ['Credit', 'Debit'],
          isPopular: false,
        ),

        const BankModel(
          id: '10',
          name: 'Gulf International Bank',
          nameAr: 'بنك الخليج الدولي',
          logoUrl: 'https://images.unsplash.com/photo-1612178991541-b48cc8e92a4d?w=400',
          description: 'International banking',
          website: 'https://www.gib.com',
          phoneNumber: '+966 920001000',
          cardTypes: ['Credit', 'Business'],
          isPopular: false,
        ),
      ];

  /// Get popular banks
  static List<BankModel> get popularBanks => banks.where((bank) => bank.isPopular == true).toList();

  /// Get bank by ID
  static BankModel? getBankById(String id) {
    try {
      return banks.firstWhere((bank) => bank.id == id);
    } catch (e) {
      return null;
    }
  }
}

/// Mock data for credit card offers
class CreditCardsMockData {
  static List<CreditCardModel> get creditCards => [
        const CreditCardModel(
          id: 'cc1',
          bankId: '1',
          bankName: 'Saudi National Bank',
          cardName: 'Signature Card',
          cardType: 'Platinum',
          imageUrl: 'https://images.unsplash.com/photo-1556742212-5b321f3c261b?w=400',
          description: 'Premium rewards and benefits',
          benefits: [
            'Up to 5% cashback on dining',
            'Airport lounge access',
            'Free travel insurance',
            'Complimentary concierge',
          ],
          cashbackPercentage: 5.0,
          rewardPoints: 100,
          annualFee: 1200,
          isPopular: true,
          isFeatured: true,
          applyUrl: 'https://www.alahli.com/apply',
        ),

        const CreditCardModel(
          id: 'cc2',
          bankId: '2',
          bankName: 'Al Rajhi Bank',
          cardName: 'Titanium Card',
          cardType: 'Titanium',
          imageUrl: 'https://images.unsplash.com/photo-1589578527966-fdac0f44566c?w=400',
          description: 'Sharia-compliant rewards',
          benefits: [
            'Earn points on every purchase',
            'No interest charges',
            'Travel rewards',
            'Purchase protection',
          ],
          rewardPoints: 80,
          annualFee: 0,
          isPopular: true,
          isFeatured: true,
        ),

        const CreditCardModel(
          id: 'cc3',
          bankId: '3',
          bankName: 'Riyad Bank',
          cardName: 'World Elite Mastercard',
          cardType: 'World Elite',
          imageUrl: 'https://images.unsplash.com/photo-1565373679003-82a9119bfd85?w=400',
          description: 'Exclusive lifestyle benefits',
          benefits: [
            '3% cashback on all purchases',
            'Priority customer service',
            'Golf privileges',
            'Dining offers',
          ],
          cashbackPercentage: 3.0,
          rewardPoints: 120,
          annualFee: 1500,
          isPopular: true,
          isFeatured: false,
        ),

        const CreditCardModel(
          id: 'cc4',
          bankId: '5',
          bankName: 'SABB',
          cardName: 'First Card',
          cardType: 'Classic',
          imageUrl: 'https://images.unsplash.com/photo-1559526324-593bc073d938?w=400',
          description: 'Start your credit journey',
          benefits: [
            '1% cashback',
            'Online shopping protection',
            'SMS alerts',
            'Easy payment plans',
          ],
          cashbackPercentage: 1.0,
          annualFee: 300,
          isPopular: false,
          isFeatured: false,
        ),

        const CreditCardModel(
          id: 'cc5',
          bankId: '4',
          bankName: 'Alinma Bank',
          cardName: 'Mumayaz Card',
          cardType: 'Gold',
          imageUrl: 'https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=400',
          description: 'Shariah-compliant gold card',
          benefits: [
            'Reward points program',
            'Travel discounts',
            'No hidden fees',
            'SMS notifications',
          ],
          rewardPoints: 60,
          annualFee: 0,
          isPopular: false,
          isFeatured: false,
        ),
      ];

  /// Get featured credit cards
  static List<CreditCardModel> get featuredCards => creditCards.where((card) => card.isFeatured == true).toList();

  /// Get popular credit cards
  static List<CreditCardModel> get popularCards => creditCards.where((card) => card.isPopular == true).toList();

  /// Get cards by bank ID
  static List<CreditCardModel> getCardsByBankId(String bankId) {
    return creditCards.where((card) => card.bankId == bankId).toList();
  }
}
