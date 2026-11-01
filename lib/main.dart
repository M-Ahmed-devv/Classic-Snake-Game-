import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'utils/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const SnakeClassicApp());
}

class SnakeClassicApp extends StatelessWidget {
  const SnakeClassicApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Classic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.neonGreen,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.neonGreen,
          secondary: AppColors.yellowGreen,
          background: AppColors.background,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}