import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:real_san_jose/common/widget/custom_header.dart';
import 'package:real_san_jose/api/auth_service.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class NotasScreen extends ConsumerStatefulWidget {
  const NotasScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotasScreenState();
}

class _NotasScreenState extends ConsumerState<NotasScreen> {
  List<Map<String, dynamic>> notas = [];
  bool cargando = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _cargarNotas();
  }

  Future<void> _cargarNotas() async {
    setState(() {
      cargando = true;
      error = null;
    });
    try {
      final service = AuthService();
      final lista = await service.fetchNotasMedicas();
      setState(() {
        notas = lista;
        cargando = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final textos = {
      'es': {
        'title': 'Notas médicas',
        'desc': 'Revisa tus notas y diagnósticos',
        'sinNotas': 'No hay notas médicas disponibles',
        'reintentar': 'Reintentar',
        'medico': 'Médico',
        'folio': 'Folio Visita',
        'sucursal': 'Sucursal',
        'fecha': 'Fecha',
        'hora': 'Hora',
        'informe': 'Informe',
      },
      'en': {
        'title': 'Medical notes',
        'desc': 'Review your notes and diagnoses',
        'sinNotas': 'No medical notes available',
        'reintentar': 'Retry',
        'medico': 'Doctor',
        'folio': 'Visit Folio',
        'sucursal': 'Branch',
        'fecha': 'Date',
        'hora': 'Time',
        'informe': 'Report',
      }
    };

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
                  Text(
                    textos[lang]!['title']!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0166B8),
                    ),
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
              child: cargando
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0166B8),
                      ),
                    )
                  : error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                error!,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _cargarNotas,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0166B8),
                                ),
                                child: Text(
                                  textos[lang]!['reintentar']!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        )
                      : notas.isEmpty
                          ? Center(
                              child: Text(
                                textos[lang]!['sinNotas']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              itemCount: notas.length,
                              itemBuilder: (context, index) {
                                final n = notas[index];
                                final folio =
                                    n['FolioVisita']?.toString() ?? '';
                                final sucursal =
                                    n['Sucursal']?.toString() ?? '';
                                final fechaRaw =
                                    n['FechaNota']?.toString() ?? '';
                                final medico = n['Medico'];
                                final informe = n['Informe']?.toString() ?? '';

                                // Formatear fecha y hora
                                String fechaFormateada = '';
                                String horaFormateada = '';
                                if (fechaRaw.isNotEmpty) {
                                  try {
                                    final dt = DateTime.parse(fechaRaw);
                                    fechaFormateada =
                                        DateFormat('dd/MM/yyyy').format(dt);
                                    horaFormateada =
                                        DateFormat('HH:mm').format(dt);
                                  } catch (_) {
                                    fechaFormateada = fechaRaw;
                                    horaFormateada = '';
                                  }
                                }

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                      color: Color(0xFF0166B8),
                                      width: 2,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Folio Visita
                                        Row(
                                          children: [
                                            Icon(Icons.assignment,
                                                size: 16,
                                                color: Color(0xFF0166B8)),
                                            const SizedBox(width: 6),
                                            Text(
                                              '${textos[lang]!['folio']!}: $folio',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        // Sucursal
                                        Row(
                                          children: [
                                            Icon(Icons.location_on,
                                                size: 16,
                                                color: Color(0xFF8B8E00)),
                                            const SizedBox(width: 6),
                                            Text(
                                                '${textos[lang]!['sucursal']!}: $sucursal'),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        // Fecha y hora
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today,
                                                size: 16,
                                                color: Color(0xFF8B8E00)),
                                            const SizedBox(width: 6),
                                            Text(
                                                '${textos[lang]!['fecha']!}: $fechaFormateada'),
                                            const SizedBox(width: 16),
                                            Icon(Icons.access_time,
                                                size: 16,
                                                color: Color(0xFF8B8E00)),
                                            const SizedBox(width: 6),
                                            Text(
                                                '${textos[lang]!['hora']!}: $horaFormateada'),
                                          ],
                                        ),
                                        // Médico (si existe)
                                        if (medico != null &&
                                            medico.toString().isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.person,
                                                  size: 16,
                                                  color: Color(0xFF8B8E00)),
                                              const SizedBox(width: 6),
                                              Text(
                                                  '${textos[lang]!['medico']!}: $medico'),
                                            ],
                                          ),
                                        ],
                                        const Divider(height: 20),
                                        // Informe
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.description,
                                                size: 16,
                                                color: Color(0xFF0166B8)),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                '${textos[lang]!['informe']!}: ${informe.isNotEmpty ? informe : "Sin informe"}',
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
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
