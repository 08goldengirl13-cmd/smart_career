import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../models/auth_model.dart';
import '../models/category_model.dart';
import '../models/career_model.dart';
import '../models/test_model.dart';
import '../models/attempt_model.dart';

class ApiService {
  static final ApiService instance = ApiService._internal();
  factory ApiService() => instance;
  ApiService._internal();

  String baseUrl = "http://localhost:8000";

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<bool> isAuthenticated() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  Future<Map<String, String>> _getHeaders({bool authRequired = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (authRequired) {
      final token = await _getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  dynamic _processResponse(http.Response response) {
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      String errorMessage = "Xatolik yuz berdi (${response.statusCode})";
      if (body is Map && body.containsKey('detail')) {
        if (body['detail'] is String) {
          errorMessage = body['detail'];
        } else if (body['detail'] is List) {
          errorMessage = (body['detail'] as List)
              .map((e) => e['msg'] ?? e.toString())
              .join(', ');
        }
      }
      throw Exception(errorMessage);
    }
  }

  // ==========================================
  // AUTHENTICATION ENDPOINTS (`/api/auth`)
  // ==========================================

  Future<TokenResponse> register({
    required String name,
    required String email,
    required String password,
    required int grade,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: await _getHeaders(authRequired: false),
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'grade': grade,
      }),
    );
    final data = _processResponse(response);
    final tokenRes = TokenResponse.fromJson(data);
    await saveTokens(
      accessToken: tokenRes.accessToken,
      refreshToken: tokenRes.refreshToken,
    );
    return tokenRes;
  }

  Future<TokenResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: await _getHeaders(authRequired: false),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    final data = _processResponse(response);
    final tokenRes = TokenResponse.fromJson(data);
    await saveTokens(
      accessToken: tokenRes.accessToken,
      refreshToken: tokenRes.refreshToken,
    );
    return tokenRes;
  }

  Future<void> logout() async {
    try {
      await http.post(
        Uri.parse('$baseUrl/api/auth/logout'),
        headers: await _getHeaders(authRequired: true),
      );
    } catch (_) {}
    await clearTokens();
  }

  Future<User> getMe() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/me'),
      headers: await _getHeaders(authRequired: true),
    );
    final data = _processResponse(response);
    return User.fromJson(data);
  }

  // ==========================================
  // USERS ENDPOINTS (`/api/users`)
  // ==========================================

  Future<User> getUserProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/me'),
      headers: await _getHeaders(authRequired: true),
    );
    final data = _processResponse(response);
    return User.fromJson(data);
  }

  Future<User> updateUserProfile({
    String? name,
    int? grade,
  }) async {
    final payload = <String, dynamic>{};
    if (name != null) payload['name'] = name;
    if (grade != null) payload['grade'] = grade;

    final response = await http.put(
      Uri.parse('$baseUrl/api/users/me'),
      headers: await _getHeaders(authRequired: true),
      body: jsonEncode(payload),
    );
    final data = _processResponse(response);
    return User.fromJson(data);
  }

  // ==========================================
  // CATEGORIES ENDPOINTS (`/api/categories`)
  // ==========================================

  Future<List<Category>> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/categories'),
      headers: await _getHeaders(authRequired: false),
    );
    final List<dynamic> data = _processResponse(response);
    return data.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Career>> getCareersByCategory(String categoryId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/categories/$categoryId/careers'),
      headers: await _getHeaders(authRequired: false),
    );
    final List<dynamic> data = _processResponse(response);
    return data.map((e) => Career.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ==========================================
  // CAREERS ENDPOINTS (`/api/careers`)
  // ==========================================

  Future<List<Career>> getCareers({
    String? search,
    String? categoryId,
  }) async {
    final queryParams = <String, String>{};
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (categoryId != null && categoryId.isNotEmpty) {
      queryParams['category_id'] = categoryId;
    }

    final uri = Uri.parse('$baseUrl/api/careers').replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: await _getHeaders(authRequired: false),
    );
    final List<dynamic> data = _processResponse(response);
    return data.map((e) => Career.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Career> getCareerDetail(String careerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/careers/$careerId'),
      headers: await _getHeaders(authRequired: true),
    );
    final data = _processResponse(response);
    return Career.fromJson(data);
  }

  // ==========================================
  // TESTS ENDPOINTS (`/api/tests`)
  // ==========================================

  Future<List<CareerTest>> getTests({int? grade}) async {
    final queryParams = <String, String>{};
    if (grade != null) queryParams['grade'] = grade.toString();

    final uri = Uri.parse('$baseUrl/api/tests').replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: await _getHeaders(authRequired: false),
    );
    final List<dynamic> data = _processResponse(response);
    return data.map((e) => CareerTest.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CareerTest> getTestDetail(String testId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/tests/$testId'),
      headers: await _getHeaders(authRequired: false),
    );
    final data = _processResponse(response);
    return CareerTest.fromJson(data);
  }

  Future<List<TestQuestion>> getTestQuestions(String testId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/tests/$testId/questions'),
      headers: await _getHeaders(authRequired: false),
    );
    final List<dynamic> data = _processResponse(response);
    return data.map((e) => TestQuestion.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ==========================================
  // ATTEMPTS & RESULTS (`/api/attempts`)
  // ==========================================

  Future<Attempt> startAttempt(String testId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/attempts'),
      headers: await _getHeaders(authRequired: true),
      body: jsonEncode({'test_id': testId}),
    );
    final data = _processResponse(response);
    return Attempt.fromJson(data);
  }

  Future<void> submitAnswers({
    required String attemptId,
    required List<Map<String, String>> answers,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/attempts/$attemptId/answers'),
      headers: await _getHeaders(authRequired: true),
      body: jsonEncode({'answers': answers}),
    );
    _processResponse(response);
  }

  Future<ResultResponse> completeAttempt(String attemptId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/attempts/$attemptId/complete'),
      headers: await _getHeaders(authRequired: true),
    );
    final data = _processResponse(response);
    return ResultResponse.fromJson(data);
  }

  Future<ResultResponse> getAttemptResult(String attemptId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/attempts/$attemptId/result'),
      headers: await _getHeaders(authRequired: true),
    );
    final data = _processResponse(response);
    return ResultResponse.fromJson(data);
  }

  Future<List<AttemptHistoryItem>> getAttemptHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/attempts/history'),
      headers: await _getHeaders(authRequired: true),
    );
    final List<dynamic> data = _processResponse(response);
    return data.map((e) => AttemptHistoryItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ==========================================
  // FAVORITES ENDPOINTS (`/api/favorites`)
  // ==========================================

  Future<List<Career>> getFavorites() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/favorites'),
      headers: await _getHeaders(authRequired: true),
    );
    final List<dynamic> data = _processResponse(response);
    return data.map((e) {
      final fav = e as Map<String, dynamic>;
      return Career.fromJson(fav['career'] as Map<String, dynamic>);
    }).toList();
  }

  Future<void> addToFavorites(String careerId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/favorites'),
      headers: await _getHeaders(authRequired: true),
      body: jsonEncode({'career_id': careerId}),
    );
    _processResponse(response);
  }

  Future<void> removeFromFavorites(String careerId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/favorites/$careerId'),
      headers: await _getHeaders(authRequired: true),
    );
    _processResponse(response);
  }
}
