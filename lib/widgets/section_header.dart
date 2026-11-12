import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText = 'View All',
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        if (onActionTap != null) ...[
          const SizedBox(width: 8),
          InkWell(
            onTap: onActionTap,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.accent : AppColors.primaryLight,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 10,
                    color: isDark ? AppColors.accent : AppColors.primaryLight,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
