import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ImagenesWebScreen extends StatelessWidget {
  final String url;
  const ImagenesWebScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ⭐ Header con flecha y logo
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
                  const SizedBox(width: 40), // balance visual
                ],
              ),
            ),

            Expanded(
              child: WebViewWidget(
                controller: WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..loadRequest(Uri.parse(url)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
