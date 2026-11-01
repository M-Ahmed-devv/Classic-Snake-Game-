import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../widgets/pixel_button.dart';
import 'game_screen.dart';
import 'high_scores_screen.dart';
import 'how_to_play_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildLogo(),
              const SizedBox(height: 18),
              _buildPhoneArt(),
              const SizedBox(height: 22),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      PixelButton(
                        label: 'Play',
                        icon: Icons.play_arrow_rounded,
                        primary: true,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const GameScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      PixelButton(
                        label: 'High Scores',
                        icon: Icons.emoji_events_rounded,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const HighScoresScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      PixelButton(
                        label: 'Settings',
                        icon: Icons.settings_rounded,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const SettingsScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      PixelButton(
                        label: 'How to Play',
                        icon: Icons.help_outline_rounded,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const HowToPlayScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      PixelButton(
                        label: 'Exit',
                        icon: Icons.logout_rounded,
                        onPressed: () => SystemNavigator.pop(),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                AppConstants.tagline,
                style: GoogleFonts.pressStart2p(
                  color: AppColors.textMuted,
                  fontSize: 9,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        const Icon(Icons.pest_control_rodent_outlined,
            color: AppColors.neonGreen, size: 32),
        const SizedBox(height: 6),
        Text(
          'SNAKE',
          style: GoogleFonts.pressStart2p(
            color: AppColors.neonGreen,
            fontSize: 34,
            letterSpacing: 2,
            shadows: [
              Shadow(
                color: AppColors.neonGreen.withOpacity(0.6),
                blurRadius: 20,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '— CLASSIC —',
          style: GoogleFonts.pressStart2p(
            color: AppColors.yellowGreen,
            fontSize: 11,
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneArt() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFF2A3140),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF4B5467), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF1C2230),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lcdGreen,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.lcdGreenDark, width: 2),
              ),
              child: const Center(
                child: Icon(
                  Icons.pest_control_rodent,
                  color: AppColors.snakeBody,
                  size: 55,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}