import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.neonGreen),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'How to Play',
          style: GoogleFonts.pressStart2p(
            color: AppColors.neonGreen,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          children: [
            _buildRuleCard(
              icon: Icons.swap_calls_rounded,
              title: '1. Directional Controls',
              desc:
                  'Use on-screen buttons or swipe anywhere on the board to direct the snake.',
            ),
            _buildRuleCard(
              icon: Icons.restaurant_rounded,
              title: '2. Eat & Grow',
              desc:
                  'Guide the snake to the pixel food dot to gain score points and grow longer.',
            ),
            _buildRuleCard(
              icon: Icons.block_rounded,
              title: '3. Avoid Walls & Self',
              desc:
                  'Crashing into walls or your own body ends the game immediately.',
            ),
            _buildRuleCard(
              icon: Icons.speed_rounded,
              title: '4. Speed Increases',
              desc:
                  'The game gets progressively faster as your score gets higher!',
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neonGreen,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
                label: const Text('Got It!',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGreen),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.neonGreen.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.neonGreen, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.neonGreen,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}