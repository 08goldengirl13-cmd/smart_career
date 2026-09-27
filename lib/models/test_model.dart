class CareerTest {
  final String id;
  final String title;
  final String description;
  final int gradeFrom;
  final int gradeTo;
  final int durationMinutes;
  final bool isActive;
  final int questionsCount;

  const CareerTest({
    required this.id,
    required this.title,
    required this.description,
    required this.gradeFrom,
    required this.gradeTo,
    required this.durationMinutes,
    required this.isActive,
    required this.questionsCount,
  });

  String get duration => "$durationMinutes daqiqa";
  int get questionCount => questionsCount;

  factory CareerTest.fromJson(Map<String, dynamic> json) {
    return CareerTest(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      gradeFrom: (json['grade_from'] as num?)?.toInt() ?? 6,
      gradeTo: (json['grade_to'] as num?)?.toInt() ?? 11,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt() ?? 20,
      isActive: json['is_active'] as bool? ?? true,
      questionsCount: (json['questions_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'grade_from': gradeFrom,
      'grade_to': gradeTo,
      'duration_minutes': durationMinutes,
      'is_active': isActive,
      'questions_count': questionsCount,
    };
  }
}

class AnswerOption {
  final String id;
  final String text;
  final String interestId;
  final int scoreValue;

  const AnswerOption({
    required this.id,
    required this.text,
    required this.interestId,
    required this.scoreValue,
  });

  factory AnswerOption.fromJson(Map<String, dynamic> json) {
    return AnswerOption(
      id: json['id'] as String? ?? '',
      text: json['text'] as String? ?? '',
      interestId: json['interest_id'] as String? ?? '',
      scoreValue: (json['score_value'] as num?)?.toInt() ?? 5,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'interest_id': interestId,
      'score_value': scoreValue,
    };
  }
}

class TestQuestion {
  final String id;
  final String questionText;
  final int gradeFrom;
  final int gradeTo;
  final List<AnswerOption> options;

  const TestQuestion({
    required this.id,
    required this.questionText,
    required this.gradeFrom,
    required this.gradeTo,
    required this.options,
  });

  factory TestQuestion.fromJson(Map<String, dynamic> json) {
    return TestQuestion(
      id: json['id'] as String? ?? '',
      questionText: json['text'] as String? ?? '',
      gradeFrom: (json['grade_from'] as num?)?.toInt() ?? 6,
      gradeTo: (json['grade_to'] as num?)?.toInt() ?? 11,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => AnswerOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': questionText,
      'grade_from': gradeFrom,
      'grade_to': gradeTo,
      'options': options.map((e) => e.toJson()).toList(),
    };
  }
}
