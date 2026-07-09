// lib/view/recorrido/recorrido_virtual_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class RecorridoVirtualScreen extends ConsumerStatefulWidget {
  static const String routeName = '/recorridoVirtual';
  final String url;
  const RecorridoVirtualScreen(
      {super.key,
      this.url = "https://tourmkr.com/F18aqMXnd3/46124054p&353.2h&88.81t"});

  @override
  ConsumerState<RecorridoVirtualScreen> createState() =>
      _RecorridoVirtualScreenState();
}

class _RecorridoVirtualScreenState
    extends ConsumerState<RecorridoVirtualScreen> {
  late InAppWebViewController _controller;
  bool _isLoading = true;
  String _error = '';

  Future<void> _saveLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', lang);
    ref.read(languageProvider.notifier).state = lang;
  }

  @override
  void initState() {
    super.initState();
    // No special platform init required for flutter_inappwebview here.
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header: back arrow left, logo center, language right (same style as Register)
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
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
                  DropdownButton<String>(
                    value: lang,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'es', child: Text('ES 🇲🇽')),
                      DropdownMenuItem(value: 'en', child: Text('EN 🇺🇸')),
                    ],
                    onChanged: (value) {
                      if (value != null) _saveLanguage(value);
                    },
                  ),
                ],
              ),
            ),

            // Optional small title
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: Text(
                lang == 'es' ? 'Recorrido Virtual' : 'Virtual Tour',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF003DA5),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // WebView (InAppWebView) with settings similar to ImagenesWebScreen
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                    initialSettings: InAppWebViewSettings(
                      javaScriptEnabled: true,
                      transparentBackground: true,
                      supportZoom: true,
                      builtInZoomControls: true,
                      displayZoomControls: false,
                      allowFileAccessFromFileURLs: true,
                      allowUniversalAccessFromFileURLs: true,
                      useOnDownloadStart: true,
                      mediaPlaybackRequiresUserGesture: false,
                    ),
                    onWebViewCreated: (controller) {
                      _controller = controller;
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        _isLoading = true;
                        _error = '';
                      });
                    },
                    onLoadStop: (controller, url) async {
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    onLoadError: (controller, url, code, message) {
                      setState(() {
                        _isLoading = false;
                        _error = 'Error cargando el recorrido: $message';
                      });
                    },
                    onReceivedServerTrustAuthRequest:
                        (controller, challenge) async {
                      // Si el servidor tiene certificados especiales, puedes manejarlo aquí.
                      return ServerTrustAuthResponse(
                          action: ServerTrustAuthResponseAction.PROCEED);
                    },
                  ),

                  // Loading overlay
                  if (_isLoading)
                    Container(
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF003DA5)),
                            ),
                            SizedBox(height: 12),
                            Text(
                              "Cargando recorrido virtual...",
                              style: TextStyle(
                                color: Color(0xFF003DA5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Error overlay
                  if (_error.isNotEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.red, size: 56),
                            const SizedBox(height: 12),
                            Text(_error, textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF003DA5)),
                              onPressed: () {
                                setState(() {
                                  _error = '';
                                  _isLoading = true;
                                });
                                _controller.loadUrl(
                                    urlRequest:
                                        URLRequest(url: WebUri(widget.url)));
                              },
                              child:
                                  Text(lang == 'es' ? 'Reintentar' : 'Retry'),
                            ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF003DA5),
        child: const Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            _isLoading = true;
            _error = '';
          });
          _controller.reload();
        },
      ),
    );
  }
}
