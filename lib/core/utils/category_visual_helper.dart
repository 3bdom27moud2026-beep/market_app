import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Visual metadata for a category, including exact vector SVG icon, pastel colors,
/// and fallback store count.
class CategoryVisualData {
  final String svgContent;
  final Color lightBgColor;
  final Color darkBgColor;
  final Color iconColor;
  final int fallbackStoresCount;

  const CategoryVisualData({
    required this.svgContent,
    required this.lightBgColor,
    required this.darkBgColor,
    required this.iconColor,
    required this.fallbackStoresCount,
  });
}

/// Helper that provides consistent pastel styling, Lucide vector icons, and store counts
/// matching the design mockup across the app.
class CategoryVisualHelper {
  CategoryVisualHelper._();

  // ---------------------------------------------------------------------------
  // Vector SVG definitions (Clean stroke, uniform 17x17 visual bounding box)
  // ---------------------------------------------------------------------------

  /// مطاعم: Fork and Knife
  static const String _svgForkAndKnife =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">'
      '<path d="M5 3.5v5c0 1.5 1 2.5 2 2.5v9.5"/>'
      '<path d="M9 3.5v5c0 1.5-1 2.5-2 2.5"/>'
      '<path d="M7 3.5v5"/>'
      '<path d="M16 3.5v17"/>'
      '<path d="M16 3.5c2.5 0 4 1.8 4 4.5v3.5c0 1.5-1.5 2.5-4 2.5"/>'
      '</svg>';

  /// كافيهات: Coffee cup with steam lines
  static const String _svgCoffee =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">'
      '<path d="M8 2.5v2"/>'
      '<path d="M12 2v2.5"/>'
      '<path d="M16 2.5v2"/>'
      '<path d="M4 8h12v5a4 4 0 0 1-4 4H8a4 4 0 0 1-4-4V8z"/>'
      '<path d="M16 9.5h2a2.5 2.5 0 0 1 0 5h-2"/>'
      '</svg>';

  /// ملابس: Short-sleeve T-shirt (balanced optical size)
  static const String _svgShirt =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">'
      '<path d="M9 4.5a3 3 0 0 0 6 0"/>'
      '<path d="M9 4.5 4 6.5 2 11l3 1.5 1.5-2V20h11V10.5l1.5 2 3-1.5-2-4.5L15 4.5"/>'
      '</svg>';

  /// خدمات منزلية: House outline with arched doorway
  static const String _svgHome =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">'
      '<path d="M3 10.5 12 3.5l9 7V20a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1z"/>'
      '<path d="M9 21v-5a3 3 0 0 1 6 0v5"/>'
      '</svg>';

  /// صيدليات: Stethoscope with earpieces and chestpiece
  static const String _svgStethoscope =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">'
      '<path d="M5 2.5v5.5a5 5 0 0 0 10 0V2.5"/>'
      '<path d="M10 13v3a4 4 0 0 0 4 4h1a4 4 0 0 0 4-4v-3"/>'
      '<circle cx="19" cy="9" r="2.5"/>'
      '<path d="M4 2.5h2"/>'
      '<path d="M14 2.5h2"/>'
      '</svg>';

  /// جيم ورياضة: Dumbbell angled 45 degrees
  static const String _svgDumbbell =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">'
      '<path d="m6.5 6.5 11 11"/>'
      '<path d="m21 21-1-1"/>'
      '<path d="m3 3 1 1"/>'
      '<path d="m18 22 4-4"/>'
      '<path d="m2 6 4-4"/>'
      '<path d="m3 10 7-7"/>'
      '<path d="m14 21 7-7"/>'
      '</svg>';

  /// سوبر ماركت: Shopping Bag
  static const String _svgSupermarket =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">'
      '<path d="M6 2.5 3 6.5v13.5a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6.5l-3-4z"/>'
      '<line x1="3" x2="21" y1="6.5" y2="6.5"/>'
      '<path d="M16 10a4 4 0 0 1-8 0"/>'
      '</svg>';

  /// إلكترونيات / هواتف: Smartphone / Device (scaled to match 17x17 optical size)
  static const String _svgElectronics =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">'
      '<rect width="12" height="17" x="6" y="3.5" rx="2.5" ry="2.5"/>'
      '<line x1="12" x2="12.01" y1="17" y2="17" stroke-width="2"/>'
      '</svg>';

