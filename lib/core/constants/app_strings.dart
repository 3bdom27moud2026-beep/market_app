/// Centralized user-facing string constants for the application.
///
/// Follows Clean Architecture and avoids hardcoded strings in widgets.
abstract final class AppStrings {
  // ── 1. App General, Brand & Currency ─────────────────────────────────────
  static const String appName = 'شوب جايد';
  static const String appNameEn = 'ShopGuide';
  static const String appTagline = 'دليل التسوق والخدمات';
  static const String appSubtitle = 'دليل التسوق والخصومات الحصرية';
  static const String currency = 'ج.م';
  static const String currencyFull = 'جنيه مصري';
  static const String currencyEg = 'جنيه';
  static const String egp = 'EGP';
  static const String egypt = 'مصر';
  static const String locationEgypt = 'الموقع - مصر';

  // ── 2. Common Actions & Buttons ──────────────────────────────────────────
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
  static const String pleaseWait = 'يرجى الانتظار...';
  static const String later = 'لاحقاً';
  static const String shopNow = 'تسوق الآن';
  static const String startShopping = 'ابدأ التسوق';
  static const String showMore = 'عرض المزيد';
  static const String showAll = 'عرض الكل';
  static const String viewAll = 'عرض الكل';
  static const String apply = 'تطبيق';
  static const String next = 'التالي';
  static const String previous = 'السابق';
  static const String done = 'تم';
  static const String skip = 'تخطي';
  static const String all = 'الكل';
  static const String add = 'إضافة';
  static const String send = 'إرسال';
  static const String submit = 'إرسال';
  static const String copy = 'نسخ';
  static const String copied = 'تم النسخ';
  static const String call = 'اتصال';
  static const String details = 'التفاصيل';
  static const String getNow = 'احصل عليه';
  static const String getOffer = 'احصل على العرض';
  static const String subscribeNow = 'اشترك ووفر الآن';
  static const String now = 'الآن';

  // ── 3. Bottom Navigation & Main Shell ────────────────────────────────────
  static const String navHome = 'الرئيسية';
  static const String navCategories = 'الأقسام';
  static const String navDiscountCard = 'كارت الخصم';
  static const String navProfile = 'حسابي';
  static const String navAccount = 'الحساب';
  static const String navCart = 'السلة';
  static const String navFavorites = 'المفضلة';
  static const String navOrders = 'طلباتي';
  static const String navNotifications = 'الإشعارات';

  // ── 4. Onboarding ────────────────────────────────────────────────────────
  static const String onboarding1Title = 'اكتشف أفضل التجار والخدمات';
  static const String onboarding1Subtitle =
      'تصفح آلاف المنتجات والخدمات والعروض الحصرية من كبرى المتاجر والشركاء في مكان واحد.';
  static const String onboarding2Title = 'كارت الخصم الذهبي الحصري';
  static const String onboarding2Subtitle =
      'اشترك بكارت الخصم واستمتع بخصومات تصل حتى 50% لدى مئات المتاجر والخدمات المشاركة.';
  static const String onboarding3Title = 'توصيل سريع ومتابعة دقيقة';
  static const String onboarding3Subtitle =
      'تسوق بكل سهولة مع إمكانية متابعة طلبك لحظة بلحظة حتى باب منزلك مع دفع آمن عند الاستلام.';
  static const String getStarted = 'ابدأ الآن';

  // ── 5. Authentication & User Prompts ─────────────────────────────────────
  static const String login = 'تسجيل الدخول';
  static const String register = 'إنشاء حساب جديد';
  static const String createAccount = 'إنشاء حساب';
  static const String createNewAccount = 'إنشاء حساب جديد';
  static const String logout = 'تسجيل الخروج';
  static const String welcomeBack = 'مرحباً بك مجدداً!';
  static const String welcomeBackSubtitle = 'أهلاً بعودتك! سجّل دخولك للمتابعة';
  static const String loginPrompt =
      'قم بتسجيل الدخول لإتمام عمليات الشراء وإدارة حسابك';
  static const String registerPrompt = 'أدخل بياناتك لإنشاء حساب جديد';
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
  static const String clickHereToLogin = 'اضغط هنا لتسجيل الدخول';
  static const String switchToRegister = 'ليس لديك حساب؟ إنشاء حساب جديد';
  static const String switchToLogin = 'لديك حساب بالفعل؟ تسجيل الدخول';
  static const String forgotPassword = 'هل نسيت كلمة المرور؟';
  static const String resetPassword = 'إعادة تعيين كلمة المرور';
  static const String orLoginWith = 'أو عبر';

