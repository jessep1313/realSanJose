import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_san_jose/common/widget/custom_header.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';
import 'package:real_san_jose/api/auth_service.dart';

class CirugiasProgramadasScreen extends ConsumerStatefulWidget {
  static var routeName = "/cirugiasprogramadasscreen";

  const CirugiasProgramadasScreen({super.key});

  @override
  ConsumerState<CirugiasProgramadasScreen> createState() =>
      _CirugiasProgramadasState();
}

class _CirugiasProgramadasState
    extends ConsumerState<CirugiasProgramadasScreen> {
  List<Map<String, dynamic>> cirugias = [];

  @override
  void initState() {
    super.initState();
    _loadCirugias();
  }

  Future<void> _loadCirugias() async {
    try {
      final service = AuthService();
      final data = await service.fetchCirugias(); // método nuevo en AuthService
      setState(() {
        cirugias = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error cargando cirugías: $e")),
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
            const CustomHeader(title: "Cirugías programadas"),
            Expanded(
              child: cirugias.isEmpty
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF003DA5)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: cirugias.length,
                      itemBuilder: (ctx, i) {
                        final c = cirugias[i];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: const Icon(Icons.local_hospital,
                                color: Color(0xFF009639)),
                            title: Text(c["Descripcion"] ?? "Sin descripción"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Sucursal: ${c["Sucursal"]}"),
                                Text("Fecha: ${c["FechaCirugia"]}"),
                              ],
                            ),
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
