import 'package:flutter/material.dart';
import '../models/snake_game_model.dart';
import '../utils/app_colors.dart';

class SnakeBoard extends StatelessWidget {
  final SnakeGameModel game;
  final bool showGrid;

  const SnakeBoard({
    Key? key,
    required this.game,
    this.showGrid = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Keep square-ish board that fits the available space
        final maxW = constraints.maxWidth;
        final maxH = constraints.maxHeight;

        // Cell size based on columns/rows & available space
        final cellW = maxW / game.cols;
        final cellH = maxH / game.rows;
        final cell = cellW < cellH ? cellW : cellH;

        final boardW = cell * game.cols;
        final boardH = cell * game.rows;

        return Center(
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2A14),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.neonGreen, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonGreen.withOpacity(0.25),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomPaint(
                size: Size(boardW, boardH),
                painter: _BoardPainter(game: game, showGrid: showGrid),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BoardPainter extends CustomPainter {
  final SnakeGameModel game;
  final bool showGrid;

  _BoardPainter({required this.game, required this.showGrid});

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / game.cols;

    // LCD background
    final bgPaint = Paint()..color = AppColors.lcdGreen;
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Optional subtle grid
    if (showGrid) {
      final gridPaint = Paint()
        ..color = AppColors.lcdGreenDark.withOpacity(0.25)
        ..strokeWidth = 0.5;
      for (int i = 1; i < game.cols; i++) {
        final x = i * cell;
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      }
      for (int j = 1; j < game.rows; j++) {
        final y = j * cell;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      }
    }

    // Food
    final foodPaint = Paint()..color = AppColors.food;
    _drawPixelCell(canvas, game.food.x, game.food.y, cell, foodPaint,
        inset: cell * 0.18);

    // Snake body
    final bodyPaint = Paint()..color = AppColors.snakeBody;
    for (int i = 0; i < game.snake.length - 1; i++) {
      final c = game.snake[i];
      _drawPixelCell(canvas, c.x, c.y, cell, bodyPaint,
          inset: cell * 0.08);
    }

    // Snake head (slightly darker + full square)
    final headPaint = Paint()..color = AppColors.snakeHead;
    final head = game.snake.last;
    _drawPixelCell(canvas, head.x, head.y, cell, headPaint,
        inset: cell * 0.05);
  }

  void _drawPixelCell(
      Canvas canvas, int gx, int gy, double cell, Paint paint,
      {double inset = 0}) {
    final rect = Rect.fromLTWH(
      gx * cell + inset,
      gy * cell + inset,
      cell - inset * 2,
      cell - inset * 2,
    );
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _BoardPainter oldDelegate) => true;
}