  // ── 6. Form Labels, Hints & Placeholders ─────────────────────────────────
  static const String fullName = 'الاسم الكامل';
  static const String fullNameHint = 'محمود أحمد';
  static const String enterFullName = 'يرجى إدخال الاسم الكامل';
  static const String email = 'البريد الإلكتروني';
  static const String emailOrPhone = 'البريد الإلكتروني أو رقم الهاتف';
  static const String emailHint = 'example@domain.com';
  static const String phone = 'رقم الهاتف';
  static const String phoneHint = '01099887766';
  static const String enterPhone = 'يرجى إدخال رقم الهاتف';
  static const String enterEmail = 'يرجى إدخال البريد الإلكتروني';
  static const String enterEmailOrPhone =
      'يرجى إدخال البريد الإلكتروني أو رقم الهاتف';
  static const String password = 'كلمة المرور';
  static const String passwordAlt = 'كلمة السر';
  static const String passwordHint = '******';
  static const String enterPassword = 'يرجى إدخال كلمة المرور';
  static const String currentPassword = 'كلمة المرور الحالية';
  static const String enterCurrentPassword = 'أدخل كلمة المرور الحالية';
  static const String newPassword = 'كلمة المرور الجديدة';
  static const String enterNewPassword = 'أدخل كلمة المرور الجديدة';
  static const String confirmPassword = 'تأكيد كلمة المرور';
  static const String confirmNewPassword = 'تأكيد كلمة المرور الجديدة';
  static const String reenterNewPassword = 'أعد إدخال كلمة المرور الجديدة';
  static const String changePassword = 'تغيير كلمة المرور';
  static const String confirmPasswordChange = 'تأكيد التغيير';
  static const String referralCodeOptional = 'كود الإحالة (اختياري)';
  static const String referralCodeHint = 'أدخل كود الإحالة إن وجد';
  static const String couponCodeHint = 'أدخل كود الخصم (مثال: MARKET20)';
  static const String applyCoupon = 'تطبيق الكوبون';
  static const String notesOptional = 'ملاحظات إضافية (اختياري)';
  static const String notesHint = 'أي تعليمات خاصة بالتوصيل أو الاستلام...';

  // ── 7. Location & Delivery Address ───────────────────────────────────────
  static const String deliveryLocation = 'موقع التوصيل';
  static const String deliveringTo = 'التوصيل إلى:';
  static const String governorate = 'المحافظة';
  static const String governorateRequired = 'المحافظة مطلوبة';
  static const String selectGovernorate = 'اختر المحافظة';
  static const String center = 'المركز';
  static const String selectCenter = 'اختر المركز';
  static const String cityOrArea = 'المدينة / المنطقة';
  static const String cityRequired = 'المدينة مطلوبة';
  static const String area = 'المنطقة / القرية';
  static const String areaRequired = 'المنطقة / القرية *';
  static const String selectArea = 'اختر المنطقة';
  static const String enterAreaNumber = 'أدخل رقم المنطقة';
  static const String deliveryAddress = 'عنوان التوصيل';
  static const String selectDeliveryAddress = 'اختر عنوان التوصيل';
  static const String selectOrAddAddress = 'اختيار أو إضافة عنوان';
  static const String addNewAddress = 'إضافة عنوان جديد';
  static const String addNewDeliveryAddress = 'إضافة عنوان توصيل جديد';
  static const String addressNameHint = 'اسم العنوان (مثال: المنزل، العمل)';
  static const String recipientName = 'اسم المستلم';
  static const String recipientPhone = 'رقم هاتف المستلم';
  static const String streetAddress = 'اسم الشارع / رقم العقار / الشقة';
  static const String primaryAddress = 'العنوان الرئيسي';
  static const String selectThisAddress = 'اختيار هذا العنوان';
  static const String confirmLocation = 'تأكيد الموقع';
  static const String locationFilterPrompt =
      'اختر المحافظة والمنطقة لتصفية العروض والمتاجر الأقرب إليك.';
  static const String cairo = 'القاهرة';
  static const String cairoEgypt = 'القاهرة، مصر';