  /// أثاث: Armchair / Sofa
  static const String _svgFurniture =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">'
      '<path d="M19 9V6a2 2 0 0 0-2-2H7a2 2 0 0 0-2 2v3"/>'
      '<path d="M3 11v5a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-5a2 2 0 0 0-4 0v2H7v-2a2 2 0 0 0-4 0z"/>'
      '<path d="M5 18v2"/><path d="M19 18v2"/>'
      '</svg>';

  /// صيانة وورش: Wrench (scaled to match 17x17 optical size)
  static const String _svgWrench =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">'
      '<path d="M14.5 6.5a1 1 0 0 0 0 1.4l1.4 1.4a1 1 0 0 0 1.4 0l3.3-3.3a5.5 5.5 0 0 1-7.3 7.3l-6.3 6.3a2 2 0 0 1-2.8-2.8l6.3-6.3a5.5 5.5 0 0 1 7.3-7.3l-3.3 3.3z"/>'
      '</svg>';

  /// تجميل وعناية: Sparkle / Beauty
  static const String _svgBeauty =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">'
      '<path d="m12 3-1.912 5.813a2 2 0 0 1-1.275 1.275L3 12l5.813 1.912a2 2 0 0 1 1.275 1.275L12 21l1.912-5.813a2 2 0 0 1 1.275-1.275L21 12l-5.813-1.912a2 2 0 0 1-1.275-1.275L12 3Z"/>'
      '</svg>';

  /// سيارات: Car
  static const String _svgCar =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">'
      '<path d="M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-.6 0-1.1.4-1.4.9l-1.4 2.9A3.7 3.7 0 0 0 2 12v4c0 .6.4 1 1 1h2"/>'
      '<circle cx="7" cy="17" r="2"/><circle cx="17" cy="17" r="2"/>'
      '</svg>';

  /// ألعاب: Gamepad
  static const String _svgGames =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">'
      '<line x1="6" x2="10" y1="12" y2="12"/><line x1="8" x2="8" y1="10" y2="14"/>'
      '<line x1="15" x2="15.01" y1="13" y2="13"/><line x1="18" x2="18.01" y1="11" y2="11"/>'
      '<rect width="20" height="12" x="2" y="6" rx="6"/>'
      '</svg>';

  /// Fallback: Grid view
  static const String _svgDefault =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">'
      '<rect width="7" height="7" x="3.5" y="3.5" rx="1"/><rect width="7" height="7" x="13.5" y="3.5" rx="1"/>'
      '<rect width="7" height="7" x="13.5" y="13.5" rx="1"/><rect width="7" height="7" x="3.5" y="13.5" rx="1"/>'
      '</svg>';

  // ---------------------------------------------------------------------------
  // Resolver Method: Enforces curated Pastel Palettes to prevent dark API colors
  // ---------------------------------------------------------------------------

