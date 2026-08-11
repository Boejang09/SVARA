import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service untuk komunikasi dengan SVARA Backend API.
class ApiService {
  // Untuk Android emulator, gunakan 10.0.2.2
  // Untuk device fisik di jaringan lokal, gunakan IP komputer (contoh: 192.168.1.140)
  // Untuk iOS simulator atau Desktop Windows, gunakan 127.0.0.1
  static const String _baseUrl = 'http://192.168.1.140:8000';
  static String? accessToken;
  static Map<String, dynamic>? currentUser;

  static Future<void> loadSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      accessToken = prefs.getString('access_token');
      final userStr = prefs.getString('current_user');
      if (userStr != null) {
        currentUser = jsonDecode(userStr);
      }
    } catch (_) {
      // Abaikan jika gagal
    }
  }

  static Future<void> _saveSession(String? token, Map<String, dynamic>? user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (token != null) {
        await prefs.setString('access_token', token);
        accessToken = token;
      }
      if (user != null) {
        await prefs.setString('current_user', jsonEncode(user));
        currentUser = user;
      }
    } catch (_) {}
  }

  static Future<void> logout() async {
    try {
      accessToken = null;
      currentUser = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('current_user');
    } catch (_) {}
  }

  static Future<ApiResult> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/api/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(const Duration(seconds: 15));

      final body = _decodeBody(response.body);
      if (response.statusCode == 200) {
        await _saveSession(
          body?['access_token'] as String?,
          body?['user'] as Map<String, dynamic>?,
        );
        return const ApiResult.success();
      }

      return ApiResult.failure(_errorMessage(body, 'Login gagal'));
    } catch (_) {
      return const ApiResult.failure(
        'Tidak dapat terhubung ke backend. Pastikan server SVARA API aktif.',
      );
    }
  }

  static Future<ApiResult> register({
    required String username,
    required String nama,
    required String password,
    String? email,
    String? phone,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/api/auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username,
              'nama': nama,
              'password': password,
              if (email != null && email.isNotEmpty) 'email': email,
              if (phone != null && phone.isNotEmpty) 'phone': phone,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final body = _decodeBody(response.body);
      if (response.statusCode == 201) {
        await _saveSession(
          body?['access_token'] as String?,
          body?['user'] as Map<String, dynamic>?,
        );
        return const ApiResult.success();
      }

      return ApiResult.failure(_errorMessage(body, 'Registrasi gagal'));
    } catch (_) {
      return const ApiResult.failure(
        'Tidak dapat terhubung ke backend. Pastikan server SVARA API aktif.',
      );
    }
  }

  /// Upload file audio ke backend.
  /// Return id_suara jika berhasil, null jika gagal.
  static Future<String?> uploadAudio({
    required String filePath,
    String nama = 'Rekaman Suara',
    String? idUser,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/records/upload');

      final request = http.MultipartRequest('POST', uri);
      if (accessToken != null) {
        request.headers['Authorization'] = 'Bearer $accessToken';
      }

      // Tambah file
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      // Tambah fields
      request.fields['nama'] = nama;
      if (idUser != null) {
        request.fields['id_user'] = idUser;
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final body = _decodeBody(response.body);
        return body?['data']?['id_suara'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Panggil AI backend untuk memproses rekaman suara.
  static Future<Map<String, dynamic>?> predict(String idRecord) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/api/predict/'),
            headers: {
              'Content-Type': 'application/json',
              if (accessToken != null) 'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode({'id_record': idRecord}),
          )
          .timeout(const Duration(seconds: 45));

      if (response.statusCode == 200) {
        return _decodeBody(response.body);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Fetch daftar riwayat dari backend
  static Future<List<dynamic>?> getHistory() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/api/history/'),
            headers: {
              if (accessToken != null) 'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = _decodeBody(response.body);
        return body?['data'] as List<dynamic>?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Fetch daftar skrining dari backend
  static Future<List<dynamic>?> getScreenings() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/api/screenings/'),
            headers: {
              if (accessToken != null) 'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = _decodeBody(response.body);
        return body?['data'] as List<dynamic>?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Cek koneksi ke backend
  static Future<bool> checkConnection() async {
    try {
      final response = await http
          .get(Uri.parse(_baseUrl))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Map<String, dynamic>? _decodeBody(String rawBody) {
    try {
      final decoded = jsonDecode(rawBody);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {
      return null;
    }
    return null;
  }

  static String _errorMessage(Map<String, dynamic>? body, String fallback) {
    final detail = body?['detail'];
    if (detail is String && detail.isNotEmpty) return detail;
    return fallback;
  }
}

class ApiResult {
  final bool isSuccess;
  final String? message;

  const ApiResult._({required this.isSuccess, this.message});

  const ApiResult.success() : this._(isSuccess: true);

  const ApiResult.failure(String message)
    : this._(isSuccess: false, message: message);
}
