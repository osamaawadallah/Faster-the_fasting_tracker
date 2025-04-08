import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/shared/utils/date_utils.dart';

class FastingAPI {
  static const _baseUrl = 'http://localhost:8000';
  final _storage = const FlutterSecureStorage();

  Future<void> addFastingDay(DateTime date, String type, String purpose) async {
    final token = await _storage.read(key: 'token');

    final response = await http.post(
      Uri.parse('$_baseUrl/fasting'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'date': date.toIso8601String().split('T')[0],
        'type': type,
        'purpose': purpose,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save fasting day');
    }
  }

  Future<void> removeFastingDay(DateTime date) async {
    final token = await _storage.read(key: 'token');
    final isoDate = normalizeDate(date).toIso8601String();

    final response = await http.delete(
      Uri.parse('$_baseUrl/fasting/$isoDate'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to remove fasting day');
    }
  }

  Future<List<DateTime>> getFastingDays() async {
    final token = await _storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$_baseUrl/fasting'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch fasting days');
    }

    final List data = jsonDecode(response.body);
    return data.map((item) => DateTime.parse(item['date'])).toList();
  }
}
