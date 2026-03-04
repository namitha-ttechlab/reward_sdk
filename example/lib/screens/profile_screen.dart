import 'package:flutter/material.dart';
import 'package:reward_sdk/reward_sdk.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          const CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=400&q=80'),
          ),

          const SizedBox(height: 16),
          Text(
            'Alex Johnson',
            style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'Gold Member Since 2024',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(label: 'Total Orders', value: '42'),
                _StatItem(label: 'Loyalty Points', value: '2.5k'),
                _StatItem(label: 'Saved', value: '120'),
              ],
            ),
          ),
          const Divider(indent: 24, endIndent: 24),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Order History'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('Saved Addresses'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.payment_outlined),
            title: const Text('Payment Methods'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          const SizedBox(height: 100), // Space for Sticky Badge
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      ],
    );
  }
}
