class AppConstants {
  static const String appName = 'Snake Classic';
  static const String tagline = 'Small Screen • Big Fun';

  // Game board grid
  static const int gridColumns = 20;
  static const int gridRows = 24;

  // Speeds (milliseconds per tick) — lower = faster
  static const int speedSlow = 220;
  static const int speedNormal = 160;
  static const int speedFast = 110;
  static const int speedMinimum = 70; // cap when auto-accelerating

  // Score
  static const int scorePerFood = 1;

  // Storage keys
  static const String keyBestScore = 'best_score';
  static const String keySound = 'pref_sound';
  static const String keyMusic = 'pref_music';
  static const String keyVibration = 'pref_vibration';
  static const String keySpeed = 'pref_speed'; // 'slow' | 'normal' | 'fast'
  static const String keyControls = 'pref_controls'; // 'swipe' | 'buttons'
  static const String keyTheme = 'pref_theme'; // 'classic'
  static const String keyScores = 'local_scores'; // JSON list
}