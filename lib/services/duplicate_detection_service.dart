import 'dart:convert';
import 'package:http/http.dart' as http;

class DuplicateDetectionService {
  // Flutter running on Windows or Chrome
  static const String baseUrl = "http://127.0.0.1:8000";

  static Future<Map<String, dynamic>> checkDuplicate({
    required String title,
    required String description,
    required String category,
    required String department,
    required String location,
    required List<Map<String, dynamic>> existingProjects,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/check-duplicate"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "new_project": {
          "title": title,
          "description": description,
          "category": category,
          "department": department,
          "location": location,
        },
        "existing_projects": existingProjects,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      "AI server error: ${response.statusCode}\n"
      "${response.body}",
    );
  }
}