import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;
  final bool showRatingNumber;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 14,
    this.color = AppColors.accent,
    this.showRatingNumber = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final starValue = index + 1;
            if (rating >= starValue) {
              return Icon(Icons.star_rounded, size: size, color: color);
            } else if (rating >= starValue - 0.5) {
              return Icon(Icons.star_half_rounded, size: size, color: color);
            } else {
              return Icon(Icons.star_outline_rounded, size: size, color: color.withValues(alpha: 0.4));
            }
          }),
        ),
        if (showRatingNumber) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.9,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ],
    );
  }
}