  // ── 8. Home Screen & Sections ────────────────────────────────────────────
  static const String homeSearchPlaceholder =
      'ابحث عن المنتجات، الخدمات، أو المتاجر...';
  static const String flashSale = 'عروض حصرية';
  static const String flashSaleTitle = 'عروض فلاش سيل';
  static const String flashSaleSubtitle = 'أقوى التخفيضات لفترة محدودة';
  static const String flashSaleEndsIn = 'ينتهي العرض خلال';
  static const String bestSellers = 'الأكثر مبيعاً';
  static const String mostPopular = 'الأكثر طلباً';
  static const String mostPopularStar = 'الأكثر طلباً ⭐';
  static const String newestProducts = 'أحدث المنتجات';
  static const String newestProductsAndServices = 'أحدث المنتجات والخدمات';
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
  static const String remainingTime = 'الوقت المتبقي';

  // ── 9. Products, Categories & Filters ────────────────────────────────────
  static const String products = 'المنتجات';
  static const String allProducts = 'جميع المنتجات';
  static const String categoryProducts = 'منتجات الفئة';
  static const String productDetails = 'تفاصيل المنتج';
  static const String addToCart = 'أضف للسلة';
  static const String addToCartFull = 'إضافة إلى سلة المشتريات';
  static const String addedToCart = 'تمت إضافة المنتج إلى السلة';
  static const String failedToAddToCart = 'تعذر إضافة المنتج إلى السلة';
  static const String inStock = 'متوفر بالمخزون';
  static const String outOfStock = 'غير متوفر بالمخزون';
  static const String outOfStockPrompt =
      'الكمية المطلوبة غير متوفرة في المخزون حالياً.';
  static const String description = 'الوصف';
  static const String specifications = 'المواصفات';
  static const String technicalSpecs = 'المواصفات الفنية';
  static const String warranty = 'الضمان';
  static const String merchant = 'التاجر';
  static const String merchantData = 'بيانات المتجر';
  static const String brand = 'الماركة';
  static const String rating = 'التقييم';
  static const String reviewsCount = 'التقييمات';
  static const String addYourReview = 'أضف تقييمك';
  static const String sendReview = 'إرسال التقييم';
  static const String reviewHint = 'اكتب تعليقك وتجربتك هنا...';
  static const String discount = 'خصم';
  static const String oldPrice = 'السعر قبل الخصم';
  static const String currentPrice = 'السعر الحالي';
  static const String priceAfterInspection = 'القيمة تحدد بعد المعاينة';
  static const String retailMarket = 'سوق التجزئة';
  static const String wholesaleMarket = 'سوق الجملة';
  static const String categoriesRetail = 'الفئات (سوق التجزئة)';
  static const String categoriesWholesale = 'الفئات (سوق الجملة)';
  static const String noProductsFound = 'لا توجد منتجات متوفرة حالياً';

  // ── Filters & Sorting ────────────────────────────────────────────────────
  static const String sortBy = 'ترتيب حسب';
  static const String sortNewest = 'الأحدث';
  static const String sortRating = 'الأعلى تقييماً';
  static const String sortBestRated = 'الأفضل تقييماً';
  static const String sortDiscount = 'الأعلى خصماً';
  static const String sortPriceLowHigh = 'الأقل سعراً';
  static const String sortPriceHighLow = 'الأعلى سعراً';
  static const String sortMostDemanded = 'الأكثر طلباً';
  static const String maxSavings = 'أعلى توفير 👑';

