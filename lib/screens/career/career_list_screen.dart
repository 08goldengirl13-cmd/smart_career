import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/career_model.dart';
import '../../services/api_service.dart';
import 'career_detail_screen.dart';

class CareerListScreen extends StatefulWidget {
  const CareerListScreen({super.key});

  @override
  State<CareerListScreen> createState() => _CareerListScreenState();
}

class _CareerListScreenState extends State<CareerListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Career> _careers = [];
  bool _isLoading = true;

  final List<Career> _fallbackCareers = const [
    Career(
      id: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      name: "Software Engineer (Dasturchi)",
      description: "Zamonaviy dasturiy ta'minot mahsulotlari va ilovalarni yaratish.",
      salaryRange: "8,000,000 - 25,000,000 so'm",
      requiredSkills: ["Mantiqiy fikrlash", "Algoritmlar", "Ingliz tili"],
      education: "TATU, Inha, Amity yoki IT-Akademiya",
      categoryId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      createdAt: "2026-09-27T06:26:43.120Z",
      matchPercentage: 92,
      category: "Dasturlash",
    ),
    Career(
      id: "3fa85f64-5717-4562-b3fc-2c963f66afa7",
      name: "UX/UI dizayner",
      description: "Raqamli mahsulotlar interfeysini va foydalanuvchi tajribasini loyihalashtirish.",
      salaryRange: "6,000,000 - 18,000,000 so'm",
      requiredSkills: ["Figma", "Prototiplash", "Wireframing"],
      education: "Oliy ma'lumot yoki dizayn akademiyalari",
      categoryId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      createdAt: "2026-09-27T06:26:43.120Z",
      matchPercentage: 88,
      category: "Dizayn va IT",
    ),
    Career(
      id: "3fa85f64-5717-4562-b3fc-2c963f66afa8",
      name: "Data tahlilchi",
      description: "Katta hajmga ega ma'lumotlarni tahlil qilib, biznes qarorlar qabul qilishga yordam beradi.",
      salaryRange: "10,000,000 - 30,000,000 so'm",
      requiredSkills: ["Python", "SQL", "Tableau"],
      education: "Matematika / IT yo'nalishi",
      categoryId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      createdAt: "2026-09-27T06:26:43.120Z",
      matchPercentage: 85,
      category: "Analitika",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchCareers();
  }

  Future<void> _fetchCareers({String? query}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final careers = await ApiService.instance.getCareers(search: query);
      if (mounted) {
        setState(() {
          _careers = careers.isNotEmpty ? careers : _fallbackCareers;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _careers = _fallbackCareers;
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
              "Kasblar katalogi",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              "Barcha zamonaviy kasblar",
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: TextField(
                controller: _searchController,
                onSubmitted: (query) => _fetchCareers(query: query),
                decoration: InputDecoration(
                  hintText: "Kasb nomi bo'yicha qidiruv...",
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.filter_list_rounded),
                    onPressed: () => _fetchCareers(query: _searchController.text),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20.0),
                      itemCount: _careers.length,
                      itemBuilder: (context, index) {
                        final career = _careers[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CareerDetailScreen(careerId: career.id),
                                ),
                              );
                            },
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.work_outline_rounded,
                                color: AppColors.primary,
                                size: 26,
                              ),
                            ),
                            title: Text(
                              career.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  career.category ?? "IT va Texnologiya",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      career.salaryRange,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.textLight,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