  /// Determines the visual styling (pastel colors, SVG icon, and fallback store count)
  /// based on category name, slug, or icon identifier.
  static CategoryVisualData getVisualData({
    required String name,
    String? slug,
    String? icon,
    String? customColor,
    String? customIconColor,
  }) {
    final nameKey = name.toLowerCase().trim();
    final slugKey = (slug ?? '').toLowerCase().trim();
    final iconKey = (icon ?? '').toLowerCase().trim();

    // 1. مطاعم (Restaurants) -> 128 متجر
    if (nameKey.contains('مطاعم') ||
        nameKey.contains('أكل') ||
        nameKey.contains('طعام') ||
        slugKey == 'food' ||
        slugKey == 'restaurants' ||
        iconKey == 'utensils' ||
        iconKey == 'restaurant') {
      return const CategoryVisualData(
        svgContent: _svgForkAndKnife,
        lightBgColor: Color(0xFFFFF0F0),
        darkBgColor: Color(0xFF2C1518),
        iconColor: Color(0xFFE24C4C),
        fallbackStoresCount: 128,
      );
    }

    // 2. كافيهات (Cafes) -> 96 متجر
    if (nameKey.contains('كافيه') ||
        nameKey.contains('قهوة') ||
        nameKey.contains('مشروب') ||
        slugKey == 'cafe' ||
        slugKey == 'coffee' ||
        iconKey == 'coffee' ||
        iconKey == 'cafe') {
      return const CategoryVisualData(
        svgContent: _svgCoffee,
        lightBgColor: Color(0xFFFFF7ED),
        darkBgColor: Color(0xFF2B1D12),
        iconColor: Color(0xFFD97706),
        fallbackStoresCount: 96,
      );
    }

    // 3. ملابس (Clothing) -> 342 متجر
    if (nameKey.contains('ملابس') ||
        nameKey.contains('أزياء') ||
        nameKey.contains('موضة') ||
        slugKey == 'fashion' ||
        slugKey == 'clothing' ||
        slugKey == 'clothes' ||
        iconKey == 'shirt' ||
        iconKey == 'checkroom') {
      return const CategoryVisualData(
        svgContent: _svgShirt,
        lightBgColor: Color(0xFFEEF2FF),
        darkBgColor: Color(0xFF171A33),
        iconColor: Color(0xFF4F46E5),
        fallbackStoresCount: 342,
      );
    }

    // 4. خدمات منزلية (Home Services) -> 215 متجر
    if (nameKey.contains('منزل') ||
        nameKey.contains('خدمات منزل') ||
        slugKey == 'home' ||
        slugKey == 'home_services' ||
        iconKey == 'home' ||
        iconKey == 'homeicon') {
      return const CategoryVisualData(
        svgContent: _svgHome,
        lightBgColor: Color(0xFFECFDF5),
        darkBgColor: Color(0xFF10281E),
        iconColor: Color(0xFF10B981),
        fallbackStoresCount: 215,
      );
    }

    // 5. صيدليات (Pharmacies) -> 178 متجر
    if (nameKey.contains('صيدل') ||
        nameKey.contains('دواء') ||
        nameKey.contains('علاج') ||
        nameKey.contains('طبي') ||
        slugKey == 'pharmacy' ||
        slugKey == 'medicine' ||
        iconKey == 'stethoscope' ||
        iconKey == 'pharmacy') {
      return const CategoryVisualData(
        svgContent: _svgStethoscope,
        lightBgColor: Color(0xFFFDF2F8),
        darkBgColor: Color(0xFF2E1220),
        iconColor: Color(0xFFDB2777),
        fallbackStoresCount: 178,
      );
    }

    // 6. جيم ورياضة (Gym & Fitness) -> 86 متجر
    if (nameKey.contains('جيم') ||
        nameKey.contains('رياض') ||
        nameKey.contains('لياقة') ||
        slugKey == 'gym' ||
        slugKey == 'fitness' ||
        slugKey == 'sports' ||
        iconKey == 'dumbbell' ||
        iconKey == 'fitness') {
      return const CategoryVisualData(
        svgContent: _svgDumbbell,
        lightBgColor: Color(0xFFF5F3FF),
        darkBgColor: Color(0xFF1F1633),
        iconColor: Color(0xFF7C3AED),
        fallbackStoresCount: 86,
      );
    }

    // 7. هواتف وموبايلات وإلكترونيات -> 95 متجر
    if (nameKey.contains('موبايل') ||
        nameKey.contains('هواتف') ||
        nameKey.contains('إلكترون') ||
        nameKey.contains('أجهزة') ||
        slugKey == 'tech' ||
        slugKey == 'electronics' ||
        slugKey == 'phones' ||
        iconKey == 'smartphone') {
      return const CategoryVisualData(
        svgContent: _svgElectronics,
        lightBgColor: Color(0xFFE0F2FE),
        darkBgColor: Color(0xFF112536),
        iconColor: Color(0xFF0284C7),
        fallbackStoresCount: 95,
      );
    }

    // 8. ورش وصيانة -> 44 متجر
    if (nameKey.contains('صيانة') ||
        nameKey.contains('ورش') ||
        slugKey == 'maintenance' ||
        slugKey == 'repair' ||
        iconKey == 'wrench') {
      return const CategoryVisualData(
        svgContent: _svgWrench,
        lightBgColor: Color(0xFFEFF6FF),
        darkBgColor: Color(0xFF142036),
        iconColor: Color(0xFF2563EB),
        fallbackStoresCount: 44,
      );
    }

    // 9. سوبر ماركت -> 140 متجر
    if (nameKey.contains('سوبر ماركت') ||
        nameKey.contains('بقالة') ||
        slugKey == 'supermarket' ||
        iconKey == 'shoppingbag') {
      return const CategoryVisualData(
        svgContent: _svgSupermarket,
        lightBgColor: Color(0xFFFEF9C3),
        darkBgColor: Color(0xFF2E2710),
        iconColor: Color(0xFFCA8A04),
        fallbackStoresCount: 140,
      );
    }

    // 10. أثاث وديكور -> 62 متجر
    if (nameKey.contains('أثاث') ||
        nameKey.contains('ديكور') ||
        slugKey == 'furniture' ||
        iconKey == 'sofa') {
      return const CategoryVisualData(
        svgContent: _svgFurniture,
        lightBgColor: Color(0xFFF3E8FF),
        darkBgColor: Color(0xFF261536),
        iconColor: Color(0xFF9333EA),
        fallbackStoresCount: 62,
      );
    }

    // 11. تجميل وعناية -> 78 متجر
    if (nameKey.contains('تجميل') ||
        nameKey.contains('عناية') ||
        slugKey == 'beauty') {
      return const CategoryVisualData(
        svgContent: _svgBeauty,
        lightBgColor: Color(0xFFFFF1F2),
        darkBgColor: Color(0xFF2D1216),
        iconColor: Color(0xFFF43F5E),
        fallbackStoresCount: 78,
      );
    }

    // 12. سيارات -> 51 متجر
    if (nameKey.contains('سيارات') || slugKey == 'cars') {
      return const CategoryVisualData(
        svgContent: _svgCar,
        lightBgColor: Color(0xFFEFF6FF),
        darkBgColor: Color(0xFF142036),
        iconColor: Color(0xFF2563EB),
        fallbackStoresCount: 51,
      );
    }

    // 13. ألعاب وترفيه -> 35 متجر
    if (nameKey.contains('ألعاب') || slugKey == 'games') {
      return const CategoryVisualData(
        svgContent: _svgGames,
        lightBgColor: Color(0xFFFDF4FF),
        darkBgColor: Color(0xFF26122E),
        iconColor: Color(0xFFC026D3),
        fallbackStoresCount: 35,
      );
    }

    // Generic fallback with gentle pastel tint (never solid dark or white icon)
    final parsedBase = _parseColor(customColor);
    final safeBg = parsedBase != null
        ? Color.alphaBlend(parsedBase.withValues(alpha: 0.12), Colors.white)
        : const Color(0xFFF8FAFC);
    final safeIcon =
        (parsedBase != null &&
            parsedBase != Colors.white &&
            parsedBase != Colors.transparent)
        ? parsedBase
        : const Color(0xFF64748B);

    return CategoryVisualData(
      svgContent: _svgDefault,
      lightBgColor: safeBg,
      darkBgColor: const Color(0xFF1E293B),
      iconColor: safeIcon,
      fallbackStoresCount: 50,
    );
  }

