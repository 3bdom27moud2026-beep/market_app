# Project Overview

**Market App** is a Flutter e-commerce mobile application that provides a marketplace experience with product browsing, flash sales, categories, promotions, and location-based services. The app is built with Clean Architecture principles and follows a feature-first folder structure.

The application currently supports:
- Splash screen with animated logo and initialization
- Home screen with multiple sections (offers slider, flash sale, categories, best sellers, partners, newest products)
- Categories browsing with search and filtering
- Flash Sale screen with countdown timer, category/sort filters, and pagination
- Product Details screen with image slider, specifications, and pricing
- Startup promotion dialog
- Location selection (governorates, centers, areas)
- Onboarding flow
- Login page

---

# Architecture

The project follows **Clean Architecture** with three layers per feature:

```
Feature/
├── data/
│   ├── datasource/
│   │   ├── remote/    # API calls via Dio
│   │   └── local/     # SharedPreferences cache
│   ├── models/        # JSON serializable models (extend entities)
│   └── repository/    # Repository implementation
├── domain/
│   ├── entities/      # Business objects (Equatable)
│   ├── repository/    # Abstract repository interface
│   └── usecases/      # Single-responsibility use cases
└── presentation/
    ├── cubit/         # State management (Cubit + State)
    ├── screens/       # Full-screen pages
    └── widgets/       # Reusable UI components
```

**Core layer** (`lib/core/`) contains shared code:
- `constants/` - Colors, text styles, spacing, radius, shadows, durations, assets, icons
- `extensions/` - BuildContext extensions, spacing extensions
- `routes/` - GoRouter configuration and route constants
- `theme/` - ThemeData configuration
- `utils/` - ApiClient (Dio), CacheHelper (SharedPreferences)
- `widgets/` - Shared widgets (e.g., BackgroundGridPainter)

**Dependency Injection** is handled per-feature via static DI classes (e.g., `HomeDI`, `CategoriesDI`, `ProductsDI`, `FlashSaleDI`, `PromotionsDI`, `LocationDI`). Cubits are created in route builders using these DI classes.

---

# Folder Structure

```
lib/
├── main.dart                          # App entry point
├── core/
│   ├── constants/
│   │   ├── app_assets.dart            # Asset paths
│   │   ├── app_colors.dart            # Color palette
│   │   ├── app_durations.dart         # Animation/delay durations
│   │   ├── app_icons.dart             # Icon identifiers
│   │   ├── app_radius.dart            # Border radius values
│   │   ├── app_shadows.dart           # BoxShadow presets
│   │   ├── app_spacing.dart           # Spacing/sizing constants
│   │   ├── app_text_styles.dart       # TextStyle presets
│   │   └── constants.dart             # Barrel export
│   ├── extensions/
│   │   ├── context_extensions.dart    # BuildContext helpers
│   │   └── spacing_extensions.dart    # num extensions for spacing
│   ├── routes/
│   │   ├── app_router.dart            # GoRouter configuration
│   │   └── app_routes.dart            # Route path constants
│   ├── theme/
│   │   └── app_theme.dart             # ThemeData
│   ├── utils/
│   │   ├── api_client.dart            # Dio HTTP client (singleton)
│   │   └── cache_helper.dart          # SharedPreferences wrapper
│   └── widgets/
│       └── background_grid_painter.dart # Custom grid painter
└── features/
    ├── splash/                        # Splash screen
    ├── home/                          # Home screen
    ├── categories/                    # Categories screen
    ├── flash_sale/                    # Flash Sale screen
    ├── products/                      # Product details
    ├── promotions/                    # Startup promotion dialog
    ├── location/                      # Location selection
    ├── onboarding/                    # Onboarding pages
    └── login/                         # Login page
```

---

# State Management

State management is handled using **flutter_bloc** with **Cubits**. Each feature has its own Cubit and State classes.

| Cubit | State | Responsibility |
|-------|-------|----------------|
| `SplashCubit` | `SplashState` (SplashInitial, SplashReady, SplashError) | App initialization, navigation decision |
| `HomeCubit` | `HomeState` | Load/refresh home data, banner auto-play, flash sale timer, newest products filter |
| `CategoriesCubit` | `CategoriesState` (Loading, Loaded, Error, Empty) | Load categories, search, purchase mode toggle |
| `FlashSaleCubit` | `FlashSaleState` | Load flash sale products, category/sort filtering, pagination (load more) |
| `ProductDetailsCubit` | `ProductDetailsState` | Load product details by ID |
| `StartupPromotionCubit` | `StartupPromotionState` | Load promotion, show/hide popup |
| `LocationCubit` | `LocationState` | Load governorates/centers/areas, save selected location |

