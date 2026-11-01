import 'package:flutter/material.dart';
import '../models/snake_game_model.dart';
import '../utils/app_colors.dart';

class GameControls extends StatelessWidget {
  final ValueChanged<Direction> onDirection;

  const GameControls({Key? key, required this.onDirection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: _dirButton(Icons.keyboard_arrow_up_rounded,
                () => onDirection(Direction.up)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _dirButton(Icons.keyboard_arrow_down_rounded,
                () => onDirection(Direction.down)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: _dirButton(Icons.keyboard_arrow_left_rounded,
                () => onDirection(Direction.left)),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _dirButton(Icons.keyboard_arrow_right_rounded,
                () => onDirection(Direction.right)),
          ),
        ],
      ),
    );
  }

  Widget _dirButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.card,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderGreen, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.45),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.textWhite, size: 34),
      ),
    );
  }
}