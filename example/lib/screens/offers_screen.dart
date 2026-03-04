import 'package:flutter/material.dart';
import 'package:reward_sdk/reward_sdk.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/brand_promo_modal.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bank Rewards',
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Unlock special brand partnerships',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Scratch & Win Section
                  Text(
                    'Exclusive Rewards',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      RewardScratchCard.show(
                        context,
                        title: 'Scratch to Reveal Starbucks',
                        onRevealed: () {
                          // Wait a bit for the user to see the reward before showing the modal
                          Future.delayed(const Duration(milliseconds: 1000), () {
                            if (Navigator.canPop(context)) Navigator.pop(context);
                            _showPromotion(
                              context,
                              'Starbucks',
                              'Free Beverage!',
                              'Congrats! You\'ve won a free tall beverage. Claim it at any outlet today.',
                              'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800&q=80',
                              Colors.green[800]!,
                            );
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.coffee, color: Colors.green, size: 50),
                            const SizedBox(height: 8),
                            Text(
                              'FREE COFFEE WON',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold, 
                                color: Colors.green[800],
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.deepPurple[400]!, Colors.deepPurple[700]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -20,
                            top: -20,
                            child: Icon(
                              Icons.stars_rounded,
                              size: 150,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.auto_awesome, color: Colors.orangeAccent, size: 24),
                                    const SizedBox(width: 8),
                                    Text(
                                      'SCRATCH & WIN',
                                      style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tap to unlock your surprise reward',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Partner Coupons',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              GestureDetector(
                onTap: () => _showPromotion(
                  context, 
                  'Adidas', 
                  'Level Up Your Style', 
                  'Get 30% discount on all premium sportswear. Exclusively for Platinum cardholders.', 
                  'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=800&q=80',
                  Colors.black,
                ),
                child: const RewardInlineTile(
                  title: 'Adidas Premium',
                  subtitle: 'Extra 30% off on Sportswear',
                  couponCode: 'ADIBANK30',
                  primaryColor: Colors.black,
                  secondaryColor: Colors.amber,
                  icon: Icons.flash_on,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _showPromotion(
                  context, 
                  'Emirates', 
                  'Fly Premium', 
                  'Redeem 10,000 miles for any international flight. Limited time offer.', 
                  'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&q=80',
                  Colors.red[800]!,
                ),
                child:  RewardInlineTile(
                  title: 'Emirates Skywards',
                  subtitle: 'Redeem 10k Miles Now',
                  couponCode: 'SKYMILES',
                  primaryColor: Colors.redAccent,
                  secondaryColor: Colors.red[100]!,
                  icon: Icons.flight_takeoff,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _showPromotion(
                  context, 
                  'Apple', 
                  'Upgrade to iPhone 15', 
                  'Get 500 trade-in credit when you buy with your bank credit card.', 
                  'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&q=80',
                  Colors.black,
                ),

                child: RewardInlineTile(
                  title: 'Apple Trade-In',
                  subtitle: 'Save 500 on iPhone 15',
                  couponCode: 'APPLEBANK',
                  primaryColor: Colors.grey[800]!,
                  secondaryColor: Colors.blueGrey[100]!,
                  icon: Icons.apple,
                ),
              ),
              const SizedBox(height: 60),
            ]),
          ),
        ],
      ),
    );
  }

  void _showPromotion(BuildContext context, String brand, String title, String desc, String url, Color color) {
    BrandPromoModal.show(
      context, 
      brandName: brand, 
      promoTitle: title, 
      promoDescription: desc, 
      imageUrl: url,
      primaryColor: color,
    );
  }
}
