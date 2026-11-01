import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_settings.dart';
import '../utils/app_constants.dart';

class LocalScoreItem {
  final String name;
  final int score;
  final String date;

  LocalScoreItem({
    required this.name,
    required this.score,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'score': score,
        'date': date,
      };

  factory LocalScoreItem.fromJson(Map<String, dynamic> json) => LocalScoreItem(
        name: json['name'] ?? 'Player',
        score: json['score'] ?? 0,
        date: json['date'] ?? '',
      );
}

class LocalStorageService {
  static LocalStorageService? _instance;
  static SharedPreferences? _prefs;

  LocalStorageService._();

  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // --- Best Score ---
  int getBestScore() {
    return _prefs?.getInt(AppConstants.keyBestScore) ?? 0;
  }

  Future<bool> saveBestScore(int score) async {
    final current = getBestScore();
    if (score > current) {
      await _prefs?.setInt(AppConstants.keyBestScore, score);
      await addLeaderboardEntry('You', score);
      return true; // New high score!
    }
    return false;
  }

  Future<void> resetBestScore() async {
    await _prefs?.remove(AppConstants.keyBestScore);
    await _prefs?.remove(AppConstants.keyScores);
  }

  // --- Settings ---
  GameSettings getSettings() {
    return GameSettings(
      sound: _prefs?.getBool(AppConstants.keySound) ?? true,
      music: _prefs?.getBool(AppConstants.keyMusic) ?? false,
      vibration: _prefs?.getBool(AppConstants.keyVibration) ?? true,
      speed: GameSettings.speedFromString(
          _prefs?.getString(AppConstants.keySpeed)),
      controls: GameSettings.controlsFromString(
          _prefs?.getString(AppConstants.keyControls)),
      theme: _prefs?.getString(AppConstants.keyTheme) ?? 'classic',
    );
  }

  Future<void> saveSettings(GameSettings settings) async {
    await _prefs?.setBool(AppConstants.keySound, settings.sound);
    await _prefs?.setBool(AppConstants.keyMusic, settings.music);
    await _prefs?.setBool(AppConstants.keyVibration, settings.vibration);
    await _prefs?.setString(
        AppConstants.keySpeed, GameSettings.speedToString(settings.speed));
    await _prefs?.setString(
        AppConstants.keyControls, GameSettings.controlsToString(settings.controls));
    await _prefs?.setString(AppConstants.keyTheme, settings.theme);
  }

  // --- Local Leaderboard ---
  List<LocalScoreItem> getLeaderboard() {
    final rawJson = _prefs?.getString(AppConstants.keyScores);
    if (rawJson == null) return _getDefaultLeaderboard();

    try {
      final List<dynamic> decoded = jsonDecode(rawJson);
      return decoded.map((e) => LocalScoreItem.fromJson(e)).toList();
    } catch (_) {
      return _getDefaultLeaderboard();
    }
  }

  Future<void> addLeaderboardEntry(String name, int score) async {
    final list = getLeaderboard();
    final now = DateTime.now();
    final dateStr = '${now.day}/${now.month}/${now.year}';

    list.add(LocalScoreItem(name: name, score: score, date: dateStr));
    list.sort((a, b) => b.score.compareTo(a.score));

    // Keep top 10
    final top10 = list.take(10).toList();
    final encoded = jsonEncode(top10.map((e) => e.toJson()).toList());
    await _prefs?.setString(AppConstants.keyScores, encoded);
  }

  List<LocalScoreItem> _getDefaultLeaderboard() {
    return [
      LocalScoreItem(name: 'SnakeKing', score: 76, date: 'Classic'),
      LocalScoreItem(name: 'PlayerOne', score: 62, date: 'Classic'),
      LocalScoreItem(name: 'Flash', score: 54, date: 'Classic'),
      LocalScoreItem(name: 'Legend', score: 48, date: 'Classic'),
      LocalScoreItem(name: 'Gamer', score: 41, date: 'Classic'),
      LocalScoreItem(name: 'Noob', score: 32, date: 'Classic'),
      LocalScoreItem(name: 'Rookie', score: 28, date: 'Classic'),
      LocalScoreItem(name: 'SnakeFan', score: 21, date: 'Classic'),
      LocalScoreItem(name: 'Mini', score: 15, date: 'Classic'),
    ];
  }
}