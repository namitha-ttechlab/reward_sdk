import 'dart:async';
import 'package:flutter/material.dart';


import 'package:google_fonts/google_fonts.dart';
import 'reward_scratch_card.dart';

class RewardCarousel extends StatefulWidget {
  final List<RewardCarouselItem> items;
  final double height;
  final Color secondaryColor;
  final bool autoScroll;
  final Duration scrollInterval;
  final Duration animationDuration;

  const RewardCarousel({
    super.key,
    required this.items,
    this.height = 180,
    this.secondaryColor = Colors.amber,
    this.autoScroll = true,
    this.scrollInterval = const Duration(seconds: 5),
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  State<RewardCarousel> createState() => _RewardCarouselState();
}

class _RewardCarouselState extends State<RewardCarousel> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _stopAutoScroll();
    if (widget.autoScroll && widget.items.isNotEmpty) {
      _timer = Timer.periodic(widget.scrollInterval, (timer) {
        if (_pageController.hasClients) {
          _currentPage = (_currentPage + 1) % widget.items.length;
          _pageController.animateToPage(
            _currentPage,
            duration: widget.animationDuration,
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _stopAutoScroll() {
    _timer?.cancel();
    _timer = null;
  }


  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollStartNotification) {
            _stopAutoScroll();
          } else if (notification is ScrollEndNotification) {
             _startAutoScroll();
          }
          return false;
        },
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return GestureDetector(
            onTap: () {
              if (item.rewardChild != null) {
                RewardScratchCard.showOverlay(
                  context,
                  child: item.rewardChild!,
                  size: item.scratchSize ?? const Size(300, 300),
                  title: item.scratchTitle ?? 'Scratch to Reveal',
                  overlayColor: item.scratchOverlayColor ?? const Color(0xFFBDBDBD),
                  barrierColor: item.scratchBarrierColor ?? const Color(0x99000000),
                  onRevealed: item.onRevealed ?? () {},
                );
              }
              if (item.onTap != null) {
                item.onTap!();
              }
            },
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: item.backgroundColor,
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  image: NetworkImage(item.imageUrl),
                  fit: BoxFit.cover,
                  opacity: 0.4,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: widget.secondaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.tag,
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                          height: 1.4,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      item.title,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                        height: 1.4,
                      ),
                    ),
                    Text(
                      item.subtitle,
                      style: GoogleFonts.outfit(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ));
  }
}

class RewardCarouselItem {
  final String title;
  final String subtitle;
  final String tag;
  final String imageUrl;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final Widget? rewardChild;
  final String? scratchTitle;
  final Color? scratchOverlayColor;
  final Size? scratchSize;
  final Color? scratchBarrierColor;
  final VoidCallback? onRevealed;

  const RewardCarouselItem({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.imageUrl,
    required this.backgroundColor,
    this.onTap,
    this.rewardChild,
    this.scratchTitle,
    this.scratchOverlayColor,
    this.scratchSize,
    this.scratchBarrierColor,
    this.onRevealed,
  });
}
