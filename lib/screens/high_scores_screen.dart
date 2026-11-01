import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/local_storage_service.dart';
import '../utils/app_colors.dart';

class HighScoresScreen extends StatefulWidget {
  const HighScoresScreen({Key? key}) : super(key: key);

  @override
  State<HighScoresScreen> createState() => _HighScoresScreenState();
}

class _HighScoresScreenState extends State<HighScoresScreen> {
  List<LocalScoreItem> _scores = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final storage = await LocalStorageService.getInstance();
    setState(() {
      _scores = storage.getLeaderboard();
      _loading = false;
    });
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
          'High Scores',
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
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderGreen),
                      ),
                      child: Row(
                        children: [
                          _tableHeader('#', flex: 1),
                          _tableHeader('Name', flex: 3),
                          _tableHeader('Score', flex: 2, alignRight: true),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _scores.length,
                      itemBuilder: (context, index) {
                        final item = _scores[index];
                        final isTop = index == 0;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isTop
                                ? AppColors.neonGreen.withOpacity(0.15)
                                : AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isTop
                                  ? AppColors.neonGreen
                                  : AppColors.borderGreen,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isTop
                                        ? AppColors.neonGreen
                                        : AppColors.textMuted,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                    color: isTop
                                        ? AppColors.neonGreen
                                        : AppColors.textWhite,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${item.score}',
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.pressStart2p(
                                    color: isTop
                                        ? AppColors.neonGreen
                                        : AppColors.yellowGreen,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      '— Bigger Score, Bigger Pride —',
                      style: GoogleFonts.pressStart2p(
                        color: AppColors.textMuted,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _tableHeader(String title, {required int flex, bool alignRight = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        textAlign: alignRight ? TextAlign.end : TextAlign.start,
        style: GoogleFonts.pressStart2p(
          color: AppColors.textMuted,
          fontSize: 10,
        ),
      ),
    );
  }
}