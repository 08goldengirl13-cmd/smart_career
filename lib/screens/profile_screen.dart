import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/user_model.dart';
import '../models/attempt_model.dart';
import '../models/career_model.dart';
import '../services/api_service.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _darkModeEnabled = false;
  bool _isLoading = true;
  User? _userProfile;
  List<AttemptHistoryItem> _historyItems = [];
  List<Career> _savedCareers = [];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final user = await ApiService.instance.getUserProfile();
      final history = await ApiService.instance.getAttemptHistory();
      final favorites = await ApiService.instance.getFavorites();

      if (mounted) {
        setState(() {
          _userProfile = user;
          _historyItems = history;
          _savedCareers = favorites;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    await ApiService.instance.logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = _userProfile?.name ?? "Aziza Saidova";
    final userGrade = _userProfile?.grade != null ? "${_userProfile!.grade}-sinf o'quvchisi" : "11-sinf o'quvchisi";
    final testCount = _historyItems.isNotEmpty ? _historyItems.length.toString() : "4";
    final savedCount = _savedCareers.isNotEmpty ? _savedCareers.length.toString() : "12";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Profil",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
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
                        color: AppColors.navyDark,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.navyDark.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: AppColors.primary,
                                child: Text(
                                  userName.isNotEmpty ? userName[0].toUpperCase() : "A",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    userGrade,
                                    style: const TextStyle(
                                      color: AppColors.textLight,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Divider(color: Colors.white12),
                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _ProfileStat(value: testCount, label: "O'tilgan testlar"),
                              _ProfileStat(value: savedCount, label: "Saqlanganlar"),
                              const _ProfileStat(value: "75%", label: "Profil to'liqligi"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    const Text(
                      "Test tarixi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_historyItems.isNotEmpty)
                      ..._historyItems.map(
                        (h) => _HistoryTile(
                          title: h.testTitle,
                          date: h.startedAt.split('T').first,
                          score: h.status == 'completed' ? 'Yakunlangan' : 'Jarayonda',
                        ),
                      )
                    else ...[
                      const _HistoryTile(
                        title: "8-9 sinflar kasbiy mo'ljal testi",
                        date: "12 may 2026",
                        score: "92% mos",
                      ),
                      const _HistoryTile(
                        title: "Qiziqishlar va qobiliyat testi",
                        date: "10 may 2026",
                        score: "87% mos",
                      ),
                    ],
                    const SizedBox(height: 28),

                    const Text(
                      "Sozlamalar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.person_outline_rounded,
                                color: AppColors.textPrimary),
                            title: const Text("Shaxsiy ma'lumotlar"),
                            trailing: const Icon(Icons.chevron_right_rounded,
                                color: AppColors.textLight),
                            onTap: () {},
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          SwitchListTile(
                            secondary: const Icon(Icons.dark_mode_outlined,
                                color: AppColors.textPrimary),
                            title: const Text("Tungi rejim"),
                            activeThumbColor: AppColors.primary,
                            value: _darkModeEnabled,
                            onChanged: (val) {
                              setState(() {
                                _darkModeEnabled = val;
                              });
                            },
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          ListTile(
                            leading: const Icon(Icons.logout_rounded,
                                color: Colors.redAccent),
                            title: const Text(
                              "Chiqish",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onTap: _logout,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const _ProfileStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final String title;
  final String date;
  final String score;

  const _HistoryTile({
    required this.title,
    required this.date,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.history_rounded, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          date,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            score,
            style: const TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}
