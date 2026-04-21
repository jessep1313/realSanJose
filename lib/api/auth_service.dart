import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "https://webservicesvr.hrsj.com.mx/aptest/api";
  final String masterToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3ByaW1hcnlzaWQiOiIwIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiJTeXN0ZW0iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJTeXN0ZW0iLCJleHAiOjIwODU2Nzk2MjYsImlzcyI6Imh0dHBzOi8vd3d3Lmhyc2ouY29tLyIsImF1ZCI6Imh0dHBzOi8vd3d3Lmhyc2ouY29tLyJ9.LDBJArf2oJe_QWhqZ514ger6_iXWXlGMeoRsyCp7qgc";

  // ---------------------------------------------------------
  // LOGIN
  // ---------------------------------------------------------
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

    // Imprimir todo el JSON que regresa el backend
    print("📌 STATUS CODE: ${response.statusCode}");
    print("📌 RAW BODY: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error en login: ${response.statusCode}");
    }
  }

  // ---------------------------------------------------------
  // ASEGURADORAS
  // ---------------------------------------------------------
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

      List<dynamic> rawList = [];
      if (body is List)
        rawList = body;
      else if (body is Map && body['data'] is List)
        rawList = body['data'];
      else if (body is Map && body['items'] is List) rawList = body['items'];

      final List<Map<String, dynamic>> lista = rawList
          .map((e) =>
              e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{})
          .toList();

      return lista.map((m) {
        final Map<String, dynamic> normalized = Map<String, dynamic>.from(m);

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

  // ---------------------------------------------------------
  // CATÁLOGO RX
  // ---------------------------------------------------------
  Future<List<Map<String, dynamic>>> fetchRx() async {
    final url = Uri.parse("$baseUrl/catalogos/servicios/rx");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $masterToken",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      List<dynamic> rawList = [];
      if (body is List)
        rawList = body;
      else if (body is Map && body['data'] is List)
        rawList = body['data'];
      else if (body is Map && body['items'] is List) rawList = body['items'];

      return rawList.map((e) {
        final m = Map<String, dynamic>.from(e);

        if (!m.containsKey('id')) {
          if (m.containsKey('ID'))
            m['id'] = m['ID'];
          else if (m.containsKey('Id'))
            m['id'] = m['Id'];
          else if (m.containsKey('codigo')) m['id'] = m['codigo'];
        }

        if (!m.containsKey('descripcion')) {
          if (m.containsKey('Descripcion'))
            m['descripcion'] = m['Descripcion'];
          else if (m.containsKey('Servicio'))
            m['descripcion'] = m['Servicio'];
          else if (m.containsKey('Nombre')) m['descripcion'] = m['Nombre'];
        }

        return m;
      }).toList();
    }

    throw Exception("Error fetching RX: ${response.statusCode}");
  }

  // ---------------------------------------------------------
  // CATÁLOGO LAB
  // ---------------------------------------------------------
  Future<List<Map<String, dynamic>>> fetchLab() async {
    final url = Uri.parse("$baseUrl/catalogos/servicios/lab");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $masterToken",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      List<dynamic> rawList = [];
      if (body is List)
        rawList = body;
      else if (body is Map && body['data'] is List)
        rawList = body['data'];
      else if (body is Map && body['items'] is List) rawList = body['items'];

      return rawList.map((e) {
        final m = Map<String, dynamic>.from(e);

        if (!m.containsKey('id')) {
          if (m.containsKey('ID'))
            m['id'] = m['ID'];
          else if (m.containsKey('Id'))
            m['id'] = m['Id'];
          else if (m.containsKey('codigo')) m['id'] = m['codigo'];
        }

        if (!m.containsKey('descripcion')) {
          if (m.containsKey('Descripcion'))
            m['descripcion'] = m['Descripcion'];
          else if (m.containsKey('Servicio'))
            m['descripcion'] = m['Servicio'];
          else if (m.containsKey('Nombre')) m['descripcion'] = m['Nombre'];
        }

        return m;
      }).toList();
    }

    throw Exception("Error fetching LAB: ${response.statusCode}");
  }

  // ---------------------------------------------------------
  // REGISTRO
  // ---------------------------------------------------------
  Future<Map<String, dynamic>> register(Map<String, dynamic> payload) async {
    final url = Uri.parse("$baseUrl/auth/singup");
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $masterToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      if (response.body.trim().isEmpty) {
        return {'success': true, 'message': 'Registro exitoso', 'data': null};
      }
      try {
        final body = jsonDecode(response.body);
        return {
          'success': true,
          'message': body is Map && body['message'] != null
              ? body['message']
              : 'Registro exitoso',
          'data': body
        };
      } catch (_) {
        return {'success': true, 'message': 'Registro exitoso', 'data': null};
      }
    }

    final serverMsg = response.body.trim();
    if (response.statusCode == 400 || response.statusCode == 409) {
      return {
        'success': false,
        'message': serverMsg.isNotEmpty ? serverMsg : 'Error en registro',
        'data': null
      };
    }

    return {
      'success': false,
      'message': 'Error del servidor: ${response.statusCode}',
      'data': null
    };
  }

  // ---------------------------------------------------------
  // ⭐ AGENDA DISPONIBLE RX/LAB
  // ---------------------------------------------------------
  Future<List<String>> fetchAgendaDisponible(
      int estudioId, int sucursal, DateTime fechaSeleccionada) async {
    final prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString("token_usuario") ?? "";

    final fecha =
        "${fechaSeleccionada.year}-${fechaSeleccionada.month.toString().padLeft(2, '0')}-${fechaSeleccionada.day.toString().padLeft(2, '0')}";

    final url = Uri.parse(
        "$baseUrl/paciente/agenda/rxlab/disponible?servicioId=$estudioId&sucursalId=$sucursal&fecha=$fecha");

    print("📌 LLAMANDO A AGENDA DISPONIBLE");
    print("➡ URL: $url");
    print("➡ Usando userToken: $userToken");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $userToken",
        "Accept": "application/json",
      },
    );

    print("📌 STATUS CODE: ${response.statusCode}");
    print("📌 RAW RESPONSE BODY:");
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception(
          "Error al obtener agenda disponible: ${response.statusCode}");
    }
  }

  // ---------------------------------------------------------
  // ⭐ CREAR CITA RX/LAB
  // ---------------------------------------------------------
  Future<Map<String, dynamic>> crearCita({
    required int estudioId,
    required int sucursal,
    required String fechaHora,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString("token_usuario") ?? "";

    final url = Uri.parse("$baseUrl/paciente/agenda/rxlab");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $userToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "EstudioId": estudioId,
        "Sucursal": sucursal,
        "FechaHora": fechaHora,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "Error al crear cita: ${response.statusCode} ${response.body}");
    }
  }

  // ---------------------------------------------------------
  // ⭐  VER  CITA RX/LAB
  // ---------------------------------------------------------
  Future<List<Map<String, dynamic>>> fetchCitas() async {
    final prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString("token_usuario") ?? "";

    final url = Uri.parse("$baseUrl/paciente/expediente/estudios");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $userToken",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception("Error al obtener citas: ${response.statusCode}");
    }
  }
}