  // ── 10. Cart, Checkout & Payment ─────────────────────────────────────────
  static const String shoppingCart = 'سلة التسوق';
  static const String cart = 'السلة';
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
  static const String grandTotal = 'المبلغ الإجمالي';
  static const String totalPaid = 'المبلغ المدفوع';
  static const String discountSavings = 'وفرت مع كارت الخصم';
  static const String totalSavingsText = 'إجمالي الخصم والوفورات';
  static const String paymentMethod = 'طريقة الدفع';
  static const String confirmPaymentMethod = 'تأكيد طريقة الدفع';
  static const String cashOnDelivery = 'الدفع عند الاستلام';
  static const String cashOnDeliveryDesc = 'الدفع نقداً عند استلام طلبك';
  static const String creditCard = 'بطاقة بنكية / بطاقة ائتمان';
  static const String instaPay = 'إنستاباي (InstaPay)';
  static const String instaPayDesc = 'التحويل المباشر عبر تطبيق انستاباي';
  static const String vodafoneCash = 'فودافون كاش / محافظ إلكترونية';
  static const String secureAndGuaranteed = 'آمنة ومضمونة';
  static const String processingOrder = 'جاري إرسال وتأكيد الطلب...';
  static const String orderSuccessTitle = 'تم تأكيد طلبك بنجاح!';
  static const String orderSuccessSubtitle =
      'شكراً لتسوقك معنا، تم استلام طلبك وجاري تجهيزه';
  static const String orderNumber = 'رقم الطلب';
  static const String trackOrder = 'تتبع الطلب';
  static const String trackShipment = 'تتبع الشحنة 🚚';
  static const String backToHome = 'العودة للرئيسية';
  static const String invoice = 'الفاتورة';

  // ── 11. Orders History & Tracking ────────────────────────────────────────
  static const String myOrders = 'طلباتي';
  static const String orders = 'الطلبات';
  static const String previousOrders = 'الطلبات السابقة';
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

  // ── 12. Discount Card & Subscription ─────────────────────────────────────
  static const String discountCardTitle = 'كارت الخصومات';
  static const String discountCardHeader = 'كارت الخصم';
  static const String discountCategories = 'فئات الخصم';
  static const String cardBenefits = 'مميزات الكارت';
  static const String cardHolder = 'اسم حامل الكارت';
  static const String cardNumber = 'رقم الكارت';
  static const String expiryDate = 'تاريخ الانتهاء';
  static const String activationDate = 'تاريخ التفعيل';
  static const String cardStatus = 'حالة الكارت';
  static const String cardActive = 'مفعل';
  static const String cardExpired = 'منتهي الصلاحية';
  static const String cardPending = 'قيد المراجعة';
  static const String cardInactive = 'الكارت غير مفعّل حالياً';
  static const String totalSavings = 'إجمالي ما وفرته من\nكل الفواتير';
  static const String subscriptionDaysRemaining = 'الأيام المتبقية في الاشتراك';
  static const String remainingDays = 'الأيام المتبقية';
  static const String scanQrPrompt =
      'امسح الكود لدى التاجر للحصول على الخصم الفوري';
  static const String cardDetailsButton = 'اضغط هنا لتفاصيل الكارت';
  static const String requestDiscountCard = 'طلب بطاقة خصم';
  static const String underActivation = 'قيد التفعيل';
  static const String notAvailable = 'غير متاح';
  static const String requestCardAction = 'تقديم طلب للحصول على كارت';
  static const String requestCardPendingDesc =
      'طلب كارت الخصم الخاص بك قيد المراجعة أو غير مفعّل حالياً. سيتم إشعارك وتفعيله قريباً لتتمكن من استخدامه والاستفادة من أفضل العروض والخصومات!';
  static const String requestCardEmptyDesc =
      'ليس لديك كارت خصومات حالياً. يمكنك تقديم طلب للحصول على كارت والاستفادة من أفضل العروض والخصومات!';

