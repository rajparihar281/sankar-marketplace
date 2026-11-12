import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'custom_button.dart';

class ErrorStateView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;

  const ErrorStateView({
    super.key,
    this.title = 'Oops, something went wrong',
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 52,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Try Again',
              icon: Icons.refresh_rounded,
              onPressed: onRetry,
              height: 44,
            ),
          ],
        ),
      ),
    );
  }
}

