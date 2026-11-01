import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class ScoreHeader extends StatelessWidget {
  final int score;
  final int best;
  final bool isPaused;
  final VoidCallback onPauseToggle;

  const ScoreHeader({
    Key? key,
    required this.score,
    required this.best,
    required this.isPaused,
    required this.onPauseToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onPauseToggle,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderGreen, width: 1.5),
            ),
            child: Icon(
              isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
              color: AppColors.neonGreen,
            ),
          ),
        ),
        const Spacer(),
        _scoreText('Score: ', score),
        const SizedBox(width: 18),
        _scoreText('Best: ', best),
      ],
    );
  }

  Widget _scoreText(String label, int value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: GoogleFonts.pressStart2p(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
          ),
          TextSpan(
            text: '$value',
            style: GoogleFonts.pressStart2p(
              color: AppColors.neonGreen,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}