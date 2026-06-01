import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class PdfWebScreen extends StatefulWidget {
  final String url;
  const PdfWebScreen({super.key, required this.url});

  @override
  State<PdfWebScreen> createState() => _PdfWebScreenState();
}

class _PdfWebScreenState extends State<PdfWebScreen> {
  late PdfControllerPinch _pdfController;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final dir = await getTemporaryDirectory();
      final filePath = "${dir.path}/temp.pdf";

      await Dio().download(widget.url, filePath);

      _pdfController = PdfControllerPinch(
        document: PdfDocument.openFile(filePath),
      );

      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      debugPrint("Error cargando PDF: $e");
    }
  }

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
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : PdfViewPinch(controller: _pdfController),
            ),
          ],
        ),
      ),
    );
  }
}