  // Subscription Plans & Application
  static const String step1ChoosePlan = '1. اختر باقة الاشتراك';
  static const String step2PaymentInfo = '2. طريقة الدفع وبيانات التحويل';
  static const String step3AttachReceipt = '3. إرفاق صورة إيصال التحويل *';
  static const String step4ContactInfo = '4. بيانات إضافية للتواصل (اختياري)';
  static const String choosePlanSubtitle =
      'اختر باقتك المفضلة وأرفق إيصال التحويل لتفعيل الكارت فوراً';
  static const String monthlyPlan = 'اشتراك شهري';
  static const String sixMonthsPlan = '6 أشهر';
  static const String annualPlan = 'اشتراك سنوي';
  static const String monthlyPlanPrice = '50 جنيه / شهرياً';
  static const String sixMonthsPlanPrice = '150 جنيه / 6 أشهر';
  static const String annualPlanPrice = '300 جنيه / سنوياً';
  static const String annualPlanLongDesc = 'اشتراك سنوي — 12 شهر — 350 جنيه';
  static const String attachReceiptScreenshot =
      'اضغط هنا لرفع لقطة شاشة التحويل (Screenshot / Receipt)';
  static const String selectReceiptPhoto = 'اختيار صورة إيصال التحويل';
  static const String chooseFromGallery = 'اختيار من المعرض';
  static const String takeCameraPhoto = 'التقاط صورة بالكاميرا';
  static const String submitReceiptAndActivate =
      'إرسال صورة التحويل وتفعيل الكارت';
  static const String physicalCardAddressNote =
      'العنوان في حال طلب كارت بلاستيكي مطبوع (اختياري)';

  // ── 13. Loyalty, Rewards & Referrals ─────────────────────────────────────
  static const String loyaltyPoints = 'نقاط الولاء';
  static const String rewardsPointsBalance = 'رصيد نقاط المكافآت';
  static const String howToUsePoints = 'كيف تستفيد من نقاطك؟';
  static const String earnedPoints = 'النقاط المكتسبة 🌟';
  static const String pointsBalance = 'رصيد النقاط';
  static const String point = 'نقطة';
  static const String points = 'نقاط';
  static const String earnPointsNote =
      'اكسب نقاطاً مع كل عملية شراء ناجحة عبر التطبيق.';
  static const String redeemPointsNote =
      'استبدل نقاطك بخصم نقدي مباشر عند إتمام الطلب.';
  static const String referralProgram = 'برنامج الإحالة ومكافأة الأصدقاء';
  static const String referralCodeLabel = 'كود الإحالة الخاص بك:';
  static const String referralCodeColon = ':كود الإحالة';
  static const String copyCode = 'نسخ الكود';
  static const String referralCopiedSuccess = 'تم نسخ كود الإحالة بنجاح 📋';
  static const String shareReferralPrompt =
      'ادعُ أصدقاءك واكسب 50 نقطة مكافأة عند تسجيل كل صديق!';

  // ── 14. Merchants, Partners & Reviews ────────────────────────────────────
  static const String merchants = 'المتاجر';
  static const String merchantSuffix = 'تاجر';
  static const String partnerMerchants = 'شركاء التميز';
  static const String favoriteMerchants = 'التجار المفضلون';
  static const String searchMerchantPlaceholder = 'ابحث عن تاجر أو متجر...';
  static const String noMerchantsTitle = 'لا يوجد تجار حالياً';
  static const String noMerchantsSubtitle = 'تحقق مجدداً لاحقاً';
  static const String viewStore = 'عرض المتجر';
  static const String merchantDetails = 'تفاصيل المتجر';
  static const String callMerchant = 'اتصال هاتفي';
  static const String whatsappMerchant = 'تواصل عبر واتساب';
  static const String exploreMerchants = 'استكشف التجار الآن';

  // ── 15. Favorites ────────────────────────────────────────────────────────
  static const String favoritesTitle = 'المفضلة';
  static const String favoriteProducts = 'المنتجات المفضلة';
  static const String emptyFavoritesTitle = 'قائمة المفضلة فارغة';
  static const String emptyFavoritesSubtitle =
      'تصفح المنتجات وأضف ما يعجبك إلى المفضلة للرجوع إليها لاحقاً';
  static const String removedFromFavorites = 'تمت إزالة المنتج من المفضلة';
  static const String addedToFavorites = 'تمت إضافة المنتج إلى المفضلة';
  static const String removeFromFavorites = 'إزالة من المفضلة';

