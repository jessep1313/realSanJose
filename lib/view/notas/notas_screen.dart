import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_san_jose/common/widget/custom_header.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';
import 'nota_detail_screen.dart'; // 👈 importamos la pantalla de detalle

class NotasScreen extends ConsumerWidget {
  const NotasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final textos = {
      'es': {'title': 'Notas médicas', 'desc': 'Revisa tus notas y diagnósticos'},
      'en': {'title': 'Medical notes', 'desc': 'Review your notes and diagnoses'},
    };

    final notas = [
      {"titulo": lang == 'es' ? "Consulta general" : "General consultation", "autor": "Dr. López", "fecha": "20/01/2026"},
      {"titulo": lang == 'es' ? "Seguimiento tratamiento" : "Treatment follow-up", "autor": "Dr. Pérez", "fecha": "15/01/2026"},
      {"titulo": lang == 'es' ? "Nota de urgencias" : "Emergency note", "autor": "Dr. García", "fecha": "10/01/2026"},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: "Notas"),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(textos[lang]!['title']!,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003DA5))),
                  const SizedBox(height: 10),
                  Text(textos[lang]!['desc']!,
                      style: const TextStyle(fontSize: 16, color: Colors.black87)),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Listado con scroll independiente
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: notas.length,
                itemBuilder: (context, index) {
                  final n = notas[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFF003DA5), width: 2),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.description_outlined, color: Color(0xFF009639)),
                      title: Text(n["titulo"]!),
                      subtitle: Text("${n["autor"]} - ${n["fecha"]}"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NotaDetailScreen(
                              titulo: n["titulo"]!,
                              autor: n["autor"]!,
                              fecha: n["fecha"]!,
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
