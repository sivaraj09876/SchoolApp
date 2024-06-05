
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schoolapplication/utils.dart';
import 'package:http/http.dart' as http;

class DashboardApi {
  Future<Map<String, dynamic>> dashboardApi() async {
    try {
      final box = await Hive.openBox("login");
      final token = await box.get("token");
      if (token == null) {
        throw Exception('Token not found');
      }

      String uri = "$base_url/dashboard";
      final response = await http.get(
        Uri.parse(uri),
        headers: {
          "Authorization": "Token $token",
        },
      );

     print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> decode = json.decode(response.body);
        return decode;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }
}