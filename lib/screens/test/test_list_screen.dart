import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/test_model.dart';
import '../../services/api_service.dart';
import 'test_question_screen.dart';

class TestListScreen extends StatefulWidget {
  const TestListScreen({super.key});

  @override
  State<TestListScreen> createState() => _TestListScreenState();
}

class _TestListScreenState extends State<TestListScreen> {
  List<CareerTest> _tests = [];
  bool _isLoading = true;

  final List<CareerTest> _fallbackTests = const [
    CareerTest(
      id: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      title: "9-sinf yo'nalish testi",
      description:
          "Kasbiy sohangizni va ta'lim yo'lingizni (kollej, litsey, 11-sinf) aniqlang.",
      gradeFrom: 8,
      gradeTo: 9,
      durationMinutes: 15,
      isActive: true,
      questionsCount: 20,
    ),
    CareerTest(
      id: "3fa85f64-5717-4562-b3fc-2c963f66afa7",
      title: "Qiziqishlar testi",
      description:
          "Shaxsiy qiziqishlar va qobiliyatlaringizni har taraflama baholang.",
      gradeFrom: 6,
      gradeTo: 11,
      durationMinutes: 10,
      isActive: true,
      questionsCount: 15,
    ),
    CareerTest(
      id: "3fa85f64-5717-4562-b3fc-2c963f66afa8",
      title: "Qobiliyatlar testi",
      description:
          "Mantiqiy fikrlash va muammolarni hal qilish ko'nikmalaringizni sinab ko'ring.",
      gradeFrom: 6,
      gradeTo: 11,
      durationMinutes: 12,
      isActive: true,
      questionsCount: 18,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchTests();
  }

  Future<void> _fetchTests() async {
    try {
      final tests = await ApiService.instance.getTests();
      if (mounted) {
        setState(() {
          _tests = tests.isNotEmpty ? tests : _fallbackTests;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _tests = _fallbackTests;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Column(
          children: [
            Text(
              "Sizga mos testlar",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              "Kasbiy yo'nalishingizni aniqlang",
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(20.0),
                itemCount: _tests.length,
                itemBuilder: (context, index) {
                  final testItem = _tests[index];
                  final isFeatured = index == 0;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: isFeatured ? AppColors.navyDark : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isFeatured ? Colors.transparent : AppColors.border,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TestQuestionScreen(testId: testItem.id),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isFeatured
                                          ? AppColors.primary
                                          : AppColors.primaryLight
                                              .withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      index == 0
                                          ? Icons.school_rounded
                                          : index == 1
                                              ? Icons.psychology_rounded
                                              : Icons.extension_rounded,
                                      color:
                                          isFeatured ? Colors.white : AppColors.primary,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      testItem.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isFeatured
                                            ? Colors.white
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: isFeatured
                                        ? Colors.white54
                                        : AppColors.textLight,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                testItem.description,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isFeatured
                                      ? AppColors.textLight
                                      : AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    size: 16,
                                    color: isFeatured
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    testItem.duration,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isFeatured
                                          ? Colors.white70
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(
                                    Icons.quiz_outlined,
                                    size: 16,
                                    color: isFeatured
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${testItem.questionCount} ta savol",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isFeatured
                                          ? Colors.white70
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