**Pattern**: Cubits are provided via `BlocProvider` in route builders (GoRouter). The `HomeScreen` uses `MultiBlocProvider` to also provide `StartupPromotionCubit`.

---

# Routing

Routing is handled by **GoRouter** (v17.3.0).

**Route paths** (defined in `AppRoutes`):
| Path | Named Route | Screen |
|------|-------------|--------|
| `/` | `splash` | SplashScreen |
| `/home` | `home` | HomeScreen |
| `/onboarding` | `onboarding` | OnBoardingPage |
| `/login` | `login` | LoginPage |
| `/product-details/:productId` | `product-details` | ProductDetailsScreen |
| `/categories` | `categories` | CategoriesScreen |
| `/flash-sale` | `flash-sale` | FlashSaleScreen |

**Rules**:
- All navigation must use GoRouter (`context.go()`, `context.push()`, `context.pop()`)
- Do NOT use `Navigator.push()`, `Navigator.pushReplacement()`, or `Navigator.of(context)`
- Route paths are centralized in `AppRoutes` - do NOT hardcode in widgets
- Cubits are created in route builders via DI classes

---

# Theme

## Colors (`AppColors`)
- **Primary**: Dark blue palette (`#0D2B4E` to `#2A6CB8`)
- **Background**: White, grey, light grey
- **Text**: White (with opacity variants), black, dark grey, grey, light grey
- **Accent**: Orange (`#FF8C42`), Green (`#4CAF50`), Red (`#E53935`)
- **Discount**: Red, Orange
- **Rating**: Yellow (`#FFC107`), Grey
- **Gradient**: Three-step blue gradient
- **Shadows**: Light, medium, dark

## Typography (`AppTextStyles`)
- **Splash**: Title (36px bold), Subtitle (18px medium)
- **Headings**: Large (22px), Medium (18px), Small (16px)
- **Section**: Title (18px bold), View All (14px)
- **Body**: Large (16px), Medium (14px), Small (12px)
- **White variants**: For dark backgrounds
- **Price**: Current (16px bold), Old (12px line-through), Discount badge (11px bold)
- **Timer**: Number (20px bold), Label (10px)
- **Buttons**: Orange (14px bold), Small (12px)
- **Search**: Hint (14px), Text (14px)
- **Chips**: Selected (13px bold white), Unselected (13px dark grey)
- **Location**: Title (12px), Text (14px bold)
- **Store**: Name (12px), Rating (11px)

## Spacing (`AppSpacing`)
- xs=4, sm=8, md=12, lg=16, xl=20, xxl=24, xxxl=32, huge=48, massive=64

## Radius (`AppRadius`)
- small=8, medium=12, large=16, logoContainer=28

## Shadows (`AppShadows`)
- card, cardElevated, banner, productCard, bottomNav

## Durations (`AppDurations`)
- splashAutoNavigate=3s, animationStep=400ms

## Assets
- Logo: `assets/images/logo_image.png`
- Fonts: `assets/fonts/` (directory exists)
- Icons: Referenced by string identifiers in `AppIcons`

---

# Shared Widgets

