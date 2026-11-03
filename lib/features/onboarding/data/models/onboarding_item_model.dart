import '../../../../core/constants/app_assets.dart';

/// Represents a single onboarding slide in the Shop Guide walkthrough.
class OnboardingItemModel {
  /// Main headline in Arabic.
  final String titleAr;

  /// Secondary headline in English.
  final String titleEn;

  /// Detailed description in Arabic.
  final String subtitleAr;

  /// Detailed description in English.
  final String subtitleEn;

  /// Asset path to the 3D illustration.
  final String imagePath;

  const OnboardingItemModel({
    required this.titleAr,
    required this.titleEn,
    required this.subtitleAr,
    required this.subtitleEn,
    required this.imagePath,
  });

  /// The 3 official slides matching the design mockup.
  static const List<OnboardingItemModel> defaultItems = [
    OnboardingItemModel(
      titleAr: 'كل احتياجاتك في مكان واحد',
      titleEn: 'Everything You Need,\nAll in One Place.',
      subtitleAr:
          'اكتشف المنتجات والخدمات والعقارات وغيرها من خلال تطبيق واحد',
      subtitleEn:
          'Discover products, services, properties, and more — all from one app.',
      imagePath: AppAssets.onboarding1,
    ),
    OnboardingItemModel(
      titleAr: 'اشتراك واحد . . خصومات في كل مكان',
      titleEn: 'One Membership,\nMore Savings.',
      subtitleAr:
          'اشترك مرة واحدة واستمتع بخصومات الاعضاء لدي التجار المشاركين في المنصة',
      subtitleEn:
          'Get one annual membership and enjoy exclusive member discounts from all our participating merchants.',
      imagePath: AppAssets.onboarding2,
    ),
    OnboardingItemModel(
      titleAr: 'وفر فلوسك وتابع توفيرك',
      titleEn: 'See How Much You Save.',
      subtitleAr:
          'تابع إجمالي توفيرك الشهري . . وراجع مشترياتك واكتشف الفئات التي توفر فيها أكثر',
      subtitleEn:
          'Track your savings, review your orders, and discover where you save the most.',
      imagePath: AppAssets.onboarding3,
    ),
  ];
}
