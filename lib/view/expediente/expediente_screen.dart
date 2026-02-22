import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_san_jose/common/widget/custom_header.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class ExpedienteScreen extends ConsumerWidget {
  const ExpedienteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    final textos = {
      'es': {
        'title': 'Expediente médico',
        'desc': 'Consulta tu historial clínico completo',
        'datos': 'Datos personales',
        'historial': 'Historial clínico',
        'consultas': 'Consultas médicas',
        'lab': 'Resultados de laboratorio',
        'imagen': 'Estudios de imagen',
        'notas': 'Notas médicas',
        'personas': 'Personas autorizadas',
        'descargar': 'Descargar expediente completo'
      },
      'en': {
        'title': 'Medical record',
        'desc': 'Check your full medical history',
        'datos': 'Personal data',
        'historial': 'Clinical history',
        'consultas': 'Medical consultations',
        'lab': 'Lab results',
        'imagen': 'Imaging studies',
        'notas': 'Medical notes',
        'personas': 'Authorized persons',
        'descargar': 'Download full record'
      },
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: "Expediente"),

            // Contenido con scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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

                    // Secciones del expediente
                    _buildSection(context, textos[lang]!['datos']!, Icons.person),
                    _buildSection(context, textos[lang]!['historial']!, Icons.history),
                    _buildSection(context, textos[lang]!['consultas']!, Icons.medical_services),
                    _buildSection(context, textos[lang]!['lab']!, Icons.biotech),
                    _buildSection(context, textos[lang]!['imagen']!, Icons.image),
                    _buildSection(context, textos[lang]!['notas']!, Icons.description),
                    _buildSection(context, textos[lang]!['personas']!, Icons.group),

                    const SizedBox(height: 80), // espacio para no tapar footer
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Footer fijo con botón descargar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF009639),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
          label: Text(textos[lang]!['descargar']!,
              style: const TextStyle(color: Colors.white)),
          onPressed: () {
            // TODO: lógica para descargar expediente completo en PDF
          },
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF003DA5), width: 2),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF009639)),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: navegar a la vista interna correspondiente
        },
      ),
    );
  }
}
