/// Centralized user-facing string constants for the application.
///
/// Follows Clean Architecture and avoids hardcoded strings in widgets.
abstract final class AppStrings {
  // ── App General & Brand ──────────────────────────────────────────────────
  static const String appName = 'شوب جايد';
  static const String appNameEn = 'ShopGuide';
  static const String appTagline = 'دليل التسوق والخدمات';
  static const String currency = 'ج.م';

  // ── Common Actions & Buttons ─────────────────────────────────────────────
  static const String retry = 'إعادة المحاولة';
  static const String cancel = 'إلغاء';
  static const String confirm = 'تأكيد';
  static const String delete = 'حذف';
  static const String edit = 'تعديل';
  static const String save = 'حفظ';
  static const String close = 'إغلاق';
  static const String back = 'رجوع';
  static const String search = 'بحث';
  static const String loading = 'جاري التحميل...';
  static const String later = 'لاحقاً';
  static const String shopNow = 'تسوق الآن';
  static const String showMore = 'عرض المزيد';
  static const String showAll = 'عرض الكل';
  static const String apply = 'تطبيق';
  static const String next = 'التالي';
  static const String previous = 'السابق';
  static const String done = 'تم';
  static const String skip = 'تخطي';
  static const String all = 'الكل';

  // ── Bottom Navigation & Main Shell ────────────────────────────────────────
  static const String navHome = 'الرئيسية';
  static const String navCategories = 'الأقسام';
  static const String navDiscountCard = 'كارت الخصم';
  static const String navProfile = 'حسابي';
  static const String navCart = 'سلة التسوق';
  static const String navFavorites = 'المفضلة';
  static const String navOrders = 'طلباتي';

  // ── Authentication & Onboarding ───────────────────────────────────────────
  static const String login = 'تسجيل الدخول';
  static const String register = 'إنشاء حساب جديد';
  static const String logout = 'تسجيل الخروج';
  static const String welcomeBack = 'مرحباً بك مجدداً!';
  static const String loginPrompt =
      'قم بتسجيل الدخول لإتمام عمليات الشراء وإدارة حسابك';
  static const String loginToCartPrompt =
      'يرجى تسجيل الدخول للوصول إلى سلة التسوق الخاصة بك';
  static const String registerToCartPrompt =
      'يرجى إدخال بياناتك لإضافة المنتجات إلى السلة وإتمام الشراء';
  static const String loginRequired = 'سجّل دخولك أولاً';
  static const String loginToViewCart = 'سجل الدخول لعرض سلة التسوق';
  static const String loginToViewCartSubtitle =
      'قم بتسجيل الدخول للاطلاع على المنتجات المضافة ومتابعة عملية الشراء';
  static const String loginToViewProfileSubtitle =
      'قم بتسجيل الدخول لعرض ملفك الشخصي\nومتابعة طلباتك ومزاياك';
  static const String loginToGetCardSubtitle =
      'قم بتسجيل الدخول للحصول على كارت الخصم\nوالاستفادة من كافة العروض والخصومات';
  static const String loginToViewFavoritesSubtitle =
      'قم بتسجيل الدخول لعرض قائمة المنتجات المفضلة لديك';
  static const String loginToGetCardButton = 'تسجيل الدخول للحصول على الكارت';
  static const String loginAndContinue = 'تسجيل الدخول والمتابعة';
  static const String registerAndContinue = 'إنشاء حساب جديد والمتابعة';
  static const String dontHaveAccount = 'ليس لديك حساب؟ ';
  static const String alreadyHaveAccount = 'لديك حساب بالفعل؟ ';
  static const String clickHereToRegister = 'اضغط هنا للتسجيل';
  static const String switchToRegister = 'ليس لديك حساب؟ إنشاء حساب جديد';
  static const String switchToLogin = 'لديك حساب بالفعل؟ تسجيل الدخول';

