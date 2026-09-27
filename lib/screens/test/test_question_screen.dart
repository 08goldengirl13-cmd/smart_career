import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/test_model.dart';
import '../../services/api_service.dart';
import 'test_result_screen.dart';

class TestQuestionScreen extends StatefulWidget {
  final String? testId;
  const TestQuestionScreen({super.key, this.testId});

  @override
  State<TestQuestionScreen> createState() => _TestQuestionScreenState();
}

class _TestQuestionScreenState extends State<TestQuestionScreen> {
  int _currentQuestionIndex = 0;
  int _selectedOptionIndex = -1;
  bool _isLoading = true;
  String? _attemptId;
  List<TestQuestion> _questions = [];
  final Map<String, String> _userAnswers = {};

  final List<TestQuestion> _fallbackQuestions = const [
    TestQuestion(
      id: "q1",
      questionText: "Bo'sh vaqtingizda qaysi faoliyat sizga ko'proq zavq beradi?",
      gradeFrom: 6,
      gradeTo: 11,
      options: [
        AnswerOption(id: "o1", text: "A. Kompyuter dasturlari va o'yinlar yaratish", interestId: "i1", scoreValue: 5),
        AnswerOption(id: "o2", text: "B. Yangi grafik yoki vizual dizaynlar yaratish", interestId: "i2", scoreValue: 5),
        AnswerOption(id: "o3", text: "C. Odamlarga yordam berish va muammolarni hal qilish", interestId: "i3", scoreValue: 5),
        AnswerOption(id: "o4", text: "D. Badiiy asarlar, hikoya va maqolalar yozish", interestId: "i4", scoreValue: 5),
      ],
    ),
    TestQuestion(
      id: "q2",
      questionText: "Murakkab muammoga duch kelganingizda birinchi navbatda nima qilasiz?",
      gradeFrom: 6,
      gradeTo: 11,
      options: [
        AnswerOption(id: "o5", text: "A. Uni mayda qismlarga bo'lib mantiqiy tahlil qilaman", interestId: "i1", scoreValue: 5),
        AnswerOption(id: "o6", text: "B. Muammoning vizual xaritasini va sxemasini chizaman", interestId: "i2", scoreValue: 5),
        AnswerOption(id: "o7", text: "C. Boshqalar bilan maslahatlashib g'oya yig'aman", interestId: "i3", scoreValue: 5),
        AnswerOption(id: "o8", text: "D. Tajriba o'tkazib darhol amalda tekshirib ko'raman", interestId: "i4", scoreValue: 5),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startTestAttempt();
  }

  Future<void> _startTestAttempt() async {
    final tId = widget.testId ?? "3fa85f64-5717-4562-b3fc-2c963f66afa6";
    try {
      final attempt = await ApiService.instance.startAttempt(tId);
      final questions = await ApiService.instance.getTestQuestions(tId);
      if (mounted) {
        setState(() {
          _attemptId = attempt.id;
          _questions = questions.isNotEmpty ? questions : _fallbackQuestions;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _questions = _fallbackQuestions;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _nextQuestion() async {
    if (_selectedOptionIndex == -1) return;

    final currentQ = _questions[_currentQuestionIndex];
    final selectedOption = currentQ.options[_selectedOptionIndex];
    _userAnswers[currentQ.id] = selectedOption.id;

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = -1;
      });
    } else {
      // Complete test
      setState(() {
        _isLoading = true;
      });

      if (_attemptId != null) {
        try {
          final answersList = _userAnswers.entries
              .map((e) => {
                    "question_id": e.key,
                    "answer_option_id": e.value,
                  })
              .toList();
          await ApiService.instance.submitAnswers(
            attemptId: _attemptId!,
            answers: answersList,
          );
          await ApiService.instance.completeAttempt(_attemptId!);
        } catch (_) {}
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TestResultScreen(attemptId: _attemptId),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final currentQ = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Kasbiy mo'ljal testi",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              "${_currentQuestionIndex + 1} / ${_questions.length} savol",
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: AppColors.background,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 4,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.navyDark,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "SAVOL",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      currentQ.questionText,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 32),

                    ...List.generate(currentQ.options.length, (index) {
                      final option = currentQ.options[index];
                      final isSelected = _selectedOptionIndex == index;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.08)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              setState(() {
                                _selectedOptionIndex = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 18),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.textLight,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      option.text,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? AppColors.textPrimary
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: _selectedOptionIndex != -1 ? _nextQuestion : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_currentQuestionIndex == _questions.length - 1
                        ? "Yakunlash"
                        : "Keyingi"),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
