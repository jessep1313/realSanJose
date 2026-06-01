import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_san_jose/common/widget/custom_header.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';
import 'package:real_san_jose/api/auth_service.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class ExpedienteScreen extends ConsumerStatefulWidget {
  static var routeName = "/expedientescreen";

  const ExpedienteScreen({super.key});

  @override
  ConsumerState<ExpedienteScreen> createState() => _ExpedienteScreenState();
}

class _ExpedienteScreenState extends ConsumerState<ExpedienteScreen> {
  List<Map<String, dynamic>> visitas = [];

  @override
  void initState() {
    super.initState();
    _loadVisitas();
  }

  Future<void> _loadVisitas() async {
    try {
      final service = AuthService();
      final data = await service.fetchVisitas(); // método en AuthService
      setState(() {
        visitas = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error cargando histórico: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: "Histórico"),
            Expanded(
              child: visitas.isEmpty
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF003DA5)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: visitas.length,
                      itemBuilder: (ctx, i) {
                        final v = visitas[i];
                        final estudios = List<Map<String, dynamic>>.from(
                            v["EstudiosRealizados"] ?? []);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ExpansionTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Sucursal: ${v["Sucursal"]}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text("Ingreso: ${v["FechaIngreso"]}"),
                                Text("Egreso: ${v["FechaEgreso"]}"),
                                Text("Motivo: ${v["MotivoIngreso"]}"),
                                Text("Servicio: ${v["ServicioMedico"]}"),
                                Text("Estancia: ${v["TipoDeEstancia"]}"),
                              ],
                            ),
                            children: estudios.isEmpty
                                ? [
                                    const Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("Sin estudios realizados"))
                                  ]
                                : estudios.map((e) {
                                    return ListTile(
                                      title: Text(
                                          e["DescripcionEstudio"] ?? "Estudio"),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Tipo: ${e["TipoDeEstudio"]}"),
                                          Text("Status: ${e["Status"]}"),
                                          Text("Fecha: ${e["Fecha"]}"),
                                          if (e["LinkDeResultados"] != null)
                                            Text(
                                                "Resultados: ${e["LinkDeResultados"]}"),
                                        ],
                                      ),
                                    );
                                  }).toList(),
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
