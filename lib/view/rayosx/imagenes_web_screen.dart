import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart'; // 🌟 Tu librería blindada

class ImagenesWebScreen extends StatefulWidget {
  final String url;
  const ImagenesWebScreen({super.key, required this.url});

  @override
  State<ImagenesWebScreen> createState() => _ImagenesWebScreenState();
}

class _ImagenesWebScreenState extends State<ImagenesWebScreen> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ⭐ Header institucional original de Real San José
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
                  const SizedBox(width: 40), // Balance visual
                ],
              ),
            ),

            // Contenedor del WebView Blindado para la Página Web de Imágenes
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                    initialSettings: InAppWebViewSettings(
                      javaScriptEnabled:
                          true, // Obligatorio para que carguen los visores médicos dinámicos
                      transparentBackground: true,
                      supportZoom:
                          true, // Permite hacer zoom con los dedos en la página
                      builtInZoomControls: true,
                      displayZoomControls:
                          false, // Oculta los botones flotantes de la lupa (+ y -)
                      allowFileAccessFromFileURLs: true,
                      allowUniversalAccessFromFileURLs: true,
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
                          "Error en Portal de Imágenes: ${error.description}");
                    },
                  ),

                  // Indicador de carga institucional sobrepuesto
                  // Indicador de carga institucional sobrepuesto
                  if (_isLoading)
                    Container(
                      // 🌟 QUITAMOS 'const' DE AQUÍ
                      color: Colors.white,
                      child: const Center(
                        // 🌟 Lo puedes poner aquí adentro para optimizar el resto
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF003DA5)),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Cargando portal de imágenes...",
                              style: TextStyle(
                                color: Color(0xFF003DA5),
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
