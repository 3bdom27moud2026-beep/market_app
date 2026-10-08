import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/auth_event_bus.dart';
import '../../orders_di.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';
import '../widgets/order_card.dart';
import 'package:market/core/widgets/custom_nav_buttons.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrdersCubit>(
      create: (context) {
        final cubit = OrdersDI.initCubit();
        cubit.loadOrders();
        return cubit;
      },
      child: const _OrdersContent(),
    );
  }
}

class _OrdersContent extends StatefulWidget {
  const _OrdersContent();

  @override
  State<_OrdersContent> createState() => _OrdersContentState();
}

class _OrdersContentState extends State<_OrdersContent> {
  StreamSubscription<AuthEvent>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = AuthEventBus.instance.stream.listen((event) {
      if (!mounted) return;
      context.read<OrdersCubit>().loadOrders();
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(6.r),
          child: const AppBackButton(),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: const CartBadgeButton(),
          ),
        ],
        title: Text(
          'طلباتي',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
      ),
      body: BlocConsumer<OrdersCubit, OrdersState>(
        listener: (context, state) {
          if (state.cancelMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.cancelMessage!),
                backgroundColor: const Color(0xFF059669),
              ),
            );
          }
          if (state.errorMessage != null && !state.isLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Filter Tabs
              Container(
                color: context.colors.surface,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _filterTab(
                        context: context,
                        label: 'الكل (${state.orders.length})',
                        filter: OrderFilter.all,
                        selected: state.filter == OrderFilter.all,
                      ),
                      SizedBox(width: 8.w),
                      _filterTab(
                        context: context,
                        label: 'قيد المراجعة',
                        filter: OrderFilter.pending,
                        selected: state.filter == OrderFilter.pending,
                      ),
                      SizedBox(width: 8.w),
                      _filterTab(
                        context: context,
                        label: 'المكتملة',
                        filter: OrderFilter.completed,
                        selected: state.filter == OrderFilter.completed,
                      ),
                      SizedBox(width: 8.w),
                      _filterTab(
                        context: context,
                        label: 'الملغاة',
                        filter: OrderFilter.cancelled,
                        selected: state.filter == OrderFilter.cancelled,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              // Orders List / Empty State / Loading
              Expanded(
                child: state.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: context.colors.primary,
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () =>
                            context.read<OrdersCubit>().loadOrders(),
                        color: context.colors.primary,
                        child: state.filteredOrders.isEmpty
                            ? _buildEmptyState(context, state.filter)
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                itemCount: state.filteredOrders.length,
                                itemBuilder: (context, index) {
                                  final order = state.filteredOrders[index];
                                  return OrderCard(
                                    order: order,
                                    onTap: () {
                                      context.push(
                                        AppRoutes.orderDetails,
                                        extra: order,
                                      );
                                    },
                                    onCancelTap: () =>
                                        _showCancelConfirmationDialog(
                                          context,
                                          order.id,
                                        ),
                                  );
                                },
                              ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _filterTab({
    required BuildContext context,
    required String label,
    required OrderFilter filter,
    required bool selected,
  }) {
    return GestureDetector(
      onTap: () => context.read<OrdersCubit>().setFilter(filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected
              ? context.colors.primary
              : context.colors.backgroundSecondary,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : context.colors.textSecondary,
            fontSize: 12.sp,
            fontWeight: selected ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, OrderFilter filter) {
    String title = 'لا توجد طلبات سابقة';
    String subtitle = 'ابدأ بالتسوق الآن واستمتع بأفضل العروض والخصومات!';

    if (filter == OrderFilter.pending) {
      title = 'لا توجد طلبات قيد المراجعة';
    } else if (filter == OrderFilter.completed) {
      title = 'لا توجد طلبات مكتملة';
    } else if (filter == OrderFilter.cancelled) {
      title = 'لا توجد طلبات ملغاة';
    }

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(32.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 90.r,
                    height: 90.r,
                    decoration: BoxDecoration(
                      color: context.colors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      size: 46.r,
                      color: context.colors.primary,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: context.colors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () => context.go(AppRoutes.home),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.accentOrange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'تسوق الآن',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCancelConfirmationDialog(BuildContext context, int orderId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'إلغاء الطلب',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.sp,
            color: context.colors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في إلغاء هذا الطلب؟',
          style: TextStyle(
            fontSize: 13.sp,
            color: context.colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'تراجع',
              style: TextStyle(
                color: context.colors.textSecondary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<OrdersCubit>().cancelOrder(orderId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'تأكيد الإلغاء',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
