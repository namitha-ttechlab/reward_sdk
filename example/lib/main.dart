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
    final bool? shouldStay = await RewardExitModal.show(
      context,
      title: 'Don\'t Leave Yet!',
      subtitle: 'We have more rewards waiting for you. Are you sure you want to leave?',
      icon: Icons.sentiment_very_dissatisfied,
      iconColor: Colors.redAccent,
    );
    
    if (shouldStay == false) {
      debugPrint('User chose to leave');
    }
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

                RewardBottomSheet.show(
                  context,
                  title: 'New Achievement!',
                  subtitle: 'You just unlocked the "Super Saver" badge!',
                  icon: Icons.auto_awesome,
                  iconColor: Colors.purpleAccent,
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
