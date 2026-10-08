import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/widgets/custom_nav_buttons.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart';
import 'package:market/features/profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:market/features/profile/presentation/cubit/edit_profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileEntity? currentProfile;

  const EditProfileScreen({super.key, this.currentProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _areaIdController;

  File? _selectedImageFile;
  String? _currentAvatarUrl;
  bool _isProfileOrAvatarUpdated = false;

  @override
  void initState() {
    super.initState();
    _currentAvatarUrl = widget.currentProfile?.avatarUrl;
    _nameController = TextEditingController(
      text: widget.currentProfile?.fullName ?? '',
    );
    _emailController = TextEditingController(
      text: widget.currentProfile?.email ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.currentProfile?.phoneNumber ?? '',
    );
    _areaIdController = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _areaIdController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (picked != null && mounted) {
        final file = File(picked.path);
        setState(() {
          _selectedImageFile = file;
        });

        final success = await context.read<EditProfileCubit>().uploadAvatar(
          file,
        );
        if (mounted) {
          if (success) {
            _isProfileOrAvatarUpdated = true;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم رفع الصورة الشخصية بنجاح'),
                backgroundColor: context.colors.accentGreen,
              ),
            );
          } else {
            final state = context.read<EditProfileCubit>().state;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.avatarErrorMessage ?? 'فشل في رفع الصورة الشخصية',
                ),
                backgroundColor: context.colors.accentRed,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء اختيار الصورة: $e'),
            backgroundColor: context.colors.accentRed,
          ),
        );
      }
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: context.colors.background,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg.w,
            vertical: AppSpacing.xl.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),
              Text(
                'تغيير الصورة الشخصية',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(AppSpacing.sm.r),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: context.colors.primary,
                  ),
                ),
                title: Text(
                  'التقاط صورة بالكاميرا',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              Divider(height: 1.h),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(AppSpacing.sm.r),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.photo_library_outlined,
                    color: context.colors.primary,
                  ),
                ),
                title: Text(
                  'اختيار من المعرض',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final areaId = int.tryParse(_areaIdController.text.trim()) ?? 1;

    final success = await context.read<EditProfileCubit>().submitEditProfile(
      name: name,
      email: email,
      phone: phone,
      areaId: areaId,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم تعديل البيانات الشخصية بنجاح'),
            backgroundColor: context.colors.accentGreen,
          ),
        );
        context.pop(true);
      } else {
        final state = context.read<EditProfileCubit>().state;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage ?? 'فشل في حفظ التعديلات'),
            backgroundColor: context.colors.accentRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        // If popped with gesture and avatar/profile was updated, ensure result is returned
      },
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: CustomDetailAppBar(
          title: 'تعديل البيانات الشخصية',
          onBack: () => context.pop(_isProfileOrAvatarUpdated),
        ),

        body: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg.r),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.sm.h),

                // Avatar Section
                Center(
                  child: BlocBuilder<EditProfileCubit, EditProfileState>(
                    builder: (context, state) {
                      final avatarUrl =
                          state.updatedProfile?.profile.avatarUrl ??
                          _currentAvatarUrl;
                      final isUploading = state.isUploadingAvatar;

                      return Stack(
                        children: [
                          Container(
                            width: 100.r,
                            height: 100.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: context.colors.primary.withValues(
                                  alpha: 0.3,
                                ),
                                width: 3.w,
                              ),
                            ),
                            child: ClipOval(
                              child: _selectedImageFile != null
                                  ? Image.file(
                                      _selectedImageFile!,
                                      fit: BoxFit.cover,
                                    )
                                  : (avatarUrl != null && avatarUrl.isNotEmpty)
                                  ? Image.network(
                                      avatarUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => Icon(
                                        Icons.person,
                                        size: 50.r,
                                        color: context.colors.primary,
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: 50.r,
                                      color: context.colors.primary,
                                    ),
                            ),
                          ),
                          if (isUploading)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 30.r,
                                    height: 30.r,
                                    child: CircularProgressIndicator(
                                      color: context.colors.textOnPrimary,
                                      strokeWidth: 2.5.r,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: isUploading
                                  ? null
                                  : _showImageSourcePicker,
                              child: Container(
                                padding: EdgeInsets.all((AppSpacing.xs + 2).r),
                                decoration: BoxDecoration(
                                  color: context.colors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 18.r,
                                  color: context.colors.textOnPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                SizedBox(height: AppSpacing.xl.h),

                // Name Field
                Text(
                  'الاسم الكامل',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.xs.h),
                TextFormField(
                  controller: _nameController,
                  style: AppTextStyles.bodyMedium,
                  decoration: _inputDecoration(
                    'أدخل الاسم الكامل',
                    Icons.person_outline,
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'يرجى إدخال الاسم الكامل';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.lg.h),

                // Email Field
                Text(
                  'البريد الإلكتروني',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.xs.h),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: AppTextStyles.bodyMedium,
                  decoration: _inputDecoration(
                    'أدخل البريد الإلكتروني',
                    Icons.email_outlined,
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'يرجى إدخال البريد الإلكتروني';
                    }
                    if (!val.contains('@') || !val.contains('.')) {
                      return 'يرجى إدخال بريد إلكتروني صحيح';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.lg.h),

                // Phone Field
                Text(
                  'رقم الهاتف',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.xs.h),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: AppTextStyles.bodyMedium,
                  decoration: _inputDecoration(
                    'أدخل رقم الهاتف',
                    Icons.phone_outlined,
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'يرجى إدخال رقم الهاتف';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.lg.h),

                // Area ID Field
                Text(
                  'رقم المنطقة (Area ID)',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.xs.h),
                TextFormField(
                  controller: _areaIdController,
                  keyboardType: TextInputType.number,
                  style: AppTextStyles.bodyMedium,
                  decoration: _inputDecoration(
                    'أدخل رقم المنطقة',
                    Icons.location_on_outlined,
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'يرجى إدخال رقم المنطقة';
                    }
                    if (int.tryParse(val.trim()) == null) {
                      return 'يرجى إدخال رقم صحيح';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.xxl.h),

                // Submit Button
                BlocBuilder<EditProfileCubit, EditProfileState>(
                  builder: (context, state) {
                    final isSubmitting =
                        state.status == EditProfileStatus.submitting;

                    return SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: isSubmitting ? null : _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                          foregroundColor: context.colors.textOnPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.md.r,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: isSubmitting
                            ? SizedBox(
                                width: 24.r,
                                height: 24.r,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5.r,
                                  color: context.colors.textOnPrimary,
                                ),
                              )
                            : Text(
                                'حفظ التغييرات',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.searchHint,
      prefixIcon: Icon(icon, color: context.colors.textTertiary, size: 20.r),
      filled: true,
      fillColor: context.colors.backgroundSecondary,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.md.h,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md.r),
        borderSide: BorderSide(color: context.colors.primary, width: 1.5.w),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md.r),
        borderSide: BorderSide(color: context.colors.accentRed, width: 1.w),
      ),
    );
  }
}
