import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopUpScreen extends StatelessWidget {
  const TopUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TOP UP',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w800, letterSpacing: 1.5, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Amount',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildAmountPreset('\$10'),
                _buildAmountPreset('\$20'),
                _buildAmountPreset('\$50', isSelected: true),
                _buildAmountPreset('\$100'),
                _buildAmountPreset('\$200'),
                _buildAmountPreset('\$500'),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Payment Method',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPaymentMethodTile(Icons.credit_card_rounded, 'Visa Card', '**** 4242', Colors.blue),
            _buildPaymentMethodTile(Icons.account_balance_rounded, 'Bank Account', 'Savings ***123', Colors.green),
            _buildPaymentMethodTile(Icons.add_rounded, 'Add New Method', '', Colors.grey, isAction: true),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('PROCEED TO TOP UP', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountPreset(String amount, {bool isSelected = false}) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.deepPurple : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? Colors.deepPurple : Colors.grey[300]!),
      ),
      child: Center(
        child: Text(
          amount,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile(IconData icon, String title, String subtitle, Color color, {bool isAction = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isAction ? color.withOpacity(0.1) : color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
        trailing: isAction ? null : const Icon(Icons.radio_button_off, size: 20, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
