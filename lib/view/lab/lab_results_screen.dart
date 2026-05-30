import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_san_jose/common/widget/custom_header.dart';
import 'package:real_san_jose/api/auth_service.dart';
import 'lab_result_detail_screen.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class LabResultsScreen extends ConsumerStatefulWidget {
  const LabResultsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LabResultsScreenState();
}

class _LabResultsScreenState extends ConsumerState<LabResultsScreen> {
  List<Map<String, dynamic>> estudios = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchEstudios();
  }

  Future<void> _fetchEstudios() async {
    try {
      final service = AuthService();
      final data = await service.fetchEstudios();

      setState(() {
        estudios =
            data.where((e) => e["TipoDeEstudio"] == "Laboratorio").toList();
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error cargando estudios: $e")),
      );
    }
  }

  String _formatFecha(String fecha) {
    // Recorta solo YYYY-MM-DD
    return fecha.split("T").first;
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final textos = {
      'es': {
        'title': 'Resultados de laboratorio',
        'desc': 'Consulta tus análisis clínicos'
      },
      'en': {'title': 'Lab results', 'desc': 'Check your clinical tests'},
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: "Lab"),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    textos[lang]!['title']!,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003DA5)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    textos[lang]!['desc']!,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: estudios.length,
                      itemBuilder: (context, index) {
                        final r = estudios[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                                color: Color(0xFF003DA5), width: 2),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.biotech,
                                color: Color(0xFF009639)),
                            title: Text(r["DescripcionEstudio"] ?? ""),
                            subtitle: Text(_formatFecha(r["Fecha"] ?? "")),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LabResultDetailScreen(
                                    folioOrden: r["FolioOrden"].toString(),
                                    descripcion: r["DescripcionEstudio"] ?? "",
                                    fecha: _formatFecha(r["Fecha"] ?? ""),
                                    linkResultados: r["LinkDeResultados"],
                                    sucursal: r["Sucursal"],
                                    status: r["Status"],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
