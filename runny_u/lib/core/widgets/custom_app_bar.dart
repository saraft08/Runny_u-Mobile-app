// lib/core/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';
import '../../config/theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      title: title != null
          ? Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppTheme.secondaryYellow,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'U',
                      style: TextStyle(
                        color: AppTheme.darkGray,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Runny ',
                        style: TextStyle(
                          color: AppTheme.darkGray,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: 'U',
                        style: TextStyle(
                          color: AppTheme.primaryOrange,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}