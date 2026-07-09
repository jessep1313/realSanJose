import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class LabResultDetailScreen extends ConsumerWidget {
  final String folioOrden;
  final String descripcion;
  final String fecha;
  final String? linkResultados;
  final String? sucursal;
  final String? status;

  const LabResultDetailScreen({
    super.key,
    required this.folioOrden,
    required this.descripcion,
    required this.fecha,
    this.linkResultados,
    this.sucursal,
    this.status,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final textos = {
      'es': {
        'title': 'Detalle de estudio',
        'hospital': 'Hospital',
        'status': 'Estatus',
        'descripcion': 'Descripción',
        'folio': 'Folio',
        'fecha': 'Fecha',
        'hora': 'Hora',
        'noResults': 'Sin resultados aún',
      },
      'en': {
        'title': 'Study detail',
        'hospital': 'Hospital',
        'status': 'Status',
        'descripcion': 'Description',
        'folio': 'Folio',
        'fecha': 'Date',
        'hora': 'Time',
        'noResults': 'No results yet',
      },
    };

    // separar fecha y hora
    String fechaSolo = fecha;
    String horaSolo = "";
    if (fecha.contains("T")) {
      final parts = fecha.split("T");
      fechaSolo = parts[0];
      horaSolo = parts.length > 1 ? parts[1] : "";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ⭐ Header con back, logo y idioma
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Color(0xFF0166B8), size: 28),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Center(
                  child: Image.asset('assets/icons/logo.jpg', height: 90),
                ),
                DropdownButton<String>(
                  value: lang,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'es', child: Text('ES 🇲🇽')),
                    DropdownMenuItem(value: 'en', child: Text('EN 🇺🇸')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(languageProvider.notifier).state = value;
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ⭐ Datos del estudio con mejor estilo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(textos[lang]!['folio']!, folioOrden),
                  _infoRow(textos[lang]!['hospital']!, sucursal ?? ""),
                  _infoRow(textos[lang]!['descripcion']!, descripcion),
                  _infoRow(textos[lang]!['status']!, status ?? ""),
                  _infoRow(textos[lang]!['fecha']!, fechaSolo),
                  if (horaSolo.isNotEmpty)
                    _infoRow(textos[lang]!['hora']!, horaSolo),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // ⭐ Contenido principal
            Expanded(
              child: linkResultados != null
                  ? WebViewWidget(
                      controller: WebViewController()
                        ..setJavaScriptMode(JavaScriptMode.unrestricted)
                        ..loadRequest(Uri.parse(linkResultados!)),
                    )
                  : Center(
                      child: Text(
                        textos[lang]!['noResults']!,
                        style: const TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF0166B8),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
