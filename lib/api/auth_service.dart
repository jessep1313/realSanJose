import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "https://webservicesvr.hrsj.com.mx/aptest/api";
  final String masterToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3ByaW1hcnlzaWQiOiIwIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiJTeXN0ZW0iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJTeXN0ZW0iLCJleHAiOjIwODU2Nzk2MjYsImlzcyI6Imh0dHBzOi8vd3d3Lmhyc2ouY29tLyIsImF1ZCI6Imh0dHBzOi8vd3d3Lmhyc2ouY29tLyJ9.LDBJArf2oJe_QWhqZ514ger6_iXWXlGMeoRsyCp7qgc";

  Future<Map<String, dynamic>> login(
      String identificator, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $masterToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "identificator": identificator,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error en login: ${response.statusCode}");
    }
  }
}