  // ── Form Labels & Placeholders ───────────────────────────────────────────
  static const String fullName = 'الاسم الكامل';
  static const String fullNameHint = 'محمود أحمد';
  static const String email = 'البريد الإلكتروني';
  static const String emailOrPhone = 'البريد الإلكتروني أو رقم الهاتف';
  static const String emailHint = 'example@domain.com';
  static const String phone = 'رقم الهاتف';
  static const String phoneHint = '01099887766';
  static const String password = 'كلمة المرور';
  static const String passwordAlt = 'كلمة السر';
  static const String passwordHint = '******';
  static const String currentPassword = 'كلمة المرور الحالية';
  static const String newPassword = 'كلمة المرور الجديدة';
  static const String confirmPassword = 'تأكيد كلمة المرور';
  static const String changePassword = 'تغيير كلمة المرور';
  static const String editProfile = 'تعديل الملف الشخصي';
  static const String requestDiscountCard = 'طلب بطاقة خصم';

  // ── Location & Delivery Address ───────────────────────────────────────────
  static const String deliveryLocation = 'موقع التوصيل';
  static const String governorate = 'المحافظة';
  static const String selectGovernorate = 'اختر المحافظة';
  static const String center = 'المركز';
  static const String selectCenter = 'اختر المركز';
  static const String area = 'المنطقة / القرية';
  static const String areaRequired = 'المنطقة / القرية *';
  static const String selectArea = 'اختر المنطقة';
  static const String deliveryAddress = 'عنوان التوصيل';
  static const String selectDeliveryAddress = 'اختر عنوان التوصيل';

  // ── Home Screen ───────────────────────────────────────────────────────────
  static const String homeSearchPlaceholder =
      'ابحث عن المنتجات، الخدمات، أو المتاجر...';
  static const String flashSale = 'عروض حصرية';
  static const String flashSaleTitle = 'عروض فلاش سيل';
  static const String flashSaleSubtitle = 'أقوى التخفيضات لفترة محدودة';
  static const String flashSaleEndsIn = 'ينتهي العرض خلال';
  static const String bestSellers = 'الأكثر مبيعاً';
  static const String newestProducts = 'أحدث المنتجات';
  static const String specialOffers = 'عروض خاصة';
  static const String exclusiveOffer = 'عرض حصري لفترة محدودة!';
  static const String limitedStockFastDelivery =
      'اطلب الآن — الكمية محدودة والتوصيل سريع';
  static const String featuredPartners = 'شركاء التميز';
  static const String ourPartners = 'شركاؤنا';
  static const String allCategories = 'جميع الأقسام';
  static const String days = 'يوم';
  static const String hours = 'ساعة';
  static const String minutes = 'دقيقة';
  static const String seconds = 'ثانية';

  // ── Products & Categories ─────────────────────────────────────────────────
  static const String products = 'المنتجات';
  static const String allProducts = 'جميع المنتجات';
  static const String categoryProducts = 'منتجات الفئة';
  static const String productDetails = 'تفاصيل المنتج';
  static const String addToCart = 'أضف للسلة';
  static const String addedToCart = 'تمت إضافة المنتج إلى السلة';
  static const String failedToAddToCart = 'تعذر إضافة المنتج إلى السلة';
  static const String inStock = 'متوفر بالمخزون';
  static const String outOfStock = 'غير متوفر بالمخزون';
  static const String description = 'الوصف';
  static const String specifications = 'المواصفات';
  static const String merchant = 'التاجر';
  static const String brand = 'الماركة';
  static const String rating = 'التقييم';
  static const String discount = 'خصم';
  static const String oldPrice = 'السعر قبل الخصم';
  static const String noProductsFound = 'لا توجد منتجات متوفرة حالياً';

