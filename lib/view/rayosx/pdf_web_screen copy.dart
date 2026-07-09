import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfWebScreen extends StatefulWidget {
  final String url;
  const PdfWebScreen({super.key, required this.url});

  @override
  State<PdfWebScreen> createState() => _PdfWebScreenState();
}

class _PdfWebScreenState extends State<PdfWebScreen> {
  String? _localPath;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _downloadPdf();
  }

  Future<void> _downloadPdf() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // 1. Obtener el directorio temporal del dispositivo
      final directory = await getTemporaryDirectory();
      final filename = 'reporte_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$filename');

      // 2. Realizar la petición de descarga al reporteador
      final response = await http.get(Uri.parse(widget.url));

      if (response.statusCode == 200) {
        // 3. Guardar el archivo en el almacenamiento local seguro
        await file.writeAsBytes(response.bodyBytes);

        if (mounted) {
          setState(() {
            _localPath = file.path;
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error descargando PDF: $e");
      if (mounted) {
        setState(() {
          _errorMessage = 'No se pudo cargar el reporte de resultados.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Institucional Limpio original de Real San José
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Color(0xFF003DA5), size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Center(
                    child: Image.asset('assets/icons/logo.jpg', height: 80),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // Cuerpo de visualización protegido
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF003DA5)),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Descargando reporte seguro...",
                            style: TextStyle(
                                color: Color(0xFF003DA5),
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    )
                  : _errorMessage.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  color: Colors.red, size: 48),
                              const SizedBox(height: 16),
                              Text(_errorMessage,
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF003DA5)),
                                onPressed: _downloadPdf,
                                child: const Text("Reintentar",
                                    style: TextStyle(color: Colors.white)),
                              )
                            ],
                          ),
                        )
                      : Container(
                          color: Colors.grey[200],
                          // 🌟 Renderizado 100% nativo dentro de la app sin barras web ni URLs
                          child: PDFView(
                            filePath: _localPath,
                            enableSwipe: true,
                            swipeHorizontal: false,
                            autoSpacing: true,
                            pageFling: true,
                            onError: (error) {
                              setState(() {
                                _errorMessage =
                                    'Error al renderizar el documento.';
                              });
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
