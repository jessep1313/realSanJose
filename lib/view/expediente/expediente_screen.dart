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
        'title': 'Historial médico',
        'desc': 'Resumen general de tu salud',
        'resumen': 'Resumen médico',
        'signos': 'Signos vitales (últimos 30 días)',
        'estudiosRecientes': 'Estudios recientes',
        'historico': 'Histórico de resultados (5 años)',
        'notas': 'Notas médicas',
        'verTodo': 'Ver historial completo',
        'descargar': 'Descargar expediente completo'
      },
      'en': {
        'title': 'Medical history',
        'desc': 'General health overview',
        'resumen': 'Medical summary',
        'signos': 'Vital signs (last 30 days)',
        'estudiosRecientes': 'Recent studies',
        'historico': 'Historical results (5 years)',
        'notas': 'Medical notes',
        'verTodo': 'View full history',
        'descargar': 'Download full record'
      },
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: "Expediente"),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      textos[lang]!['title']!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003DA5),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      textos[lang]!['desc']!,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),

                    const SizedBox(height: 20),

                    // ⭐ RESUMEN MÉDICO
                    _buildResumenCard(lang, textos),

                    const SizedBox(height: 20),

                    // ⭐ GRÁFICA SIMULADA
                    _buildGraficaCard(lang, textos),

                    const SizedBox(height: 20),

                    // ⭐ ESTUDIOS RECIENTES
                    _buildEstudiosRecientes(lang, textos),

                    const SizedBox(height: 20),

                    // ⭐ HISTÓRICO 5 AÑOS
                    _buildHistorico(lang, textos),

                    const SizedBox(height: 20),

                    // ⭐ NOTAS MÉDICAS
                    _buildNotasMedicas(lang, textos),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ⭐ FOOTER
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
          label: Text(
            textos[lang]!['descargar']!,
            style: const TextStyle(color: Colors.white),
          ),
          onPressed: () {
            // TODO: descargar PDF
          },
        ),
      ),
    );
  }

  // ⭐ RESUMEN MÉDICO
  Widget _buildResumenCard(String lang, Map textos) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              textos[lang]!['resumen']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003DA5),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _ResumenItem(label: "Peso", value: "78 kg"),
                _ResumenItem(label: "Altura", value: "1.75 m"),
                _ResumenItem(label: "IMC", value: "25.5"),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _ResumenItem(label: "Presión", value: "120/80"),
                _ResumenItem(label: "Glucosa", value: "92 mg/dL"),
                _ResumenItem(label: "Ritmo", value: "72 bpm"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ⭐ GRÁFICA SIMULADA
  Widget _buildGraficaCard(String lang, Map textos) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              textos[lang]!['signos']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003DA5),
              ),
            ),
            const SizedBox(height: 16),

            // Simulación de gráfica
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade50,
                    Colors.blue.shade100,
                  ],
                ),
              ),
              child: const Center(
                child: Text(
                  "📈 Gráfica de signos vitales (simulada)",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ⭐ ESTUDIOS RECIENTES
  Widget _buildEstudiosRecientes(String lang, Map textos) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              textos[lang]!['estudiosRecientes']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003DA5),
              ),
            ),
            const SizedBox(height: 10),

            _studyItem("Rayos X de tórax", "12 Ene 2026"),
            _studyItem("Biometría hemática", "05 Ene 2026"),
            _studyItem("Ultrasonido abdominal", "20 Dic 2025"),
          ],
        ),
      ),
    );
  }

  Widget _studyItem(String name, String date) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.folder_open, color: Color(0xFF009639)),
      title: Text(name),
      subtitle: Text(date),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }

  // ⭐ HISTÓRICO 5 AÑOS
  Widget _buildHistorico(String lang, Map textos) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              textos[lang]!['historico']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003DA5),
              ),
            ),
            const SizedBox(height: 10),

            _historyItem("2026", "12 estudios"),
            _historyItem("2025", "18 estudios"),
            _historyItem("2024", "15 estudios"),
            _historyItem("2023", "10 estudios"),
            _historyItem("2022", "8 estudios"),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () {},
              child: Text(
                textos[lang]!['verTodo']!,
                style: const TextStyle(color: Color(0xFF003DA5)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _historyItem(String year, String count) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.calendar_month, color: Color(0xFF009639)),
      title: Text(year),
      subtitle: Text(count),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }

  // ⭐ NOTAS MÉDICAS
  Widget _buildNotasMedicas(String lang, Map textos) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              textos[lang]!['notas']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003DA5),
              ),
            ),
            const SizedBox(height: 10),

            _noteItem("12 Ene 2026", "Paciente estable, continuar tratamiento."),
            _noteItem("05 Ene 2026", "Revisión general sin complicaciones."),
            _noteItem("20 Dic 2025", "Control de presión arterial."),
          ],
        ),
      ),
    );
  }

  Widget _noteItem(String date, String note) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.note_alt, color: Color(0xFF009639)),
      title: Text(date),
      subtitle: Text(note),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}

// ⭐ ITEM PARA RESUMEN
class _ResumenItem extends StatelessWidget {
  final String label;
  final String value;

  const _ResumenItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF009639),
          ),
        ),
      ],
    );
  }
}
