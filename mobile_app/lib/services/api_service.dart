import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service untuk komunikasi dengan SVARA Backend API.
class ApiService {
  static const String _baseUrl =
      String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.0.104:8000',
  );

  static String? accessToken;

  static Map<String, dynamic>? currentUser;

  static String get baseUrl => _baseUrl;

  static Future<void> loadSession() async {
    try {
      final prefs =
          await SharedPreferences.getInstance();

      accessToken =
          prefs.getString('access_token');

      final userStr =
          prefs.getString('current_user');

      if (userStr != null) {
        currentUser =
            jsonDecode(userStr);
      }
    } catch (_) {
      // Abaikan jika gagal
    }
  }

  static Future<void> _saveSession(
    String? token,
    Map<String, dynamic>? user,
  ) async {
    try {
      final prefs =
          await SharedPreferences.getInstance();

      if (token != null) {
        await prefs.setString(
          'access_token',
          token,
        );

        accessToken = token;
      }

      if (user != null) {
        await prefs.setString(
          'current_user',
          jsonEncode(user),
        );

        currentUser = user;
      }
    } catch (_) {}
  }

  static Future<void> logout() async {
    try {
      accessToken = null;
      currentUser = null;

      final prefs =
          await SharedPreferences.getInstance();

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
            Uri.parse(
              '$_baseUrl/api/auth/login',
            ),
            headers: {
              'Content-Type':
                  'application/json',
            },
            body: jsonEncode({
              'username': username,
              'password': password,
            }),
          )
          .timeout(
        const Duration(seconds: 15),
      );

      final body =
          _decodeBody(response.body);

      if (response.statusCode == 200) {
        await _saveSession(
          body?['access_token']
              as String?,
          body?['user']
              as Map<String, dynamic>?,
        );

        return const ApiResult.success();
      }

      return ApiResult.failure(
        _errorMessage(
          response,
          body,
          'Login gagal.',
        ),
      );
    } catch (error) {
      return ApiResult.failure(
        _networkErrorMessage(error),
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
            Uri.parse(
              '$_baseUrl/api/auth/register',
            ),
            headers: {
              'Content-Type':
                  'application/json',
            },
            body: jsonEncode({
              'username': username,
              'nama': nama,
              'password': password,
              if (email != null &&
                  email.isNotEmpty)
                'email': email,
              if (phone != null &&
                  phone.isNotEmpty)
                'phone': phone,
            }),
          )
          .timeout(
        const Duration(seconds: 15),
      );

      final body =
          _decodeBody(response.body);

      if (response.statusCode == 201) {
        await _saveSession(
          body?['access_token']
              as String?,
          body?['user']
              as Map<String, dynamic>?,
        );

        return const ApiResult.success();
      }

      return ApiResult.failure(
        _errorMessage(
          response,
          body,
          'Registrasi gagal.',
        ),
      );
    } catch (error) {
      return ApiResult.failure(
        _networkErrorMessage(error),
      );
    }
  }

  /// Upload file audio ke backend.
  static Future<ApiResult> uploadAudio({
    required String filePath,
    String nama = 'Rekaman Suara',
  }) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/api/records/upload',
      );

      final request =
          http.MultipartRequest(
        'POST',
        uri,
      );

      if (accessToken != null) {
        request.headers['Authorization'] =
            'Bearer $accessToken';
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          filePath,
        ),
      );

      request.fields['nama'] = nama;

      final streamedResponse =
          await request.send().timeout(
        const Duration(seconds: 30),
      );

      final response =
          await http.Response.fromStream(
        streamedResponse,
      );

      final body =
          _decodeBody(response.body);

      if (response.statusCode == 201 ||
          response.statusCode == 200) {
        return ApiResult.success(
          data: body,
        );
      }

      return ApiResult.failure(
        _errorMessage(
          response,
          body,
          'Upload audio gagal.',
        ),
      );
    } catch (error) {
      return ApiResult.failure(
        _networkErrorMessage(error),
      );
    }
  }

  static Future<ApiResult> analyzeScreening(
    String screeningId,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse(
              '$_baseUrl/api/screenings/'
              '$screeningId/analyze',
            ),
            headers: {
              'Content-Type':
                  'application/json',
              if (accessToken != null)
                'Authorization':
                    'Bearer $accessToken',
            },
          )
          .timeout(
        const Duration(seconds: 60),
      );

      if (response.statusCode == 200) {
        final body =
            _decodeBody(response.body);

        final data = body?['data'];

        return ApiResult.success(
          data: data is Map<String, dynamic>
              ? data
              : body,
        );
      }

      final body =
          _decodeBody(response.body);

      return ApiResult.failure(
        _errorMessage(
          response,
          body,
          'Analisis rekaman gagal.',
        ),
      );
    } catch (error) {
      return ApiResult.failure(
        _networkErrorMessage(error),
      );
    }
  }

  static Future<ApiResult> getScreening(
    String screeningId,
  ) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '$_baseUrl/api/screenings/'
              '$screeningId',
            ),
            headers: {
              if (accessToken != null)
                'Authorization':
                    'Bearer $accessToken',
            },
          )
          .timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        final body =
            _decodeBody(response.body);

        final data = body?['data'];

        return ApiResult.success(
          data: data is Map<String, dynamic>
              ? data
              : body,
        );
      }

      final body =
          _decodeBody(response.body);

      return ApiResult.failure(
        _errorMessage(
          response,
          body,
          'Data skrining belum dapat dimuat.',
        ),
      );
    } catch (error) {
      return ApiResult.failure(
        _networkErrorMessage(error),
      );
    }
  }

  /// Fetch daftar riwayat dari backend.
  static Future<List<dynamic>?> getHistory() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '$_baseUrl/api/history/',
            ),
            headers: {
              if (accessToken != null)
                'Authorization':
                    'Bearer $accessToken',
            },
          )
          .timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        final body =
            _decodeBody(response.body);

        return body?['data']
            as List<dynamic>?;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  /// Fetch daftar skrining dari backend.
  static Future<List<dynamic>?>
      getScreenings() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '$_baseUrl/api/screenings/',
            ),
            headers: {
              if (accessToken != null)
                'Authorization':
                    'Bearer $accessToken',
            },
          )
          .timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        final body =
            _decodeBody(response.body);

        return body?['data']
            as List<dynamic>?;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  /// Cek koneksi ke backend.
  static Future<bool> checkConnection() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/health'),
          )
          .timeout(
        const Duration(seconds: 5),
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Map<String, dynamic>? _decodeBody(
    String rawBody,
  ) {
    try {
      final decoded =
          jsonDecode(rawBody);

      if (decoded
          is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  static String _errorMessage(
    http.Response response,
    Map<String, dynamic>? body,
    String fallback,
  ) {
    final detail = body?['detail'];

    if (detail is String &&
        detail.isNotEmpty) {
      return detail;
    }

    if (detail is List &&
        detail.isNotEmpty) {
      return 'Data yang dikirim tidak valid.';
    }

    return switch (response.statusCode) {
      401 =>
        'Sesi login telah berakhir. Silakan login kembali.',
      403 => 'Akses ditolak.',
      404 =>
        'Endpoint server tidak ditemukan.',
      409 => fallback,
      422 =>
        'Data yang dikirim tidak valid.',
      >= 500 =>
        'Terjadi masalah pada server.',
      _ => fallback,
    };
  }

  static String _networkErrorMessage(
    Object error,
  ) {
    if (error is TimeoutException) {
      return 'Koneksi ke server terlalu lama. Silakan coba lagi.';
    }

    if (error is SocketException ||
        error is http.ClientException) {
      return 'Server SVARA belum dapat dihubungi.';
    }

    return 'Terjadi kesalahan koneksi.';
  }

  static String resolveUrl(
    String? path,
  ) {
    if (path == null || path.isEmpty) {
      return '';
    }

    if (path.startsWith('http://') ||
        path.startsWith('https://')) {
      return path;
    }

    if (path.startsWith('/')) {
      return '$_baseUrl$path';
    }

    return '$_baseUrl/$path';
  }

  static DateTime? parseServerDateTime(
    Object? value,
  ) {
    if (value is! String || value.isEmpty) {
      return null;
    }

    final hasTimezone = RegExp(
      r'(Z|[+-]\d{2}:?\d{2})$',
      caseSensitive: false,
    ).hasMatch(value);

    final normalized = hasTimezone ? value : '${value}Z';

    return DateTime.tryParse(normalized)?.toLocal();
  }

  /// Download audio dari backend ke temporary storage perangkat.
  ///
  /// Audio tidak langsung diputar dari URL HTTP karena pada Android
  /// WAV melalui UrlSource dapat gagal pada MediaPlayer.
  ///
  /// File di-download terlebih dahulu kemudian diputar dengan
  /// DeviceFileSource.
  static Future<String?>
      downloadAudioToTempFile(
    String? path,
  ) async {
    final url = resolveUrl(path);

    if (url.isEmpty) {
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          if (accessToken != null)
            'Authorization':
                'Bearer $accessToken',
        },
      ).timeout(
        const Duration(seconds: 20),
      );

      if (response.statusCode != 200 ||
          response.bodyBytes.isEmpty) {
        return null;
      }

      final directory =
          await getTemporaryDirectory();

      final fileName =
          'svara_audio_'
          '${DateTime.now().millisecondsSinceEpoch}'
          '.wav';

      final file = File(
        '${directory.path}/$fileName',
      );

      await file.writeAsBytes(
        response.bodyBytes,
        flush: true,
      );

      return file.path;
    } catch (_) {
      return null;
    }
  }
}

class ApiResult {
  final bool isSuccess;

  final String? message;

  final Map<String, dynamic>? data;

  const ApiResult._({
    required this.isSuccess,
    this.message,
    this.data,
  });

  const ApiResult.success({
    Map<String, dynamic>? data,
  }) : this._(
          isSuccess: true,
          data: data,
        );

  const ApiResult.failure(
    String message,
  ) : this._(
          isSuccess: false,
          message: message,
        );
}
