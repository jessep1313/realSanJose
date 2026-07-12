import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:real_san_jose/api/auth_service.dart';

class PassportCameraScreen extends StatefulWidget {
  const PassportCameraScreen({super.key});

  @override
  State<PassportCameraScreen> createState() => _PassportCameraScreenState();
}

class _PassportCameraScreenState extends State<PassportCameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isProcessing = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Forzar orientación horizontal al abrir la pantalla
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        backCamera,
        ResolutionPreset.max, // máxima resolución
        enableAudio: false,
      );

      _initializeControllerFuture = _controller.initialize();
      await _initializeControllerFuture;

      // Forzar zoom neutral (1.0) si el dispositivo lo soporta
      try {
        await _controller.setZoomLevel(1.0);
      } catch (_) {}

      _isInitialized = true;
      if (mounted) setState(() {});
    } catch (e, st) {
      debugPrint("Error inicializando cámara: $e\n$st");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No se pudo inicializar la cámara: $e")),
        );
      }
    }
  }

  @override
  void dispose() {
    // Restaurar orientaciones al salir
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    try {
      _controller.dispose();
    } catch (_) {}
    super.dispose();
  }

  Future<void> _captureAndProcess() async {
    if (!_isInitialized) return;
    setState(() => _isProcessing = true);

    try {
      await _initializeControllerFuture;
      final XFile image = await _controller.takePicture();

      final file = File(image.path);
      debugPrint("📌 Foto capturada: ${file.lengthSync()} bytes");
      debugPrint("📌 Ruta foto: ${image.path}");

      final service = AuthService();
      final response = await service.procesarPasaporte(file);

      if (response is Map && response['Datos'] is Map) {
        Navigator.pop(context, Map<String, dynamic>.from(response['Datos']));
      } else {
        Navigator.pop(context, response);
      }
    } catch (e, st) {
      debugPrint("Error en captura/procesado: $e\n$st");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error procesando pasaporte: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final previewSize = _controller.value.previewSize;
    final previewWidth =
        previewSize?.width ?? MediaQuery.of(context).size.width;
    final previewHeight =
        previewSize?.height ?? MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Preview a pantalla completa (similar a la app nativa)
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: previewWidth,
                height: previewHeight,
                child: CameraPreview(_controller),
              ),
            ),
          ),

          // Overlay transparente tipo guía con medidas EXACTAS 420x200 (centrado)
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 420, // EXACTO según tu requerimiento
              height: 200, // EXACTO según tu requerimiento
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.white.withOpacity(0.95), width: 3),
                borderRadius: BorderRadius.circular(12),
                color: Colors.transparent,
              ),
              child: Center(
                child: Text(
                  "Coloca tu pasaporte aquí",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),

          // Indicador de orientación (opcional)
          Positioned(
            top: 12,
            left: 12,
            child: Row(
              children: const [
                Icon(Icons.screen_rotation, color: Colors.white70),
                SizedBox(width: 8),
                Text("Horizontal", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          // Botón de captura
          Positioned(
            bottom: 18,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(18),
                ),
                onPressed: _isProcessing ? null : _captureAndProcess,
                child: _isProcessing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.camera_alt,
                        color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