| Widget | File | Purpose |
|--------|------|---------|
| `BackgroundGridPainter` | `core/widgets/background_grid_painter.dart` | Custom grid background painter for splash screen |
| `HomeAppBar` | `features/home/presentation/widgets/home_app_bar.dart` | Reusable app bar with cart/notification badges (used in HomeScreen and CategoriesScreen) |
| `HomeSearchBar` | `features/home/presentation/widgets/home_search_bar.dart` | Search bar widget used in home screen |
| `LocationBanner` | `features/home/presentation/widgets/location_banner.dart` | Location display banner |
| `OfferSlider` | `features/home/presentation/widgets/offer_slider.dart` | Auto-playing offers carousel |
| `FlashSaleSection` | `features/home/presentation/widgets/flash_sale_section.dart` | Flash sale section on home |
| `CategoriesSection` | `features/home/presentation/widgets/categories_section.dart` | Categories grid section on home |
| `BestSellerSection` | `features/home/presentation/widgets/best_seller_section.dart` | Best sellers horizontal list |
| `PartnersSection` | `features/home/presentation/widgets/partners_section.dart` | Partners/stores section |
| `ShopGuideCard` | `features/home/presentation/widgets/shopguide_card.dart` | Shopping guide card |
| `NewestProductsSection` | `features/home/presentation/widgets/newest_products_section.dart` | Newest products with filter chips |
| `BestSellerCard` | `features/home/presentation/widgets/best_seller_card.dart` | Best seller product card |
| `FlashSaleProductCard` | `features/home/presentation/widgets/flash_sale_product_card.dart` | Flash sale product card (home) |
| `FlashSaleTimer` | `features/home/presentation/widgets/flash_sale_timer.dart` | Countdown timer display |
| `NewestProductCard` | `features/home/presentation/widgets/newest_product_card.dart` | Newest product card |
| `CategoryItem` | `features/home/presentation/widgets/category_item.dart` | Category icon item |
| `FilterChip` | `features/home/presentation/widgets/filter_chip.dart` | Filter chip for newest products |
| `PartnerItem` | `features/home/presentation/widgets/partner_item.dart` | Partner store item |
| `CategoriesBanner` | `features/categories/presentation/widgets/categories_banner.dart` | Banner at top of categories screen |
| `CategoryTypeSwitch` | `features/categories/presentation/widgets/category_type_switch.dart` | Purchase mode toggle (retail/wholesale) |
| `CategorySearchField` | `features/categories/presentation/widgets/category_search_field.dart` | Search field for categories |
| `CategoriesGrid` | `features/categories/presentation/widgets/categories_grid.dart` | Grid of category cards |
| `CategoryCard` | `features/categories/presentation/widgets/category_card.dart` | Individual category card |
| `CategoriesLoadingWidget` | `features/categories/presentation/widgets/categories_loading.dart` | Loading state for categories |
| `CategoriesErrorWidget` | `features/categories/presentation/widgets/categories_error.dart` | Error state for categories |
| `FlashSaleHeader` | `features/flash_sale/presentation/widgets/flash_sale_header.dart` | Header with back button and countdown |
| `CategoryFilterSection` | `features/flash_sale/presentation/widgets/category_filter_section.dart` | Category filter chips |
| `SortFilterSection` | `features/flash_sale/presentation/widgets/sort_filter_section.dart` | Sort options (price, rating, newest) |
| `FlashSaleGrid` | `features/flash_sale/presentation/widgets/flash_sale_grid.dart` | Product grid with load more |
| `FlashSaleProductCard` | `features/flash_sale/presentation/widgets/flash_sale_product_card.dart` | Product card in flash sale |
| `CountdownTimer` | `features/flash_sale/presentation/widgets/countdown_timer.dart` | Countdown display |
| `DiscountBadge` | `features/flash_sale/presentation/widgets/discount_badge.dart` | Discount percentage badge |
| `StockProgress` | `features/flash_sale/presentation/widgets/stock_progress.dart` | Stock level progress bar |
| `LoadingView` | `features/flash_sale/presentation/widgets/loading_view.dart` | Loading state |
| `ErrorView` | `features/flash_sale/presentation/widgets/error_view.dart` | Error state |
| `EmptyView` | `features/flash_sale/presentation/widgets/empty_view.dart` | Empty state |
| `ProductHeader` | `features/products/presentation/widgets/product_header.dart` | Product details header |
| `ProductImageSlider` | `features/products/presentation/widgets/product_image_slider.dart` | Image carousel |
| `ProductPriceCard` | `features/products/presentation/widgets/product_price_card.dart` | Price display card |
| `ProductSpecificationsCard` | `features/products/presentation/widgets/product_specifications_card.dart` | Specifications list card |
| `SpecificationRow` | `features/products/presentation/widgets/specification_row.dart` | Single specification row |
| `AddToCartButton` | `features/products/presentation/widgets/add_to_cart_button.dart` | Add to cart CTA |
| `DetailsBody` | `features/products/presentation/widgets/details_body.dart` | Product details body |
| `DetailsLoading` | `features/products/presentation/widgets/details_loading.dart` | Loading state |
| `DetailsError` | `features/products/presentation/widgets/details_error.dart` | Error state |
| `StartupPromotionDialog` | `features/promotions/presentation/widgets/startup_promotion_dialog.dart` | Promotion popup dialog |
| `PromotionImage` | `features/promotions/presentation/widgets/promotion_image.dart` | Promotion image display |
| `PromotionDetails` | `features/promotions/presentation/widgets/promotion_details.dart` | Promotion text details |
| `PromotionPrice` | `features/promotions/presentation/widgets/promotion_price.dart` | Promotion pricing |
| `PromotionDiscountBadge` | `features/promotions/presentation/widgets/promotion_discount_badge.dart` | Discount badge |
| `PromotionActionButton` | `features/promotions/presentation/widgets/promotion_action_button.dart` | CTA button |
| `SplashBackground` | `features/splash/presentation/widgets/splash_background.dart` | Animated gradient background |
| `SplashContent` | `features/splash/presentation/widgets/splash_content.dart` | Orchestrates logo, title, subtitle, progress |
| `SplashLogo` | `features/splash/presentation/widgets/splash_logo.dart` | Animated logo |
| `SplashTitle` | `features/splash/presentation/widgets/splash_title.dart` | Animated title |
| `SplashSubtitle` | `features/splash/presentation/widgets/splash_subtitle.dart` | Animated subtitle |
| `SplashProgressIndicator` | `features/splash/presentation/widgets/splash_progress_indicator.dart` | Loading bar |
| `SplashPageIndicator` | `features/splash/presentation/widgets/splash_page_indicator.dart` | Page dots |
| `LocationBottomSheet` | `features/location/presentation/widgets/location_bottom_sheet.dart` | Location picker bottom sheet |
| `LocationDropdown` | `features/location/presentation/widgets/location_dropdown.dart` | Dropdown for location selection |
| `ConfirmLocationButton` | `features/location/presentation/widgets/confirm_location_button.dart` | Confirm button |
| `LocationLoading` | `features/location/presentation/widgets/location_loading.dart` | Loading state |
| `LocationError` | `features/location/presentation/widgets/location_error.dart` | Error state |

