import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'New Reward Unlocked!',
        'subtitle': 'You\'ve earned a 20% discount coupon for your next purchase.',
        'time': '2m ago',
        'icon': Icons.card_giftcard,
        'color': Colors.deepPurple,
        'isNew': true,
      },
      {
        'title': 'Points Credited',
        'subtitle': '500 loyalty points have been added to your account for your last order.',
        'time': '1h ago',
        'icon': Icons.stars,
        'color': Colors.amber[700],
        'isNew': true,
      },
      {
        'title': 'Flash Sale Tomorrow',
        'subtitle': 'Get ready for up to 50% off on electronics. Set your reminders!',
        'time': '5h ago',
        'icon': Icons.bolt,
        'color': Colors.blue,
        'isNew': false,
      },
      {
        'title': 'Profile Updated',
        'subtitle': 'Your security settings were updated successfully.',
        'time': 'Yesterday',
        'icon': Icons.security,
        'color': Colors.green,
        'isNew': false,
      },
      {
        'title': 'Welcome to Platinum',
        'subtitle': 'Congratulations on achieving the Platinum membership status.',
        'time': '2 days ago',
        'icon': Icons.workspace_premium,
        'color': Colors.orange,
        'isNew': false,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NOTIFICATIONS',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w800, letterSpacing: 1.5, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notify = notifications[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: notify['color'].withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(notify['icon'], color: notify['color'], size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notify['title'],
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (notify['isNew'])
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notify['subtitle'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notify['time'],
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