  // ── Cart & Checkout ───────────────────────────────────────────────────────
  static const String shoppingCart = 'سلة التسوق';
  static const String emptyCartTitle = 'سلة التسوق فارغة';
  static const String emptyCartSubtitle =
      'لم تقم بإضافة أي منتجات إلى سلة التسوق حتى الآن';
  static const String clearCart = 'إفراغ السلة';
  static const String clearCartConfirmTitle = 'إفراغ السلة؟';
  static const String clearCartConfirmMessage =
      'هل أنت متأكد من حذف جميع المنتجات من سلة التسوق؟';
  static const String deleteItemConfirmTitle = 'حذف المنتج؟';
  static const String deleteItemConfirmMessage =
      'هل أنت متأكد من حذف هذا المنتج من سلة التسوق؟';
  static const String proceedToCheckout = 'المتابعة للشراء';
  static const String completeOrder = 'إتمام الطلب';
  static const String confirmOrder = 'تأكيد الطلب';
  static const String orderSummary = 'ملخص الطلب';
  static const String requestedProducts = 'المنتجات المطلوبة';
  static const String subtotal = 'المجموع الفرعي';
  static const String total = 'الإجمالي';
  static const String discountSavings = 'وفرت مع كارت الخصم';
  static const String paymentMethod = 'طريقة الدفع';
  static const String cashOnDelivery = 'الدفع عند الاستلام';
  static const String creditCard = 'بطاقة بنكية / بطاقة ائتمان';
  static const String processingOrder = 'جاري إرسال وتأكيد الطلب...';
  static const String orderSuccessTitle = 'تم تأكيد طلبك بنجاح!';
  static const String orderSuccessSubtitle =
      'شكراً لتسوقك معنا، تم استلام طلبك وجاري تجهيزه';
  static const String orderNumber = 'رقم الطلب';
  static const String trackOrder = 'تتبع الطلب';
  static const String backToHome = 'العودة للرئيسية';

  // ── Orders History ────────────────────────────────────────────────────────
  static const String myOrders = 'طلباتي';
  static const String orderFilterAll = 'الكل';
  static const String orderFilterPending = 'قيد المراجعة';
  static const String orderFilterCompleted = 'المكتملة';
  static const String orderFilterCancelled = 'الملغاة';
  static const String orderDetails = 'تفاصيل الطلب';
  static const String cancelOrder = 'إلغاء الطلب';
  static const String confirmCancelOrder = 'تأكيد الإلغاء';
  static const String cancelOrderConfirmTitle = 'إلغاء الطلب';
  static const String cancelOrderConfirmMessage =
      'هل أنت متأكد من رغبتك في إلغاء هذا الطلب؟';
  static const String orderStatus = 'حالة الطلب';
  static const String orderDate = 'تاريخ الطلب';
  static const String noOrdersTitle = 'لا توجد طلبات سابقة';
  static const String noPendingOrdersTitle = 'لا توجد طلبات قيد المراجعة';
  static const String noCompletedOrdersTitle = 'لا توجد طلبات مكتملة';
  static const String noCancelledOrdersTitle = 'لا توجد طلبات ملغاة';
  static const String noOrdersSubtitle =
      'ابدأ بالتسوق الآن واستمتع بأفضل العروض والخصومات!';

  // ── Discount Card ─────────────────────────────────────────────────────────
  static const String discountCardTitle = 'كارت الخصومات';
  static const String discountCardHeader = 'كارت الخصم';
  static const String discountCategories = 'فئات الخصم';
  static const String cardBenefits = 'مميزات الكارت';
  static const String cardHolder = 'اسم حامل الكارت';
  static const String cardNumber = 'رقم الكارت';
  static const String expiryDate = 'تاريخ الانتهاء';
  static const String cardStatus = 'حالة الكارت';
  static const String cardActive = 'مفعل';
  static const String cardExpired = 'منتهي الصلاحية';
  static const String cardPending = 'قيد المراجعة';
  static const String totalSavings = 'إجمالي ما وفرته من\nكل الفواتير';
  static const String subscriptionDaysRemaining = 'الأيام المتبقية في الاشتراك';

