import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart'; // 🌟 Tu librería blindada
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class LabResultDetailScreen extends ConsumerStatefulWidget {
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
  ConsumerState<LabResultDetailScreen> createState() =>
      _LabResultDetailScreenState();
}

class _LabResultDetailScreenState extends ConsumerState<LabResultDetailScreen> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
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
        'loading': 'Cargando detalle de resultados...',
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
        'loading': 'Loading result details...',
      },
    };

    // separar fecha y hora
    String fechaSolo = widget.fecha;
    String horaSolo = "";
    if (widget.fecha.contains("T")) {
      final parts = widget.fecha.split("T");
      fechaSolo = parts[0];
      horaSolo = parts.length > 1 ? parts[1] : "";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ⭐ Header con back, logo y idioma original de Real San José
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

            // ⭐ Datos del estudio estructurados
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(textos[lang]!['folio']!, widget.folioOrden),
                  _infoRow(textos[lang]!['hospital']!, widget.sucursal ?? ""),
                  _infoRow(textos[lang]!['descripcion']!, widget.descripcion),
                  _infoRow(textos[lang]!['status']!, widget.status ?? ""),
                  _infoRow(textos[lang]!['fecha']!, fechaSolo),
                  if (horaSolo.isNotEmpty)
                    _infoRow(textos[lang]!['hora']!, horaSolo),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // ⭐ Contenido Principal Web Seguro e Incrustado
            Expanded(
              child: widget.linkResultados != null
                  ? Stack(
                      children: [
                        InAppWebView(
                          initialUrlRequest:
                              URLRequest(url: WebUri(widget.linkResultados!)),
                          initialSettings: InAppWebViewSettings(
                            javaScriptEnabled:
                                true, // Necesario para los portales de laboratorio dinámicos
                            transparentBackground: true,
                            supportZoom:
                                true, // Permite pellizcar para leer letras pequeñas del laboratorio
                            builtInZoomControls: true,
                            displayZoomControls:
                                false, // Remueve botones de lupa molestos
                          ),
                          onLoadStart: (controller, url) {
                            setState(() {
                              _isLoading = true;
                            });
                          },
                          onLoadStop: (controller, url) {
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          onReceivedError: (controller, request, error) {
                            debugPrint(
                                "Error WebView Laboratorio: ${error.description}");
                          },
                        ),

                        // Indicador de carga fluido y limpio (sin const problemáticos)
                        if (_isLoading)
                          Container(
                            color: Colors.white,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF0166B8)),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    textos[lang]!['loading']!,
                                    style: const TextStyle(
                                      color: Color(0xFF0166B8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                      ],
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
