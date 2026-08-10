import 'dart:convert';

import 'package:http/http.dart' as http;

/// Service untuk komunikasi dengan SVARA Backend API.
class ApiService {
  // Untuk Android emulator, gunakan 10.0.2.2
  // Untuk device fisik di jaringan lokal, gunakan IP komputer (contoh: 192.168.1.140)
  // Untuk iOS simulator atau Desktop Windows, gunakan 127.0.0.1
  static const String _baseUrl = 'http://192.168.1.140:8000';
  static String? accessToken;
  static Map<String, dynamic>? currentUser;

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
        accessToken = body?['access_token'] as String?;
        currentUser = body?['user'] as Map<String, dynamic>?;
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
        accessToken = body?['access_token'] as String?;
        currentUser = body?['user'] as Map<String, dynamic>?;
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
  /// Return response body jika berhasil, null jika gagal.
  static Future<String?> uploadAudio({
    required String filePath,
    String nama = 'Rekaman Suara',
    String? idUser,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/records/upload');

      final request = http.MultipartRequest('POST', uri);

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
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
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
