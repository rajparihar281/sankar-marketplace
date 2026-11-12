import 'dart:async';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class BannerCarousel extends StatefulWidget {
  final void Function(int index)? onBannerTap;

  const BannerCarousel({super.key, this.onBannerTap});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Sankar Sealing Systems',
      'subtitle': 'Next-Gen Multi-Layer Steel Gaskets & High-Heat Seals',
      'tag': 'OEM QUALITY',
      'colors': [Color(0xFF0D2240), Color(0xFF1E3A8A)],
      'icon': Icons.precision_manufacturing_rounded,
    },
    {
      'title': 'Industrial Smart IoT',
      'subtitle': 'Predictive Diagnostics & Real-Time Telemetry Sensors',
      'tag': 'NEW LAUNCH',
      'colors': [Color(0xFF1E3A8A), Color(0xFF0284C7)],
      'icon': Icons.sensors_rounded,
    },
    {
      'title': 'Precision CNC Tooling',
      'subtitle': 'Ultra-Hardened Tungsten Carbide End Mills & Bits',
      'tag': 'SAVE UP TO 20%',
      'colors': [Color(0xFF831843), Color(0xFFBE185D)],
      'icon': Icons.handyman_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              final colors = banner['colors'] as List<Color>;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: colors.first.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Background decorative watermark icon
                      Positioned(
                        right: -15,
                        bottom: -15,
                        child: Icon(
                          banner['icon'] as IconData,
                          size: 130,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),

                      // Content
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                banner['tag'] as String,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  banner['title'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  banner['subtitle'] as String,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (index) {
            final isSelected = _currentPage == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isSelected ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondaryLight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