---

# Existing Features

1. **Splash** - Animated splash screen with logo, title, subtitle, progress indicator, and auto-navigation
2. **Home** - Main landing page with offers slider, flash sale, categories, best sellers, partners, shop guide, newest products
3. **Categories** - Category grid with banner, purchase mode switch, search, and filtering
4. **Flash Sale** - Flash sale products with countdown, category filter, sort options, and pagination
5. **Product Details** - Product details with image slider, pricing, specifications, and add to cart
6. **Promotions** - Startup promotion dialog with image, details, pricing, discount badge, and action button
7. **Location** - Location selection with governorates, centers, and areas dropdowns
8. **Onboarding** - Onboarding pages (page structure exists)
9. **Login** - Login page (page structure exists)

---

# API Layer

## Dio Configuration (`ApiClient`)
- **Singleton** pattern with `ApiClient.instance`
- **Base URL**: Configured via `init({required String baseUrl})`
- **Timeouts**: 15 seconds for connect, receive, and send
- **Default headers**: `Content-Type: application/json`, `Accept: application/json`
- **Interceptors**:
  - `LogInterceptor` in debug mode (request body, response body, errors)
  - `InterceptorsWrapper` for generic error handling
- **Methods**: `get<T>()`, `post<T>()` with query parameters, options, cancel token support
- **Dispose**: `dispose()` method for testing

## Error Handling
- Errors are returned as `String` messages via `dartz` `Either<Failure, T>` pattern
- Use cases return `Either<String, T>` (String is the error message)
- Cubits handle errors by emitting error states with the error message

## Repository Pattern
- Each feature has an abstract repository interface in `domain/repository/`
- Implementation in `data/repository/` uses remote and local data sources
- Repositories return `Future<Either<String, T>>` from use cases

---

# Models

| Model | Feature | Extends |
|-------|---------|---------|
| `HomeDataModel` | Home | `HomeDataEntity` |
| `OfferBannerModel` | Home | `OfferBannerEntity` |
| `FlashSaleProductModel` | Home | `FlashSaleProductEntity` |
| `CategoryModel` | Home | `CategoryEntity` |
| `BestSellerModel` | Home | `BestSellerEntity` |
| `PartnerModel` | Home | `PartnerEntity` |
| `NewestProductModel` | Home | `NewestProductEntity` |
| `CategoryModel` | Categories | `CategoryEntity` |
| `BannerModel` | Categories | `BannerEntity` |
| `FlashSaleModel` | Flash Sale | `FlashSaleEntity` |
| `ProductModel` | Products | `ProductEntity` |
| `SpecificationModel` | Products | `SpecificationEntity` |
| `StartupPromotionModel` | Promotions | `StartupPromotionEntity` |
| `GovernorateModel` | Location | `GovernorateEntity` |
| `CenterModel` | Location | `CenterEntity` |
| `AreaModel` | Location | `AreaEntity` |

