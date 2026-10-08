import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/features/discount_card/domain/entities/category_entity.dart';
import 'package:market/features/discount_card/domain/entities/statistics_entity.dart';
import 'package:market/features/discount_card/presentation/widgets/merchant_tile.dart';

/// Section displaying Partner Merchant Discounts with:
/// 1. Top Statistics Row (3 cards: Partner count, Avg discount, Max discount)
/// 2. "خصومات التجار الشركاء" container with live search & expandable category list
class PartnerDiscountsSection extends StatefulWidget {
  final List<StatisticsEntity> statistics;
  final List<DiscountCategoryEntity> categories;

  const PartnerDiscountsSection({
    super.key,
    required this.statistics,
    required this.categories,
  });

  @override
  State<PartnerDiscountsSection> createState() =>
      _PartnerDiscountsSectionState();
}

class _PartnerDiscountsSectionState extends State<PartnerDiscountsSection> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _expandedCategoryIds = <String>{};
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _normalizeArabic(String text) {
    return text
        .replaceAll(RegExp(r'[أإآ]'), 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .toLowerCase();
  }

  bool _matches(String text, String query) {
    final t = _normalizeArabic(text);
    final q = _normalizeArabic(query);
    return t.contains(q);
  }

  List<DiscountCategoryEntity> get _filteredCategories {
    final query = _searchQuery.trim();
    if (query.isEmpty) return widget.categories;

    return widget.categories.where((cat) {
      final catNameMatches = _matches(cat.name, query);
      final hasMatchingMerchant = cat.merchants.any(
        (m) => _matches(m.name, query),
      );
      return catNameMatches || hasMatchingMerchant;
    }).toList();
  }

  String _getPartnerCount() {
    for (final s in widget.statistics) {
      final t = s.title.toLowerCase();
      if (t.contains('شريك') ||
          t.contains('تاجر') ||
          t.contains('partner') ||
          t.contains('merchant')) {
        return s.value.startsWith('+') ? s.value : '+${s.value}';
      }
    }
    int total = 0;
    for (final c in widget.categories) {
      total += c.merchantsCount;
    }
    return total > 0 ? '+$total' : '+26';
  }

  String _getAvgDiscount() {
    for (final s in widget.statistics) {
      final t = s.title.toLowerCase();
      if (t.contains('متوسط') || t.contains('average') || t.contains('avg')) {
        return s.value.endsWith('%') ? s.value : '${s.value}%';
      }
    }
    return '15%';
  }

  String _getMaxDiscount() {
    for (final s in widget.statistics) {
      final t = s.title.toLowerCase();
      if (t.contains('أقصى') ||
          t.contains('اقصى') ||
          t.contains('max') ||
          t.contains('اعلى') ||
          t.contains('أعلى')) {
        return s.value.endsWith('%') ? s.value : '${s.value}%';
      }
    }
    double max = 0;
    for (final c in widget.categories) {
      if (c.maxDiscount > max) max = c.maxDiscount;
    }
    return max > 0 ? '${max.toInt()}%' : '25%';
  }

  int _getTotalMerchantsCount() {
    int total = 0;
    for (final c in widget.categories) {
      total += c.merchantsCount;
    }
    if (total > 0) return total;
    final p = _getPartnerCount().replaceAll('+', '').trim();
    final parsed = int.tryParse(p);
    return parsed ?? 26;
  }

  IconData _getCategoryIcon(String name) {
    final n = _normalizeArabic(name);
    if (n.contains('ورش') || n.contains('صيانه')) return Icons.build_outlined;
    if (n.contains('اثاث') || n.contains('ديكور') || n.contains('منزل')) {
      return Icons.weekend_outlined;
    }
    if (n.contains('ملابس') || n.contains('ازياء') || n.contains('موضه')) {
      return Icons.checkroom_outlined;
    }
    if (n.contains('مطاعم') ||
        n.contains('ماكولات') ||
        n.contains('طعام') ||
        n.contains('وجبات')) {
      return Icons.restaurant_outlined;
    }
    if (n.contains('كافيه') ||
        n.contains('مقهي') ||
        n.contains('قهوه') ||
        n.contains('شاي')) {
      return Icons.local_cafe_outlined;
    }
    if (n.contains('الكترون') ||
        n.contains('اجهزه') ||
        n.contains('هواتف') ||
        n.contains('موبايل')) {
      return Icons.phone_android_outlined;
    }
    if (n.contains('جيم') ||
        n.contains('رياض') ||
        n.contains('لياقه') ||
        n.contains('بدني')) {
      return Icons.fitness_center_outlined;
    }
    return Icons.storefront_outlined;
  }

  Color _getCategoryColor(String name) {
    final n = _normalizeArabic(name);
    if (n.contains('ورش') || n.contains('صيانه')) {
      return const Color(0xFF2563EB);
    }
    if (n.contains('اثاث') || n.contains('ديكور')) {
      return const Color(0xFF059669);
    }
    if (n.contains('ملابس') || n.contains('ازياء')) {
      return const Color(0xFF7C3AED);
    }
    if (n.contains('مطاعم') || n.contains('ماكولات')) {
      return const Color(0xFFE11D48);
    }
    if (n.contains('كافيه') || n.contains('مقهي') || n.contains('قهوه')) {
      return const Color(0xFFD97706);
    }
    if (n.contains('الكترون') || n.contains('هواتف')) {
      return const Color(0xFF4F46E5);
    }
    if (n.contains('جيم') || n.contains('رياض')) {
      return const Color(0xFF9333EA);
    }
    return const Color(0xFF0284C7);
  }

  Color _getCategoryBgColor(String name) {
    final n = _normalizeArabic(name);
    if (n.contains('ورش') || n.contains('صيانه')) {
      return const Color(0xFFEFF6FF);
    }
    if (n.contains('اثاث') || n.contains('ديكور')) {
      return const Color(0xFFECFDF5);
    }
    if (n.contains('ملابس') || n.contains('ازياء')) {
      return const Color(0xFFF5F3FF);
    }
    if (n.contains('مطاعم') || n.contains('ماكولات')) {
      return const Color(0xFFFFF1F2);
    }
    if (n.contains('كافيه') || n.contains('مقهي') || n.contains('قهوه')) {
      return const Color(0xFFFFFBEB);
    }
    if (n.contains('الكترون') || n.contains('هواتف')) {
      return const Color(0xFFEEF2FF);
    }
    if (n.contains('جيم') || n.contains('رياض')) {
      return const Color(0xFFFAF5FF);
    }
    return const Color(0xFFF0F9FF);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCategories;
    final totalMerchants = _getTotalMerchantsCount();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Top Statistics Row (3 White Cards)
          _buildStatisticsRow(),

          SizedBox(height: 16.h),

          // 2. Partner Merchant Discounts Card
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 14.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with Tag Badge
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFFFFEDD5)),
                      ),
                      child: Icon(
                        Icons.local_offer_outlined,
                        color: const Color(0xFFEA580C),
                        size: 20.r,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'خصومات التجار الشركاء',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '$totalMerchants تاجر معتمد',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14.h),

                // Search Field
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'ابحث عن تاجر أو فئة...',
                      hintStyle: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF94A3B8),
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: const Color(0xFF94A3B8),
                        size: 20.r,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.close_rounded,
                                size: 18.r,
                                color: const Color(0xFF94A3B8),
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 14.h),

                // Category Items
                if (filtered.isEmpty) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Center(
                      child: Text(
                        'لا توجد فئات مطابقة للبحث',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  ...filtered.map((cat) {
                    final isExpanded = _expandedCategoryIds.contains(cat.id);
                    return _buildCategoryTile(cat, isExpanded);
                  }),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsRow() {
    return Row(
      children: [
        // Left in RTL (خصم أقصى - Green)
        Expanded(
          child: _buildStatCard(
            value: _getMaxDiscount(),
            valueColor: const Color(0xFF10B981),
            title: 'خصم أقصى',
          ),
        ),
        SizedBox(width: 8.w),
        // Middle in RTL (متوسط الخصم - Orange)
        Expanded(
          child: _buildStatCard(
            value: _getAvgDiscount(),
            valueColor: const Color(0xFFEA580C),
            title: 'متوسط الخصم',
          ),
        ),
        SizedBox(width: 8.w),
        // Right in RTL (+26 تاجر شريك - Navy/Blue)
        Expanded(
          child: _buildStatCard(
            value: _getPartnerCount(),
            valueColor: const Color(0xFF0369A1),
            title: 'تاجر شريك',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String value,
    required Color valueColor,
    required String title,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(DiscountCategoryEntity category, bool isExpanded) {
    final iconData = _getCategoryIcon(category.name);
    final iconColor = _getCategoryColor(category.name);
    final iconBgColor = _getCategoryBgColor(category.name);

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedCategoryIds.remove(category.id);
                } else {
                  _expandedCategoryIds.add(category.id);
                }
              });
            },
            borderRadius: BorderRadius.circular(14.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Row(
                children: [
                  // Animated Chevron Arrow (Left in RTL)
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: const Color(0xFF94A3B8),
                      size: 22.r,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Orange Discount Pill Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 9.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: const Color(0xFFFFEDD5)),
                    ),
                    child: Text(
                      'حتى ${category.maxDiscount.toInt()}%',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFEA580C),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  // Title & Merchant Count (Right in RTL)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${category.merchantsCount} تاجر',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF64748B),
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  // Category Icon Box
                  Container(
                    width: 42.r,
                    height: 42.r,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Icon(iconData, color: iconColor, size: 20.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expanded Content (Merchants or Info)
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Column(
                    children: [
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      if (category.merchants.isNotEmpty) ...[
                        ...category.merchants.map(
                          (merchant) => InkWell(
                            onTap: () {
                              if (merchant.id.isNotEmpty) {
                                context.push(
                                  '${AppRoutes.merchants}/${merchant.id}',
                                );
                              }
                            },
                            child: MerchantTile(merchant: merchant),
                          ),
                        ),
                      ] else ...[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.storefront_outlined,
                                size: 16.r,
                                color: const Color(0xFF94A3B8),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                'خصومات ${category.name} متاحة لدى التجار الشركاء',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: 4.h),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
