import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/game_settings.dart';
import '../services/local_storage_service.dart';
import '../utils/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  LocalStorageService? _storage;
  GameSettings _settings = GameSettings();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _storage = await LocalStorageService.getInstance();
    setState(() {
      _settings = _storage!.getSettings();
      _loading = false;
    });
  }

  Future<void> _save() async {
    await _storage?.saveSettings(_settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.neonGreen),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.pressStart2p(
            color: AppColors.neonGreen,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.neonGreen))
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                children: [
                  _sectionHeader('AUDIO'),
                  _buildSwitchTile(
                    title: 'Sound Effects',
                    icon: Icons.volume_up_rounded,
                    value: _settings.sound,
                    onChanged: (v) {
                      setState(() => _settings.sound = v);
                      _save();
                    },
                  ),
                  _buildSwitchTile(
                    title: 'Vibration',
                    icon: Icons.vibration_rounded,
                    value: _settings.vibration,
                    onChanged: (v) {
                      setState(() => _settings.vibration = v);
                      _save();
                    },
                  ),
                  const SizedBox(height: 20),
                  _sectionHeader('GAMEPLAY'),
                  _buildOptionTile(
                    title: 'Speed',
                    icon: Icons.speed_rounded,
                    valueText: _settings.speed.name.toUpperCase(),
                    onTap: _cycleSpeed,
                  ),
                  _buildOptionTile(
                    title: 'Controls',
                    icon: Icons.gamepad_rounded,
                    valueText: _settings.controls.name.toUpperCase(),
                    onTap: _cycleControls,
                  ),
                  const SizedBox(height: 20),
                  _sectionHeader('DATA'),
                  _buildActionTile(
                    title: 'Reset Best Score',
                    icon: Icons.delete_forever_rounded,
                    color: Colors.redAccent,
                    onTap: _confirmReset,
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: [
                        const Icon(Icons.pest_control_rodent,
                            color: AppColors.textMuted, size: 40),
                        const SizedBox(height: 8),
                        Text(
                          '— Keep Going! —',
                          style: GoogleFonts.pressStart2p(
                            color: AppColors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.pressStart2p(
          color: AppColors.textMuted,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGreen),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: AppColors.neonGreen),
        title: Text(title,
            style: const TextStyle(
                color: AppColors.textWhite, fontWeight: FontWeight.w600)),
        activeColor: AppColors.neonGreen,
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required IconData icon,
    required String valueText,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGreen),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.neonGreen),
        title: Text(title,
            style: const TextStyle(
                color: AppColors.textWhite, fontWeight: FontWeight.w600)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(valueText,
                style: const TextStyle(
                    color: AppColors.yellowGreen, fontWeight: FontWeight.bold)),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color),
        title: Text(title,
            style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      ),
    );
  }

  void _cycleSpeed() {
    setState(() {
      switch (_settings.speed) {
        case GameSpeed.slow:
          _settings.speed = GameSpeed.normal;
          break;
        case GameSpeed.normal:
          _settings.speed = GameSpeed.fast;
          break;
        case GameSpeed.fast:
          _settings.speed = GameSpeed.slow;
          break;
      }
    });
    _save();
  }

  void _cycleControls() {
    setState(() {
      _settings.controls = _settings.controls == ControlMode.buttons
          ? ControlMode.swipe
          : ControlMode.buttons;
    });
    _save();
  }

  void _confirmReset() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.redAccent)),
        title: const Text('Reset Score?', style: TextStyle(color: Colors.white)),
        content: const Text(
            'This will permanently delete your best score and local leaderboard records.',
            style: TextStyle(color: AppColors.textMuted)),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              await _storage?.resetBestScore();
              if (mounted) {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Best score reset successfully!')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}