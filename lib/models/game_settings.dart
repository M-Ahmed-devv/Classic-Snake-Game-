import '../utils/app_constants.dart';

enum GameSpeed { slow, normal, fast }
enum ControlMode { swipe, buttons }

class GameSettings {
  bool sound;
  bool music;
  bool vibration;
  GameSpeed speed;
  ControlMode controls;
  String theme;

  GameSettings({
    this.sound = true,
    this.music = false,
    this.vibration = true,
    this.speed = GameSpeed.normal,
    this.controls = ControlMode.buttons,
    this.theme = 'classic',
  });

  int get tickMillis {
    switch (speed) {
      case GameSpeed.slow:
        return AppConstants.speedSlow;
      case GameSpeed.fast:
        return AppConstants.speedFast;
      case GameSpeed.normal:
      default:
        return AppConstants.speedNormal;
    }
  }

  static GameSpeed speedFromString(String? s) {
    switch (s) {
      case 'slow':
        return GameSpeed.slow;
      case 'fast':
        return GameSpeed.fast;
      default:
        return GameSpeed.normal;
    }
  }

  static String speedToString(GameSpeed s) {
    switch (s) {
      case GameSpeed.slow:
        return 'slow';
      case GameSpeed.fast:
        return 'fast';
      case GameSpeed.normal:
        return 'normal';
    }
  }

  static ControlMode controlsFromString(String? s) {
    switch (s) {
      case 'swipe':
        return ControlMode.swipe;
      default:
        return ControlMode.buttons;
    }
  }

  static String controlsToString(ControlMode c) {
    switch (c) {
      case ControlMode.swipe:
        return 'swipe';
      case ControlMode.buttons:
        return 'buttons';
    }
  }
}