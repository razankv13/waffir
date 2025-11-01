/// Mock help center content data
///
/// This file contains mock data for the help center screen.
/// In production, this content would come from a CMS or backend API.

class HelpArticle {
  final String id;
  final String question;
  final String answer;
  final String category;
  final bool isExpanded;

  const HelpArticle({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.isExpanded = false,
  });

  HelpArticle copyWith({
    String? id,
    String? question,
    String? answer,
    String? category,
    bool? isExpanded,
  }) {
    return HelpArticle(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      category: category ?? this.category,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

/// Mock help articles grouped by category
final Map<String, List<HelpArticle>> mockHelpArticles = {
  'Getting Started': [
    const HelpArticle(
      id: '1',
      question: 'How do I create an account?',
      answer: 'To create an account, tap on the "Sign Up" button on the login screen and follow the registration process. You can sign up using your phone number, email, or social media accounts.',
      category: 'Getting Started',
    ),
    const HelpArticle(
      id: '2',
      question: 'How do I select my city?',
      answer: 'During onboarding or from the profile screen, you can select your city. This helps us show you relevant deals and stores in your area.',
      category: 'Getting Started',
    ),
    const HelpArticle(
      id: '3',
      question: 'What is Waffir?',
      answer: 'Waffir is your ultimate companion for discovering the best credit card deals and offers in Saudi Arabia. We aggregate deals from various stores and banks to help you save money.',
      category: 'Getting Started',
    ),
  ],
  'Deals & Offers': [
    const HelpArticle(
      id: '4',
      question: 'How do I find deals?',
      answer: 'Browse the "Deals" tab to see all available offers. You can filter by category, store, or bank card. Tap on any deal to see full details.',
      category: 'Deals & Offers',
    ),
    const HelpArticle(
      id: '5',
      question: 'How do I save a deal?',
      answer: 'Tap the heart icon on any deal card to save it to your favorites. Access your saved deals from the profile screen.',
      category: 'Deals & Offers',
    ),
    const HelpArticle(
      id: '6',
      question: 'How do I redeem a deal?',
      answer: 'Each deal has specific redemption instructions. Some require you to show the deal at checkout, others need a promo code. Check the deal details for exact instructions.',
      category: 'Deals & Offers',
    ),
    const HelpArticle(
      id: '7',
      question: 'Why can\'t I see some deals?',
      answer: 'Some deals are only available to premium users or require specific bank cards. Check the deal requirements in the details section.',
      category: 'Deals & Offers',
    ),
  ],
  'Credit Cards': [
    const HelpArticle(
      id: '8',
      question: 'How do I add my credit card?',
      answer: 'Go to the "Cards" tab and tap the "+" button. Select your bank and card type from the list. We only store card information locally for filtering purposes.',
      category: 'Credit Cards',
    ),
    const HelpArticle(
      id: '9',
      question: 'Is my credit card information safe?',
      answer: 'Yes! We never store your complete credit card details. We only save the bank name and card type to show you relevant deals. All data is encrypted and stored locally on your device.',
      category: 'Credit Cards',
    ),
    const HelpArticle(
      id: '10',
      question: 'Which banks are supported?',
      answer: 'We support all major Saudi banks including Al Rajhi Bank, SNB, Riyad Bank, Alinma Bank, and many more.',
      category: 'Credit Cards',
    ),
  ],
  'Premium Subscription': [
    const HelpArticle(
      id: '11',
      question: 'What is Waffir Premium?',
      answer: 'Waffir Premium gives you access to exclusive deals, early access to offers, ad-free experience, and advanced filtering options.',
      category: 'Premium Subscription',
    ),
    const HelpArticle(
      id: '12',
      question: 'How much does Premium cost?',
      answer: 'Premium is available in monthly and yearly plans. Check the subscription screen for current pricing and special offers.',
      category: 'Premium Subscription',
    ),
    const HelpArticle(
      id: '13',
      question: 'Can I cancel my subscription?',
      answer: 'Yes, you can cancel anytime from the subscription management screen. Your premium features will remain active until the end of your billing period.',
      category: 'Premium Subscription',
    ),
  ],
  'Account & Settings': [
    const HelpArticle(
      id: '14',
      question: 'How do I change my password?',
      answer: 'Go to Profile > Personal Details > Change Password. Enter your current password and your new password.',
      category: 'Account & Settings',
    ),
    const HelpArticle(
      id: '15',
      question: 'How do I change my city?',
      answer: 'From the profile screen, tap on "My City" and select a new city from the list. This will update the deals and stores shown to you.',
      category: 'Account & Settings',
    ),
    const HelpArticle(
      id: '16',
      question: 'How do I delete my account?',
      answer: 'Go to Profile > Personal Details and scroll down to find the "Delete Account" option. This action is permanent and cannot be undone.',
      category: 'Account & Settings',
    ),
  ],
  'Troubleshooting': [
    const HelpArticle(
      id: '17',
      question: 'The app is running slowly',
      answer: 'Try closing and reopening the app. If the issue persists, clear the app cache from Settings > Storage, or reinstall the app.',
      category: 'Troubleshooting',
    ),
    const HelpArticle(
      id: '18',
      question: 'I\'m not receiving notifications',
      answer: 'Check that notifications are enabled in your device settings and in the app (Profile > Notifications). Make sure you\'re not in Do Not Disturb mode.',
      category: 'Troubleshooting',
    ),
    const HelpArticle(
      id: '19',
      question: 'A deal is showing as expired but it\'s still valid',
      answer: 'Sometimes there\'s a delay in updating deal status. Try refreshing the app by pulling down on the deals screen. If the issue persists, please contact support.',
      category: 'Troubleshooting',
    ),
  ],
};

/// Flattened list of all help articles
final List<HelpArticle> allMockHelpArticles = mockHelpArticles.values.expand((articles) => articles).toList();

/// Contact support information
class SupportContact {
  final String type;
  final String value;
  final String label;
  final String? icon;

  const SupportContact({
    required this.type,
    required this.value,
    required this.label,
    this.icon,
  });
}

/// Mock support contact options
final List<SupportContact> mockSupportContacts = [
  const SupportContact(
    type: 'email',
    value: 'support@waffir.com',
    label: 'Email Support',
    icon: 'email',
  ),
  const SupportContact(
    type: 'phone',
    value: '+966 11 234 5678',
    label: 'Phone Support',
    icon: 'phone',
  ),
  const SupportContact(
    type: 'whatsapp',
    value: '+966 50 123 4567',
    label: 'WhatsApp',
    icon: 'whatsapp',
  ),
  const SupportContact(
    type: 'twitter',
    value: '@WaffirSA',
    label: 'Twitter',
    icon: 'twitter',
  ),
];

/// Help center categories
final List<String> helpCategories = mockHelpArticles.keys.toList();
