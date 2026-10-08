import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrangeCustomIcon extends StatelessWidget {
  const OrangeCustomIcon({super.key, this.iconData, this.image});
  final IconData? iconData;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: const Color(0xFFEF8226),
        boxShadow: [
          BoxShadow(blurRadius: 3.r, color: Color(0xFFEF8226).withAlpha(99)),
          BoxShadow(blurRadius: 3.r, color: Color(0xFFEF8226).withAlpha(99)),
        ],
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: iconData != null
            ? Icon(iconData, color: Colors.white, size: 22.r)
            : Image.asset(image ?? ''),
      ),
    );
  }
}