---

# Entities

| Entity | Properties |
|--------|------------|
| `HomeDataEntity` | offers, flashSale, categories, bestSellers, partners, newestProducts |
| `OfferBannerEntity` | id, image, title, subtitle |
| `FlashSaleProductEntity` | id, name, image, price, oldPrice, discount, stock, totalStock |
| `CategoryEntity` (Home) | id, name, image |
| `BestSellerEntity` | id, name, store, image, price, oldPrice, discount, rating |
| `PartnerEntity` | id, name, image, rating |
| `NewestProductEntity` | id, name, store, image, price, oldPrice, discount, rating |
| `CategoryEntity` (Categories) | id, name, image, productCount |
| `BannerEntity` | id, image, title |
| `FlashSaleEntity` | id, name, image, price, oldPrice, discount, stock, totalStock, categoryId, categoryName, rating |
| `ProductEntity` | id, name, store, image, price, oldPrice, discount, rating, isFavorite, description, specifications |
| `SpecificationEntity` | name, value |
| `StartupPromotionEntity` | id, image, title, description, price, oldPrice, discount, actionText |
| `GovernorateEntity` | id, name |
| `CenterEntity` | id, name, governorateId |
| `AreaEntity` | id, name, centerId |
| `CountdownEntity` | days, hours, minutes, seconds |

---

# Repositories

| Repository | Responsibility |
|------------|----------------|
| `HomeRepository` | Fetch home screen data (offers, flash sale, categories, best sellers, partners, newest products) |
| `CategoriesRepository` | Fetch categories and banner |
| `FlashSaleRepository` | Fetch flash sale products with pagination |
| `ProductsRepository` | Fetch product details by ID |
| `StartupPromotionRepository` | Fetch startup promotion, check if already shown |
| `LocationRepository` | Fetch governorates, centers, areas, save selected location |

---

# Reusable Components

**Always reuse these existing components instead of creating duplicates:**

1. **`AppColors`** - All color constants. Never hardcode hex values.
2. **`AppTextStyles`** - All text styles. Never hardcode TextStyle in widgets.
3. **`AppSpacing`** - All spacing/sizing constants. Never hardcode padding/margin values.
4. **`AppRadius`** - All border radius values. Never hardcode BorderRadius.
5. **`AppShadows`** - All box shadow presets. Never hardcode BoxShadow.
6. **`AppDurations`** - All animation/delay durations. Never hardcode Duration.
7. **`AppAssets`** - All asset paths. Never hardcode asset strings.
8. **`AppIcons`** - All icon identifiers. Never hardcode icon strings.
9. **`AppRoutes`** - All route paths. Never hardcode route strings.
10. **`ContextExtensions`** - `context.screenWidth`, `context.screenHeight`, `context.isTablet`, `context.isDesktop`, `context.theme`, `context.pop()`, etc.
11. **`SpacingExtensions`** - `16.horizontalSpace`, `8.verticalSpace`, `12.allPadding`, etc.
12. **`HomeAppBar`** - Reusable app bar with cart/notification badges. Used in HomeScreen and CategoriesScreen.
13. **`BackgroundGridPainter`** - Custom painter for grid backgrounds.
14. **`CacheHelper`** - SharedPreferences wrapper for caching onboarding status, login status, and selected location.
15. **`ApiClient`** - Singleton Dio HTTP client.

---

# Naming Convention

