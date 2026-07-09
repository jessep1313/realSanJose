import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_san_jose/common/widget/custom_header.dart';
import 'package:real_san_jose/api/auth_service.dart';
import 'rayosx_detail_screen.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class RayosXScreen extends ConsumerStatefulWidget {
  const RayosXScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RayosXScreenState();
}

class _RayosXScreenState extends ConsumerState<RayosXScreen> {
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
        estudios = data.where((e) => e["TipoDeEstudio"] == "Rayos X").toList();
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
    return fecha.split("T").first; // solo YYYY-MM-DD
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final textos = {
      'es': {'title': 'Rayos X', 'desc': 'Visualiza tus estudios de imagen'},
      'en': {'title': 'X-Rays', 'desc': 'View your imaging studies'},
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: "Rayos X"),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(textos[lang]!['title']!,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0166B8))),
                  const SizedBox(height: 10),
                  Text(textos[lang]!['desc']!,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87)),
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
                        final e = estudios[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                                color: Color(0xFF0166B8), width: 2),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.image,
                                color: Color(0xFF8B8E00)),
                            title: Text(e["DescripcionEstudio"] ?? ""),
                            subtitle: Text(_formatFecha(e["Fecha"] ?? "")),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RayosXDetailScreen(
                                    folioOrden: e["FolioOrden"].toString(),
                                    descripcion: e["DescripcionEstudio"] ?? "",
                                    fecha: e["Fecha"] ?? "",
                                    sucursal: e["Sucursal"],
                                    status: e["Status"],
                                    linkResultados: e["LinkDeResultados"],
                                    linkImagenes: e["LinkImagenes"],
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
