import 'career_model.dart';

class Attempt {
  final String id;
  final String testId;
  final String userId;
  final String status;
  final String startedAt;
  final String? completedAt;

  const Attempt({
    required this.id,
    required this.testId,
    required this.userId,
    required this.status,
    required this.startedAt,
    this.completedAt,
  });

  factory Attempt.fromJson(Map<String, dynamic> json) {
    return Attempt(
      id: json['id'] as String? ?? '',
      testId: json['test_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      status: json['status'] as String? ?? 'started',
      startedAt: json['started_at'] as String? ?? '',
      completedAt: json['completed_at'] as String?,
    );
  }
}

class AttemptHistoryItem {
  final String id;
  final String testId;
  final String testTitle;
  final String status;
  final String startedAt;
  final String? completedAt;
  final String? topRecommendation;
  final String? topScoreInterest;

  const AttemptHistoryItem({
    required this.id,
    required this.testId,
    required this.testTitle,
    required this.status,
    required this.startedAt,
    this.completedAt,
    this.topRecommendation,
    this.topScoreInterest,
  });

  factory AttemptHistoryItem.fromJson(Map<String, dynamic> json) {
    return AttemptHistoryItem(
      id: json['id'] as String? ?? '',
      testId: json['test_id'] as String? ?? '',
      testTitle: json['test_title'] as String? ?? '',
      status: json['status'] as String? ?? '',
      startedAt: json['started_at'] as String? ?? '',
      completedAt: json['completed_at'] as String?,
      topRecommendation: json['top_recommendation'] as String?,
      topScoreInterest: json['top_score_interest'] as String?,
    );
  }
}

class ScoreItem {
  final String interestCode;
  final String interestName;
  final double percentage;
  final int score;
  final int maxScore;

  const ScoreItem({
    required this.interestCode,
    required this.interestName,
    required this.percentage,
    required this.score,
    required this.maxScore,
  });

  factory ScoreItem.fromJson(Map<String, dynamic> json) {
    return ScoreItem(
      interestCode: json['interest_code'] as String? ?? '',
      interestName: json['interest_name'] as String? ?? '',
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      score: (json['score'] as num?)?.toInt() ?? 0,
      maxScore: (json['max_score'] as num?)?.toInt() ?? 100,
    );
  }
}

class RecommendationItem {
  final Career career;
  final double matchPercentage;

  const RecommendationItem({
    required this.career,
    required this.matchPercentage,
  });

  factory RecommendationItem.fromJson(Map<String, dynamic> json) {
    return RecommendationItem(
      career: Career.fromJson(json['career'] as Map<String, dynamic>? ?? {}),
      matchPercentage: (json['match_percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ResultResponse {
  final String attemptId;
  final List<ScoreItem> scores;
  final List<RecommendationItem> recommendations;
  final String? completedAt;

  const ResultResponse({
    required this.attemptId,
    required this.scores,
    required this.recommendations,
    this.completedAt,
  });

  factory ResultResponse.fromJson(Map<String, dynamic> json) {
    return ResultResponse(
      attemptId: json['attempt_id'] as String? ?? '',
      scores: (json['scores'] as List<dynamic>?)
              ?.map((e) => ScoreItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => RecommendationItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      completedAt: json['completed_at'] as String?,
    );
  }
}
