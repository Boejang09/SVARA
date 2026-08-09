import 'dart:io';

import 'package:http/http.dart' as http;

/// Service untuk komunikasi dengan SVARA Backend API.
class ApiService {
  // Untuk Android emulator, gunakan 10.0.2.2
  // Untuk device fisik di jaringan lokal, gunakan IP komputer
  // Untuk iOS simulator, gunakan localhost
  static const String _baseUrl = 'http://10.0.2.2:8000';

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
      request.files.add(
        await http.MultipartFile.fromPath('file', filePath),
      );

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
      final response = await http.get(
        Uri.parse(_baseUrl),
      ).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