  // ── 16. Search ───────────────────────────────────────────────────────────
  static const String searchPromptTitle = 'ابحث عن منتج، متجر، أو فئة';
  static const String searchPromptSubtitle =
      'اكتب في خانة البحث بالأعلى لعرض النتائج مباشرة';
  static const String noSearchResultsTitle = 'لا توجد نتائج بحث';
  static const String noSearchResultsSubtitle =
      'تأكد من كتابة الكلمات بشكل صحيح أو حاول البحث بكلمات أخرى';
  static const String clearSearch = 'مسح البحث';

  // ── 17. Profile, Settings & Support ──────────────────────────────────────
  static const String profile = 'الملف الشخصي';
  static const String myProfile = 'حسابي';
  static const String editProfile = 'تعديل الملف الشخصي';
  static const String supportCenter = 'مركز الدعم';
  static const String supportCenterWhatsApp = 'مركز الدعم (واتساب)';
  static const String termsAndConditions = 'الشروط والأحكام';
  static const String privacyPolicy = 'سياسة الخصوصية';
  static const String aboutApp = 'عن التطبيق';
  static const String rateApp = 'تقييم التطبيق';
  static const String darkMode = 'الوضع الداكن';
  static const String darkModeActive = 'الوضع الداكن (مفعّل)';
  static const String logoutConfirmTitle = 'تسجيل الخروج';
  static const String logoutConfirmMessage =
      'هل أنت متأكد من أنك تريد تسجيل الخروج؟';
  static const String logoutSuccess = 'تم تسجيل الخروج بنجاح';

  // ── 18. Validation, Errors & Success Messages ────────────────────────────
  static const String requiredField = 'هذا الحقل مطلوب';
  static const String invalidEmail =
      'البريد الإلكتروني غير صالح، يرجى إدخال بريد صحيح.';
  static const String passwordMinLength =
      'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
  static const String passwordMismatch =
      'تأكيد كلمة المرور غير متطابق مع كلمة المرور الجديدة';
  static const String selectAreaPrompt = 'يرجى اختيار المنطقة / القرية';
  static const String invalidCredentials =
      'رقم الهاتف أو كلمة المرور غير صحيحة، يرجى التأكد من البيانات والمحاولة مجدداً';
  static const String phoneAlreadyRegistered =
      'رقم الهاتف مسجل بالفعل، يرجى تسجيل الدخول أو استخدام رقم آخر';
  static const String emailAlreadyRegistered =
      'البريد الإلكتروني مسجل بالفعل، يرجى استخدام بريد آخر';
  static const String userNotFound =
      'الحساب غير مسجل لدينا، يرجى التأكد من رقم الهاتف أو إنشاء حساب جديد';
  static const String accountInactive =
      'هذا الحساب معطل أو موقوف، يرجى التواصل مع الدعم الفني';
  static const String tooManyAttempts =
      'تم تجاوز عدد محاولات الدخول، يرجى الانتظار قليلاً والمحاولة مجدداً';
  static const String invalidReferralCode =
      'كود الإحالة (الدعوة) غير صحيح أو غير متوفر حالياً';
  static const String currentPasswordIncorrect =
      'كلمة المرور الحالية غير صحيحة، يرجى التأكد منها';
  static const String genericError = 'حدث خطأ، يرجى المحاولة لاحقاً';
  static const String serverError = 'حدث خطأ في الخادم. يرجى المحاولة لاحقاً.';
  static const String networkError =
      'تعذر الاتصال بالشبكة، يرجى التحقق من اتصالك بالإنترنت';
  static const String timeoutError =
      'انتهت مهلة الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت والمحاولة مجدداً.';
  static const String unauthorizedError =
      'انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول';
  static const String sessionExpired = 'انتهت صلاحية الجلسة';
  static const String sessionExpiredDetailed =
      'انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول.';
  static const String unexpectedError =
      'حدث خطأ غير متوقع. يرجى المحاولة لاحقاً.';
}