- **Files**: `snake_case.dart` (e.g., `home_screen.dart`, `app_colors.dart`)
- **Classes**: `PascalCase` (e.g., `HomeScreen`, `AppColors`, `HomeCubit`)
- **Methods/Functions**: `camelCase` (e.g., `loadHome()`, `changeBanner()`)
- **Variables**: `camelCase` (e.g., `productId`, `selectedFilter`)
- **Constants**: `camelCase` (e.g., `splashAutoNavigate`, `logoContainerSize`)
- **Private members**: Prefix with `_` (e.g., `_cubit`, `_hasNavigated`)
- **Files follow feature structure**: `feature_name/presentation/screens/screen_name.dart`
- **Widget files**: `widget_name.dart` (e.g., `category_card.dart`)
- **Cubit files**: `feature_name_cubit.dart` and `feature_name_state.dart`
- **Model files**: `model_name_model.dart`
- **Entity files**: `entity_name_entity.dart`
- **Repository files**: `feature_name_repository.dart` (interface), `feature_name_repository_impl.dart` (implementation)
- **Use case files**: `verb_noun_usecase.dart` (e.g., `get_home_data.dart`)
- **DI files**: `dependency_injection.dart`

---

# Coding Rules

1. **Clean Architecture** - Follow feature-first structure with domain/data/presentation layers
2. **SOLID Principles** - Single responsibility, Open/closed, Liskov substitution, Interface segregation, Dependency inversion
3. **Stateless widgets** whenever possible; use StatefulWidget only when necessary (e.g., animations, lifecycle management)
4. **Widgets under 200 lines** - Keep widgets focused and small; extract sub-widgets as needed
5. **No duplicated code** - Always check PROJECT_CONTEXT.md for existing components before creating new ones
6. **Reuse existing components** - Use AppColors, AppTextStyles, AppSpacing, AppRadius, AppShadows, AppDurations, ContextExtensions, SpacingExtensions
7. **Responsive design** - Use `context.screenWidth`, `context.isTablet`, `context.isDesktop` for adaptive layouts
8. **Production-ready code** - Handle loading, error, and empty states for all data-driven screens
9. **GoRouter for navigation** - Never use Navigator.push() or Navigator.of(context)
10. **Route paths in AppRoutes** - Never hardcode route strings in widgets
11. **Cubit for state management** - Use flutter_bloc Cubits, not setState for complex state
12. **Equatable for entities** - All entities extend Equatable for proper equality
13. **dartz Either for error handling** - Use cases return `Either<String, T>`
14. **Dependency injection via static DI classes** - Create dependencies in route builders
15. **Precache images** - Pre-cache important images (like logo) to avoid jank

---

# Responsive Rules

- Use `context.screenWidth` and `context.screenHeight` from `ContextExtensions` for responsive sizing
- Tablet breakpoint: `screenWidth >= 600` (`context.isTablet`)
- Desktop breakpoint: `screenWidth >= 1024` (`context.isDesktop`)
- Use `MediaQuery` padding and viewInsets via `context.padding` and `context.viewInsets`
- Use `SpacingExtensions` for quick responsive gaps: `16.horizontalSpace`, `8.verticalSpace`
- Avoid hardcoded pixel values; use `AppSpacing` constants
- Shimmer loading placeholders should match the layout structure

---

# Important Notes

1. **Splash screen** uses a navigation guard (`_hasNavigated` flag) to prevent multiple navigation calls. Both animation completion and app initialization must complete before navigation.
2. **Home screen** loads data in `initState` via `addPostFrameCallback` to avoid calling during build.
3. **Flash Sale** has its own product card widget separate from the home flash sale product card.
4. **Categories** has its own `CategoryEntity` and `CategoryModel` separate from Home's `CategoryEntity`.
5. **Promotions** feature uses both remote and local data sources (local to track if promotion was already shown).
6. **Location** feature saves selected location IDs to SharedPreferences via `CacheHelper`.
7. **The app is in Arabic** (RTL) - UI text is in Arabic (e.g., "إعادة المحاولة", "لا توجد فئات متاحة", "منتج").
8. **The app uses Material3** (`useMaterial3: true`).
9. **`flutter_native_splash`** package is configured but the native splash config is in `flutter_native_splash.yaml`.
10. **Assets directory** `assets/images/` contains the logo image; `assets/fonts/` directory exists for custom fonts.
11. **The `constants.dart` barrel file** exports all constant classes for convenient importing.
12. **`ApiClient.init()` must be called** before making API requests (currently not called in `main.dart` - needs to be added).
13. **`CacheHelper.init()` is called** in both `main.dart` and `SplashCubit.initializeApp()` (duplicate call - `SplashCubit` should be updated to remove the duplicate).
14. **Home screen** provides `StartupPromotionCubit` via `MultiBlocProvider` and loads the promotion after home data is loaded.
15. **The `_HomeShimmerLoading` widget** is defined inside `home_screen.dart` and is not reusable from other screens.