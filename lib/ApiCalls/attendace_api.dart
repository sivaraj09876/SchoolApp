
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schoolapplication/utils.dart';
import 'package:http/http.dart' as http;

class AttendanceApi {
  Future<Map<String, dynamic>> ayyendanceApi(String id ,Function atList) async {
    try {
      final box = await Hive.openBox("login");
      final token = await box.get("token");
      if (token == null) {
        throw Exception('Token not found');
      }

      String uri = "$base_url/attendance/$id";
      final response = await http.get(
        Uri.parse(uri),
        headers: {
          "Authorization": "Token $token",
        },
      );

     print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> decode = json.decode(response.body);
        List ll=[];
         for (var student in decode["attendance"]) {
          Map<String, dynamic> attendanceData = {
            'student_id': student['student_id'],
            'attendance': student['attendance'],
          };
          ll.add(attendanceData);
        }
     

        atList(ll);
        return decode;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }


  Future<bool> postAttendance(List attendanceList,id)async{
     try {
      final box = await Hive.openBox("login");
      final token = await box.get("token");
     
      print("posttt-->$attendanceList");
      String uri = "$base_url/attendance/$id";
      Map data = {"attendance": attendanceList};
     final response = await http.post(Uri.parse(uri), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token'
      });

   
     print("ress-->${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> decode = json.decode(response.body);
        
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("err$e");
      return false;
    }

  }
}