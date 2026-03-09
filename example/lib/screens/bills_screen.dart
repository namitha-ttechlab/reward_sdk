import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PAY BILLS',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w800, letterSpacing: 1.5, fontSize: 18),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(24),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildBillCategory(Icons.electric_bolt_rounded, 'Electricity', Colors.amber),
          _buildBillCategory(Icons.water_drop_rounded, 'Water', Colors.blue),
          _buildBillCategory(Icons.wifi_rounded, 'Internet', Colors.purple),
          _buildBillCategory(Icons.phone_iphone_rounded, 'Mobile', Colors.green),
          _buildBillCategory(Icons.tv_rounded, 'Television', Colors.red),
          _buildBillCategory(Icons.gas_meter_rounded, 'Gas', Colors.orange),
          _buildBillCategory(Icons.school_rounded, 'Education', Colors.indigo),
          _buildBillCategory(Icons.more_horiz_rounded, 'Others', Colors.grey),
        ],
      ),
    );
  }

  Widget _buildBillCategory(IconData icon, String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
