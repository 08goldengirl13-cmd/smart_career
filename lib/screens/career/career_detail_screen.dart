import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/career_model.dart';
import '../../services/api_service.dart';

class CareerDetailScreen extends StatefulWidget {
  final String? careerId;
  const CareerDetailScreen({super.key, this.careerId});

  @override
  State<CareerDetailScreen> createState() => _CareerDetailScreenState();
}

class _CareerDetailScreenState extends State<CareerDetailScreen> {
  int _selectedTabIndex = 0;
  bool _isBookmarked = false;
  bool _isLoading = true;
  Career? _careerDetail;

  final List<String> _tabs = ["Haqida", "Oylik maosh", "Talablar", "Ta'lim"];

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    if (widget.careerId != null && widget.careerId!.isNotEmpty) {
      try {
        final detail = await ApiService.instance.getCareerDetail(widget.careerId!);
        if (mounted) {
          setState(() {
            _careerDetail = detail;
            _isBookmarked = detail.isFavorite;
            _isLoading = false;
          });
        }
        return;
      } catch (_) {}
    }

    // Fallback mock detail for demo
    if (mounted) {
      setState(() {
        _careerDetail = const Career(
          id: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
          name: "Software Engineer (Dasturchi)",
          description:
              "Software Engineer zamonaviy dasturiy ta'minotlar, ilovalar va algoritmlarni ishlab chiqadi. Foydalanuvchilar ehtiyojlarini o'rganib mantiqiy va optimallashgan backend hamda frontend tizimlarini barpo etadi.",
          salaryRange: "8,000,000 - 25,000,000 so'm",
          requiredSkills: ["Mantiqiy fikrlash", "Algoritmlar", "Ingliz tili", "Git", "REST API"],
          education: "TATU, Inha, Amity yoki IT-Akademiya",
          categoryId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
          createdAt: "2026-09-27T06:26:43.120Z",
          matchPercentage: 92,
          category: "Dasturlash",
        );
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final cId = _careerDetail?.id ?? widget.careerId;
    if (cId == null) return;

    final newStatus = !_isBookmarked;
    setState(() {
      _isBookmarked = newStatus;
    });

    try {
      if (newStatus) {
        await ApiService.instance.addToFavorites(cId);
      } else {
        await ApiService.instance.removeFromFavorites(cId);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final career = _careerDetail;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Kasb haqida",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_outline_rounded,
              color: _isBookmarked ? AppColors.primary : AppColors.textPrimary,
            ),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: _isLoading || career == null
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              color: AppColors.navyDark,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Icon(
                                    Icons.code_rounded,
                                    size: 90,
                                    color: AppColors.primary.withValues(alpha: 0.9),
                                  ),
                                ),
                                if (career.matchPercentage != null)
                                  Positioned(
                                    top: 14,
                                    right: 14,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.star_rounded,
                                              color: Colors.amber, size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${career.matchPercentage}% mos",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          Text(
                            career.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            career.category ?? "IT va Texnologiya",
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 20),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(_tabs.length, (index) {
                                final isSelected = _selectedTabIndex == index;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ChoiceChip(
                                    label: Text(_tabs[index]),
                                    selected: isSelected,
                                    selectedColor: AppColors.primary,
                                    backgroundColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.border,
                                      ),
                                    ),
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(() {
                                          _selectedTabIndex = index;
                                        });
                                      }
                                    },
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 24),

                          Row(
                            children: [
                              _MetricCard(
                                icon: Icons.payments_outlined,
                                title: "Oylik maosh",
                                value: career.salaryRange,
                              ),
                              const SizedBox(width: 10),
                              const _MetricCard(
                                icon: Icons.trending_up_rounded,
                                title: "Talab darajasi",
                                value: "Yuqori",
                              ),
                              const SizedBox(width: 10),
                              _MetricCard(
                                icon: Icons.school_outlined,
                                title: "Ta'lim",
                                value: career.education,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          const Text(
                            "Kasb haqida",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              career.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          const Text(
                            "Talab qilinadigan ko'nikmalar",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: career.requiredSkills
                                .map(
                                  (skill) => Chip(
                                    backgroundColor:
                                        AppColors.primaryLight.withValues(alpha: 0.4),
                                    label: Text(
                                      skill,
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    side: BorderSide.none,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Karyera rejasi saqlandi!"),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Karyerani boshlash"),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 20),
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

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
