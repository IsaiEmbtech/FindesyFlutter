// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// class ApiService extends GetxService {
//   static const String baseUrl = "https://findesy.onrender.com/";
//
//   Future<dynamic> postRequest(String endpoint, Map<String, dynamic> body) async {
//     // Print request details
//     print('🌐 API Request 🌐');
//     print('Endpoint: ${baseUrl + endpoint}');
//     print('Method: POST');
//     print('Body: ${jsonEncode(body)}');
//     print('----------------------');
//
//     try {
//       final response = await http.post(
//         Uri.parse(baseUrl + endpoint),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(body),
//       );
//
//       // Print response details
//       print('✅ API Response ✅');
//       print('Endpoint: ${baseUrl + endpoint}');
//       print('Status Code: ${response.statusCode}');
//       print('Response Body: ${response.body}');
//       print('----------------------');
//
//       return _handleResponse(response);
//     } catch (e) {
//       // Print error details
//       print('❌ API Error ❌');
//       print('Endpoint: ${baseUrl + endpoint}');
//       print('Error: $e');
//       print('----------------------');
//
//       throw "Connection error. Please try again.";
//     }
//   }
//
//   dynamic _handleResponse(http.Response response) {
//     final data = jsonDecode(response.body);
//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       return data;
//     } else {
//       // Print error response details
//       print('⚠️ API Error Response ⚠️');
//       print('Status Code: ${response.statusCode}');
//       print('Error Message: ${data['message'] ?? "Unknown error"}');
//       print('Full Response: ${response.body}');
//       print('----------------------');
//
//       throw data['message'] ?? "Something went wrong";
//     }
//   }
// }
// ApiService.dart (with improved error throwing)
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiService extends GetxService {
  static const String baseUrl = "https://findesy.onrender.com/";

  Future<dynamic> postRequest(String endpoint, Map<String, dynamic> body) async {
    print('🌐 API Request 🌐');
    print('Endpoint: ${baseUrl + endpoint}');
    print('Method: POST');
    print('Body: ${jsonEncode(body)}');
    print('----------------------');

    try {
      final response = await http.post(
        Uri.parse(baseUrl + endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('✅ API Response ✅');
      print('Endpoint: ${baseUrl + endpoint}');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('----------------------');

      return _handleResponse(response);
    } catch (e) {
      print('❌ API Error ❌');
      print('Endpoint: ${baseUrl + endpoint}');
      print('Error: $e');
      print('----------------------');

    }
  }

  dynamic _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      print('⚠️ API Error Response ⚠️');
      print('Status Code: ${response.statusCode}');
      print('Error Message: ${data['error'] ?? "Unknown error"}');
      print('Full Response: ${response.body}');
      print('----------------------');

      // Throw error message from response
      throw Exception(data['error'] ?? "Something went wrong");
    }
  }
}