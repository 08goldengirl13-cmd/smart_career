import 'category_model.dart';

class Career {
  final String id;
  final String name;
  final String description;
  final String salaryRange;
  final List<String> requiredSkills;
  final String education;
  final String? imageUrl;
  final String? categoryId;
  final String? createdAt;
  final Category? categoryData;
  final bool isFavorite;
  final int? matchPercentage;
  final String? category;

  const Career({
    required this.id,
    required this.name,
    required this.description,
    required this.salaryRange,
    required this.requiredSkills,
    required this.education,
    this.imageUrl,
    this.categoryId,
    this.createdAt,
    this.categoryData,
    this.isFavorite = false,
    this.matchPercentage,
    this.category,
  });

  String get title => name;

  factory Career.fromJson(Map<String, dynamic> json) {
    return Career(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      salaryRange: json['salary_range'] as String? ?? '',
      requiredSkills: (json['required_skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      education: json['education'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      categoryId: json['category_id'] as String?,
      createdAt: json['created_at'] as String?,
      categoryData: json['category'] != null
          ? Category.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      isFavorite: json['is_favorite'] as bool? ?? false,
      matchPercentage: (json['match_percentage'] as num?)?.toInt(),
      category: json['category'] != null && json['category'] is Map
          ? json['category']['name'] as String?
          : json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'salary_range': salaryRange,
      'required_skills': requiredSkills,
      'education': education,
      'image_url': imageUrl,
      'category_id': categoryId,
      'created_at': createdAt,
      'is_favorite': isFavorite,
      if (categoryData != null) 'category': categoryData!.toJson(),
      if (matchPercentage != null) 'match_percentage': matchPercentage,
    };
  }
}
