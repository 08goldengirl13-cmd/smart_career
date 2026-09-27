import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/attempt_model.dart';
import '../../services/api_service.dart';
import '../main_navigation_screen.dart';
import '../career/career_detail_screen.dart';

class TestResultScreen extends StatefulWidget {
  final String? attemptId;
  const TestResultScreen({super.key, this.attemptId});

  @override
  State<TestResultScreen> createState() => _TestResultScreenState();
}

class _TestResultScreenState extends State<TestResultScreen> {
  bool _isLoading = true;
  ResultResponse? _resultResponse;

  @override
  void initState() {
    super.initState();
    _fetchResult();
  }

  Future<void> _fetchResult() async {
    if (widget.attemptId != null && widget.attemptId!.isNotEmpty) {
      try {
        final result = await ApiService.instance.getAttemptResult(widget.attemptId!);
        if (mounted) {
          setState(() {
            _resultResponse = result;
            _isLoading = false;
          });
        }
        return;
      } catch (_) {}
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scores = _resultResponse?.scores ?? [];
    final recommendations = _resultResponse?.recommendations ?? [];
    final topScore = scores.isNotEmpty ? scores.first : null;
    final topPercentage = topScore != null ? topScore.percentage.toInt() : 40;
    final topName = topScore != null ? topScore.interestName : "Vizual / Dizayn";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainNavigationScreen(),
              ),
            );
          },
        ),
        title: const Column(
          children: [
            Text(
              "Natijangiz tayyor",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              "Kasbiy mo'ljal testi",
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Qiziqish profili",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 20),

                          SizedBox(
                            height: 140,
                            width: 140,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 130,
                                  width: 130,
                                  child: CircularProgressIndicator(
                                    value: topPercentage / 100,
                                    strokeWidth: 16,
                                    backgroundColor: AppColors.border,
                                    valueColor: const AlwaysStoppedAnimation<Color>(
                                        AppColors.primary),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "$topPercentage%",
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      topName,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          if (scores.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: scores.take(4).map((s) {
                                return _LegendItem(
                                  color: s.percentage > 30
                                      ? AppColors.primary
                                      : AppColors.navyDark,
                                  label: s.interestName.length > 8
                                      ? "${s.interestName.substring(0, 8)}..."
                                      : s.interestName,
                                  value: "${s.percentage.toInt()}%",
                                );
                              }).toList(),
                            )
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                _LegendItem(
                                    color: AppColors.primary, label: "Vizual", value: "40%"),
                                _LegendItem(
                                    color: AppColors.navyDark, label: "Texno", value: "30%"),
                                _LegendItem(
                                    color: AppColors.info, label: "Ijodiy", value: "20%"),
                                _LegendItem(
                                    color: AppColors.success, label: "Boshqa", value: "10%"),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lightbulb_outline_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              "Sizning $topName bo'yicha qobiliyatingiz judayam yuqori!",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    const Text(
                      "Sizga eng mos kasblar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),

                    if (recommendations.isNotEmpty)
                      ...recommendations.map(
                        (rec) => _MatchedCareerCard(
                          title: rec.career.name,
                          category: rec.career.category ?? "IT va Texnologiya",
                          matchPercentage: rec.matchPercentage.toInt(),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CareerDetailScreen(careerId: rec.career.id),
                              ),
                            );
                          },
                        ),
                      )
                    else ...[
                      _MatchedCareerCard(
                        title: "Software Engineer (Dasturchi)",
                        category: "Dasturlash",
                        matchPercentage: 92,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CareerDetailScreen(),
                            ),
                          );
                        },
                      ),
                      _MatchedCareerCard(
                        title: "UX/UI dizayner",
                        category: "Dizayn va IT",
                        matchPercentage: 88,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CareerDetailScreen(),
                            ),
                          );
                        },
                      ),
                      _MatchedCareerCard(
                        title: "Data tahlilchi",
                        category: "Analitika",
                        matchPercentage: 85,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CareerDetailScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainNavigationScreen(),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Bosh sahifaga qaytish"),
                          SizedBox(width: 8),
                          Icon(Icons.home_rounded, size: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _MatchedCareerCard extends StatelessWidget {
  final String title;
  final String category;
  final int matchPercentage;
  final VoidCallback onTap;

  const _MatchedCareerCard({
    required this.title,
    required this.category,
    required this.matchPercentage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.code_rounded, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          category,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "$matchPercentage% mos",
            style: const TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