  /// Builds a rendered icon widget using the vector SVG representation or network image with fallback.
  static Widget buildIconWidget({
    required CategoryVisualData visualData,
    String? networkIconUrl,
    double size = 32,
  }) {
    final rawUrl = (networkIconUrl ?? '').trim();

    if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) {
      if (rawUrl.toLowerCase().endsWith('.svg')) {
        return SvgPicture.network(
          rawUrl,
          width: size,
          height: size,
          colorFilter: ColorFilter.mode(visualData.iconColor, BlendMode.srcIn),
          placeholderBuilder: (_) => SvgPicture.string(
            visualData.svgContent,
            width: size,
            height: size,
            colorFilter: ColorFilter.mode(
              visualData.iconColor,
              BlendMode.srcIn,
            ),
          ),
        );
      }

      return CachedNetworkImage(
        imageUrl: rawUrl,
        width: size,
        height: size,
        fit: BoxFit.contain,
        placeholder: (_, _) => SizedBox(
          width: size * 0.6,
          height: size * 0.6,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: visualData.iconColor.withValues(alpha: 0.5),
          ),
        ),
        errorWidget: (_, _, _) => SvgPicture.string(
          visualData.svgContent,
          width: size,
          height: size,
          colorFilter: ColorFilter.mode(visualData.iconColor, BlendMode.srcIn),
        ),
      );
    }

    return SvgPicture.string(
      visualData.svgContent,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(visualData.iconColor, BlendMode.srcIn),
    );
  }

  static Color? _parseColor(String? hexString) {
    if (hexString == null || hexString.isEmpty) return null;
    try {
      final cleanHex = hexString.replaceAll('#', '').trim();
      if (cleanHex.length == 6) {
        return Color(int.parse('0xFF$cleanHex'));
      } else if (cleanHex.length == 8) {
        return Color(int.parse('0x$cleanHex'));
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
