import 'package:flutter/material.dart';
import 'package:reward_sdk/reward_sdk.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/offers_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/transfer_screen.dart';
import 'screens/bills_screen.dart';
import 'screens/top_up_screen.dart';
import 'widgets/custom_nav_bar.dart';

void main() {
  runApp(const RewardDemoApp());
}

class RewardDemoApp extends StatelessWidget {
  const RewardDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reward SDK Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.deepPurple,
          surface: Colors.grey[50],
        ),
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const MainNavigationScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/transfer': (context) => const TransferScreen(),
        '/bills': (context) => const BillsScreen(),
        '/topup': (context) => const TopUpScreen(),
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const OffersScreen(),
    const ProfileScreen(),
  ];

  final List<String> _titles = [
    'SMART DISCOVERY',
    'EXCLUSIVE OFFERS',
    'YOUR PROFILE',
  ];

  Future<void> _handleExit() async {
    await RewardExitModal.show(
      context,
      title: "Don't Leave Yet!",
      subtitle: 'Scratch and win 50 bonus points just for staying with us 🎁',
      icon: Icons.card_giftcard,
      iconColor: Colors.amber,
      primaryColor: Colors.deepPurple,
      stayButtonText: 'Claim My Reward',
      scratchTitle: 'Your Bonus Reward',
      scratchOverlayColor: Colors.deepPurple,
      onRevealed: () {},
      rewardChild: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.stars_rounded, size: 60, color: Colors.amber),
          const SizedBox(height: 12),
          Text(
            '50 Bonus Points!',
            style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Credited to your account 🎉',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        _handleExit();
      },
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            _titles[_currentIndex],
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w800, 
              letterSpacing: 1.5,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications_outlined, size: 20),
                onPressed: () {
                  Navigator.pushNamed(context, '/notifications');
                },
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
            RewardStickyBadge(
              bottom: 110,
              onTap: () {
                RewardScratchCard.showOverlay(
                  context,
                  title: 'Mystery Achievement',
                  overlayColor: Colors.deepPurple,
                  size: const Size(300, 300),
                  onRevealed: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.stars_rounded, size: 80, color: Colors.amber),
                      const SizedBox(height: 16),
                      Text('Top Saver', style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold)),
                      Text('You reached the milestone!', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: CustomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
