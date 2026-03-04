import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SETTINGS',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w800, letterSpacing: 1.5, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Account'),
          _buildSettingTile(Icons.person_outline, 'Personal Information', 'Name, email, phone'),
          _buildSettingTile(Icons.security_outlined, 'Security', 'Password, biometric login'),
          _buildSettingTile(Icons.payment_outlined, 'Payment Methods', 'Credit cards, digital wallets'),
          
          _buildSectionHeader('Preferences'),
          _buildSettingTile(Icons.notifications_none_outlined, 'Notifications', 'Push, email, SMS'),
          _buildSettingTile(Icons.language_outlined, 'Language', 'English (US)'),
          _buildSettingTile(Icons.dark_mode_outlined, 'Appearance', 'Light mode'),
          
          _buildSectionHeader('Support'),
          _buildSettingTile(Icons.help_outline, 'Help Center', 'FAQs, customer support'),
          _buildSettingTile(Icons.rule_outlined, 'Terms and Conditions', ''),
          _buildSettingTile(Icons.info_outline, 'About REWARD SDK', 'v1.0.4'),
          
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.redAccent, width: 1),
                ),
              ),
              child: const Text('LOG OUT', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () {},
    );
  }
}
