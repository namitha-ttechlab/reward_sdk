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
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening Apple Store Offers...')),
        ),
      ),
      RewardCarouselItem(
        title: 'Starbucks Rewards',
        subtitle: '10% Cashback on every morning brew',
        tag: 'DAILY PERKS',
        imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800&q=80',
        backgroundColor: Colors.green[900]!,
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Viewing Starbucks Rewards...')),
        ),
      ),
      RewardCarouselItem(

        title: 'Emirates Skywards',
        subtitle: 'Earn 2x miles on international bookings',
        tag: 'TRAVEL MAX',
        imageUrl: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&q=80',
        backgroundColor: Colors.red[900]!,
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Checking Emirates Miles...')),
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

          const Padding(
            padding: EdgeInsets.all(24.0),
            child: RewardBanner(
              title: 'Insurance & Protection',
              subtitle: 'Shield your savings with our new Premium Life Cover.',
              buttonText: 'EXPLORE',
              icon: Icons.shield_rounded,
              onButtonPressed: _handleExplore,
            ),
          ),

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

  static void _handleExplore() {}

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
