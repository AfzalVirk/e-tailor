import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Uploads images directly to Cloudinary using an unsigned upload preset —
/// no API secret needed client-side, safe to ship inside the app.
class CloudinaryService {
  static const String _cloudName = 'yhocqhzs';
  static const String _uploadPreset = 'etailor_profile_pics';

  static Future<String?> uploadImage(File imageFile) async {
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = _uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      final data = jsonDecode(body);
      return data['secure_url'] as String?;
    }
    return null;
  }
}