
import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/app_constants.dart';

enum Direction { up, down, left, right }

@immutable
class Cell {
  final int x;
  final int y;
  const Cell(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      other is Cell && other.x == x && other.y == y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class SnakeGameModel {
  final int cols;
  final int rows;
  final Random _rng = Random();

  List<Cell> snake = [];
  Cell food = const Cell(0, 0);
  Direction direction = Direction.right;
  Direction _queuedDirection = Direction.right;

  int score = 0;
  bool isGameOver = false;

  SnakeGameModel({
    this.cols = AppConstants.gridColumns,
    this.rows = AppConstants.gridRows,
  }) {
    reset();
  }

  void reset() {
    final cx = cols ~/ 2;
    final cy = rows ~/ 2;
    snake = [
      Cell(cx - 1, cy),
      Cell(cx, cy),
      Cell(cx + 1, cy),
    ];
    direction = Direction.right;
    _queuedDirection = Direction.right;
    score = 0;
    isGameOver = false;
    _spawnFood();
  }

  Cell get head => snake.last;

  void changeDirection(Direction newDir) {
    // Prevent reversing directly into itself
    if (_isOpposite(direction, newDir)) return;
    _queuedDirection = newDir;
  }

  bool _isOpposite(Direction a, Direction b) {
    return (a == Direction.up && b == Direction.down) ||
        (a == Direction.down && b == Direction.up) ||
        (a == Direction.left && b == Direction.right) ||
        (a == Direction.right && b == Direction.left);
  }

  /// Advances one step. Returns true if snake ate food this tick.
  bool tick() {
    if (isGameOver) return false;

    direction = _queuedDirection;

    final h = head;
    int nx = h.x;
    int ny = h.y;

    switch (direction) {
      case Direction.up:
        ny -= 1;
        break;
      case Direction.down:
        ny += 1;
        break;
      case Direction.left:
        nx -= 1;
        break;
      case Direction.right:
        nx += 1;
        break;
    }

    // Wall collision
    if (nx < 0 || ny < 0 || nx >= cols || ny >= rows) {
      isGameOver = true;
      return false;
    }

    final newHead = Cell(nx, ny);

    // Self collision (ignore tail cell because it will move away,
    // but only if we're NOT eating food this tick)
    final willEat = newHead == food;

    for (int i = 0; i < snake.length; i++) {
      // if not eating, tail will move, so skip index 0
      if (!willEat && i == 0) continue;
      if (snake[i] == newHead) {
        isGameOver = true;
        return false;
      }
    }

    snake.add(newHead);
    if (willEat) {
      score += AppConstants.scorePerFood;
      _spawnFood();
    } else {
      snake.removeAt(0);
    }
    return willEat;
  }

  void _spawnFood() {
    // Build set of empty cells
    final occupied = snake.toSet();
    final totalCells = cols * rows;
    if (occupied.length >= totalCells) {
      // Snake fills the board — treat as game over (perfect game)
      isGameOver = true;
      return;
    }
    while (true) {
      final x = _rng.nextInt(cols);
      final y = _rng.nextInt(rows);
      final c = Cell(x, y);
      if (!occupied.contains(c)) {
        food = c;
        return;
      }
    }
  }
}