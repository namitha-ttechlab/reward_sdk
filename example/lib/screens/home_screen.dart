import 'package:flutter/material.dart';
import 'package:reward_sdk/reward_sdk.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<RewardCarouselItem> carouselItems = [
      RewardCarouselItem(
        title: 'Apple Store Credit',
        subtitle: 'Get 50 credit with your Platinum Card',
        tag: 'ULTRA PREMIUM',
        imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&q=80',
        backgroundColor: Colors.black,
        scratchTitle: 'Premium Credit Reveal',
        scratchSize: const Size(320, 320),
        scratchBarrierColor: Colors.black.withOpacity(0.8),
        rewardChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.apple, size: 80, color: Colors.black),
            const SizedBox(height: 16),
            Text('50 Credit', style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold)),
            Text('Applied to your account', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
      RewardCarouselItem(
        title: 'Starbucks Rewards',
        subtitle: '10% Cashback on every morning brew',
        tag: 'DAILY PERKS',
        imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800&q=80',
        backgroundColor: Colors.green[900]!,
        scratchTitle: 'Daily perk Reveal',
        scratchOverlayColor: Colors.green,
        scratchSize: const Size(280, 280),
        rewardChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.coffee, size: 80, color: Colors.brown),
            const SizedBox(height: 16),
            Text('Free Latte', style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold)),
            Text('Redeem at any store', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
      RewardCarouselItem(
        title: 'Emirates Skywards',
        subtitle: 'Earn 2x miles on international bookings',
        tag: 'TRAVEL MAX',
        imageUrl: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&q=80',
        backgroundColor: Colors.red[900]!,
        scratchTitle: 'Airline Miles Reveal',
        scratchOverlayColor: Colors.redAccent,
        scratchSize: const Size(350, 250),
        rewardChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flight_takeoff, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            Text('2,500 Miles', style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold)),
            Text('Credited to Skywards account', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),

    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banking Dashboard Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple[900]!, Colors.deepPurple[700]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Balance',
                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                        ),
                        Text(
                          '45,230.15',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.qr_code_scanner, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuickAction(context, Icons.send_rounded, 'Transfer', '/transfer'),
                    _buildQuickAction(context, Icons.receipt_long_rounded, 'Bills', '/bills'),
                    _buildQuickAction(context, Icons.account_balance_wallet_rounded, 'Top Up', '/topup'),
                    _buildQuickAction(context, Icons.more_horiz_rounded, 'More', null),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Exclusive Partner Offers',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          RewardCarousel(
            items: carouselItems,
            height: 200,
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: RewardBanner(
              title: 'Insurance & Protection',
              subtitle: 'Shield your savings with our new Premium Life Cover.',
              buttonText: 'EXPLORE',
              icon: Icons.shield_rounded,
              onButtonPressed: () {},
              scratchTitle: 'Insurance Voucher',
              scratchOverlayColor: Colors.blueAccent,
              scratchSize: const Size(320, 320),
              rewardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.security, size: 80, color: Colors.blue),
                  const SizedBox(height: 16),
                  Text('15% Discount', style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold)),
                  Text('Valid on first year premium', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Your Coupons',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 12),

          RewardInlineTile(
            title: 'Amazon Shopping',
            subtitle: 'Flat 500 OFF on Electronics',
            couponCode: 'AMZ500',
            icon: Icons.shopping_bag,
            scratchTitle: 'Amazon Coupon',
            scratchSize: const Size(300, 200),
            rewardChild: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 const Icon(Icons.store, size: 80, color: Colors.orange),
                 const SizedBox(height: 16),
                 Text('AMZ500', style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4)),
                 Text('Tap to copy code', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Recent Transactions',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          _buildTransactionItem('Apple Store', '-1,299.00', 'Electronic', Icons.laptop_mac),
          _buildTransactionItem('Starbucks Coffee', '-12.50', 'Dining', Icons.coffee),
          _buildTransactionItem('Salary Credit', '+4,500.00', 'Income', Icons.work),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }


  Widget _buildQuickAction(BuildContext context, IconData icon, String label, String? route) {
    return GestureDetector(
      onTap: () {
        if (route != null) {
          Navigator.pushNamed(context, route);
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String title, String amount, String category, IconData icon) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black87),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(category),
      trailing: Text(
        amount,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: amount.startsWith('+') ? Colors.green : Colors.black,
        ),
      ),
    );
  }
}