  // ── Merchants & Partners ──────────────────────────────────────────────────
  static const String merchants = 'المتاجر';
  static const String partnerMerchants = 'شركاء التميز';
  static const String searchMerchantPlaceholder = 'ابحث عن تاجر أو متجر...';
  static const String merchantSuffix = 'تاجر';
  static const String noMerchantsTitle = 'لا يوجد تجار حالياً';
  static const String noMerchantsSubtitle = 'تحقق مجدداً لاحقاً';
  static const String viewStore = 'عرض المتجر';
  static const String merchantDetails = 'تفاصيل المتجر';
  static const String callMerchant = 'اتصال هاتفي';
  static const String whatsappMerchant = 'تواصل عبر واتساب';

  // ── Favorites ─────────────────────────────────────────────────────────────
  static const String favoritesTitle = 'المفضلة';
  static const String emptyFavoritesTitle = 'قائمة المفضلة فارغة';
  static const String emptyFavoritesSubtitle =
      'تصفح المنتجات وأضف ما يعجبك إلى المفضلة للرجوع إليها لاحقاً';
  static const String removedFromFavorites = 'تمت إزالة المنتج من المفضلة';
  static const String addedToFavorites = 'تمت إضافة المنتج إلى المفضلة';

  // ── Search ────────────────────────────────────────────────────────────────
  static const String searchPromptTitle = 'ابحث عن منتج، متجر، أو فئة';
  static const String searchPromptSubtitle =
      'اكتب في خانة البحث بالأعلى لعرض النتائج مباشرة';
  static const String noSearchResultsTitle = 'لا توجد نتائج بحث';
  static const String noSearchResultsSubtitle =
      'تأكد من كتابة الكلمات بشكل صحيح أو حاول البحث بكلمات أخرى';
  static const String clearSearch = 'مسح البحث';

  // ── Profile, Settings & Support ───────────────────────────────────────────
  static const String profile = 'الملف الشخصي';
  static const String supportCenterWhatsApp = 'مركز الدعم (واتساب)';
  static const String termsAndConditions = 'الشروط والأحكام';
  static const String privacyPolicy = 'سياسة الخصوصية';
  static const String aboutApp = 'عن التطبيق';
  static const String rateApp = 'تقييم التطبيق';
  static const String logoutConfirmTitle = 'تسجيل الخروج';
  static const String logoutConfirmMessage =
      'هل أنت متأكد من أنك تريد تسجيل الخروج؟';
  static const String logoutSuccess = 'تم تسجيل الخروج بنجاح';

  // ── Validation & Error Messages ───────────────────────────────────────────
  static const String requiredField = 'هذا الحقل مطلوب';
  static const String enterFullName = 'يرجى إدخال الاسم الكامل';
  static const String enterEmailOrPhone =
      'يرجى إدخال البريد الإلكتروني أو رقم الهاتف';
  static const String enterEmail = 'يرجى إدخال البريد الإلكتروني';
  static const String enterPhone = 'يرجى إدخال رقم الهاتف';
  static const String enterPassword = 'يرجى إدخال كلمة المرور';
  static const String passwordMinLength =
      'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
  static const String selectAreaPrompt = 'يرجى اختيار المنطقة / القرية';
  static const String genericError = 'حدث خطأ، يرجى المحاولة لاحقاً';
  static const String serverError = 'حدث خطأ في الخادم. يرجى المحاولة لاحقاً.';
  static const String networkError =
      'تعذر الاتصال بالشبكة، يرجى التحقق من اتصالك بالإنترنت';
  static const String timeoutError =
      'انتهت مهلة الاتصال. يرجى التحقق من اتصالك بالإنترنت.';
  static const String unauthorizedError =
      'انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول';
  static const String unexpectedError =
      'حدث خطأ غير متوقع. يرجى المحاولة لاحقاً.';
}
