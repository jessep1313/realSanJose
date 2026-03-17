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

  /// Obtiene el catálogo de aseguradoras.
  /// Devuelve una lista de mapas donde cada elemento contiene al menos:
  /// { "id": <id>, "Servicio": "<nombre visible>" }
  Future<List<Map<String, dynamic>>> fetchAseguradoras() async {
    final url = Uri.parse("$baseUrl/catalogos/aseguradoras");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $masterToken",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      // Ajustes según estructura de la API:
      // - Si la API devuelve una lista directa: body is List
      // - Si devuelve { data: [...] } entonces usamos body['data']
      List<dynamic> rawList = [];
      if (body is List) {
        rawList = body;
      } else if (body is Map && body['data'] is List) {
        rawList = body['data'];
      } else if (body is Map && body['items'] is List) {
        rawList = body['items'];
      } else {
        // Si la estructura es distinta, intentar convertir a lista vacía
        rawList = [];
      }

      // Normalizar cada item a Map<String, dynamic>
      final List<Map<String, dynamic>> lista = rawList
          .map((e) =>
              e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{})
          .toList();

      // Filtrar y asegurar que cada item tenga 'id' y 'Servicio' (si no, intentar mapear)
      return lista.map((m) {
        final Map<String, dynamic> normalized = Map<String, dynamic>.from(m);
        // Intentos de mapeo si claves vienen con otros nombres
        if (!normalized.containsKey('id')) {
          if (normalized.containsKey('ID'))
            normalized['id'] = normalized['ID'];
          else if (normalized.containsKey('Id'))
            normalized['id'] = normalized['Id'];
          else if (normalized.containsKey('codigo'))
            normalized['id'] = normalized['codigo'];
        }
        if (!normalized.containsKey('Servicio')) {
          if (normalized.containsKey('servicio'))
            normalized['Servicio'] = normalized['servicio'];
          else if (normalized.containsKey('nombre'))
            normalized['Servicio'] = normalized['nombre'];
          else if (normalized.containsKey('Nombre'))
            normalized['Servicio'] = normalized['Nombre'];
          else if (normalized.containsKey('descripcion'))
            normalized['Servicio'] = normalized['descripcion'];
        }
        return normalized;
      }).toList();
    } else {
      throw Exception("Error fetching aseguradoras: ${response.statusCode}");
    }
  }
}
