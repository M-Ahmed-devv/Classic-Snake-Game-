import 'dart:async';
import 'package:flutter/material.dart';
import '../models/snake_game_model.dart';
import '../services/local_storage_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../widgets/game_controls.dart';
import '../widgets/score_header.dart';
import '../widgets/snake_board.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  late SnakeGameModel _game;
  Timer? _timer;
  bool _isPaused = false;
  int _bestScore = 0;
  int _tickMs = AppConstants.speedNormal;

  LocalStorageService? _storage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _game = SnakeGameModel();
    _loadBestScore();
    _startLoop();
  }

  Future<void> _loadBestScore() async {
    _storage = await LocalStorageService.getInstance();
    if (mounted) {
      setState(() {
        _bestScore = _storage?.getBestScore() ?? 0;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      _pause();
    }
  }

  void _startLoop() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: _tickMs), (_) {
      if (_isPaused) return;
      final ate = _game.tick();
      if (_game.isGameOver) {
        _timer?.cancel();
        _onGameOver();
        return;
      }
      if (ate) {
        _maybeAccelerate();
      }
      setState(() {});
    });
  }

  void _maybeAccelerate() {
    final target = (AppConstants.speedNormal - (_game.score ~/ 5) * 6)
        .clamp(AppConstants.speedMinimum, AppConstants.speedNormal);
    if (target != _tickMs) {
      _tickMs = target;
      _startLoop();
    }
  }

  void _pause() {
    if (!_isPaused) {
      setState(() => _isPaused = true);
    }
  }

  void _resume() {
    if (_isPaused) {
      setState(() => _isPaused = false);
    }
  }

  void _togglePause() {
    _isPaused ? _resume() : _pause();
    if (_isPaused) _showPauseDialog();
  }

  void _restart() {
    setState(() {
      _game.reset();
      _isPaused = false;
      _tickMs = AppConstants.speedNormal;
    });
    _startLoop();
  }

  void _onGameOver() async {
    if (_storage != null) {
      await _storage!.saveBestScore(_game.score);
      if (mounted) {
        setState(() {
          _bestScore = _storage!.getBestScore();
        });
      }
    }

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _GameOverDialog(
        score: _game.score,
        best: _bestScore,
        onPlayAgain: () {
          Navigator.of(context).pop();
          _restart();
        },
        onMainMenu: () {
          Navigator.of(context).pop(); // close dialog
          Navigator.of(context).pop(); // leave game screen
        },
      ),
    );
  }

  void _showPauseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _PauseDialog(
        onResume: () {
          Navigator.of(context).pop();
          _resume();
        },
        onRestart: () {
          Navigator.of(context).pop();
          _restart();
        },
        onMainMenu: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _handleDirection(Direction d) {
    _game.changeDirection(d);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _pause();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                ScoreHeader(
                  score: _game.score,
                  best: _bestScore,
                  isPaused: _isPaused,
                  onPauseToggle: _togglePause,
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: GestureDetector(
                    onVerticalDragEnd: (d) {
                      if (d.primaryVelocity == null) return;
                      if (d.primaryVelocity! < 0) {
                        _handleDirection(Direction.up);
                      } else if (d.primaryVelocity! > 0) {
                        _handleDirection(Direction.down);
                      }
                    },
                    onHorizontalDragEnd: (d) {
                      if (d.primaryVelocity == null) return;
                      if (d.primaryVelocity! < 0) {
                        _handleDirection(Direction.left);
                      } else if (d.primaryVelocity! > 0) {
                        _handleDirection(Direction.right);
                      }
                    },
                    child: SnakeBoard(game: _game),
                  ),
                ),
                const SizedBox(height: 12),
                GameControls(onDirection: _handleDirection),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- Pause Dialog ----------------

class _PauseDialog extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onMainMenu;

  const _PauseDialog({
    Key? key,
    required this.onResume,
    required this.onRestart,
    required this.onMainMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.neonGreen, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.neonGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonGreen.withOpacity(0.5),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(Icons.pause_rounded,
                  size: 36, color: Colors.black),
            ),
            const SizedBox(height: 14),
            const Text(
              'Game Paused',
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            _dialogButton('Resume', Icons.play_arrow_rounded, onResume,
                primary: true),
            const SizedBox(height: 10),
            _dialogButton('Restart', Icons.refresh_rounded, onRestart),
            const SizedBox(height: 10),
            _dialogButton('Main Menu', Icons.home_rounded, onMainMenu),
          ],
        ),
      ),
    );
  }

  Widget _dialogButton(String label, IconData icon, VoidCallback onTap,
      {bool primary = false}) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: primary ? Colors.black : AppColors.textWhite),
        label: Text(label,
            style: TextStyle(
              color: primary ? Colors.black : AppColors.textWhite,
              fontWeight: FontWeight.bold,
            )),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              primary ? AppColors.neonGreen : const Color(0xFF1A2436),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: primary ? AppColors.neonGreenDark : AppColors.borderGreen,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- Game Over Dialog ----------------

class _GameOverDialog extends StatelessWidget {
  final int score;
  final int best;
  final VoidCallback onPlayAgain;
  final VoidCallback onMainMenu;

  const _GameOverDialog({
    Key? key,
    required this.score,
    required this.best,
    required this.onPlayAgain,
    required this.onMainMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.lcdGreen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.neonGreen, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Game Over',
              style: TextStyle(
                color: Color(0xFF0E1A05),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Icon(Icons.pest_control_rodent,
                color: Color(0xFF0E1A05), size: 70),
            const SizedBox(height: 12),
            Text('Your Score: $score',
                style: const TextStyle(
                    color: Color(0xFF0E1A05),
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('Best Score: $best',
                style: const TextStyle(
                    color: Color(0xFF0E1A05),
                    fontSize: 16,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onPlayAgain,
                icon: const Icon(Icons.refresh_rounded, color: Colors.black),
                label: const Text('Play Again',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neonGreen,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onMainMenu,
                icon: const Icon(Icons.home_rounded, color: Colors.white),
                label: const Text('Main Menu',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A2436),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
