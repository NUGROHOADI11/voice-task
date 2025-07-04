import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final IconData? titleIcon;
  final Widget? leading;
  final Widget? action;
  final Widget? action2;
  final bool? centerTitle;
  final bool isSearch;
  final ValueChanged<String>? onSearchChanged;

  const CustomAppBar({
    super.key,
    required this.title,
    this.titleIcon,
    this.leading,
    this.action,
    this.action2,
    this.centerTitle,
    this.isSearch = false,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      leading: leading,
      title: isSearch
          ? TextField(
              autofocus: true,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search...'.tr,
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 18),
            )
          : title,
      centerTitle: centerTitle ?? true,
      actions: [
        if (action != null) action!,
        if (action2 != null) action2!,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
