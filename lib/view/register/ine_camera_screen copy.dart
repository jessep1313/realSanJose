import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:real_san_jose/api/auth_service.dart';

class IneCameraScreen extends StatefulWidget {
  const IneCameraScreen({super.key});

  @override
  State<IneCameraScreen> createState() => _IneCameraScreenState();
}

class _IneCameraScreenState extends State<IneCameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.max, // máxima resolución
      enableAudio: false,
    );

    _initializeControllerFuture = _controller.initialize();

    await _initializeControllerFuture;
    await _controller.setZoomLevel(1.0); // zoom neutral
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _captureAndProcess() async {
    setState(() => _isProcessing = true);
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      // Verificar tamaño real de la foto
      final file = File(image.path);
      debugPrint("📌 Foto capturada: ${file.lengthSync()} bytes");

      final service = AuthService();
      final result = await service.procesarIne(file);

      Navigator.pop(context, result); // regresa datos al RegisterScreen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error procesando INE: $e")),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                // Preview ajustado a pantalla completa
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.previewSize?.width ?? 0,
                      height: _controller.value.previewSize?.height ?? 0,
                      child: CameraPreview(_controller),
                    ),
                  ),
                ),

                // Overlay transparente tipo guía
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 420,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        "Coloca tu INE aquí",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                // Indicador de orientación
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone_android,
                          color: Colors.greenAccent, size: 28),
                      const SizedBox(width: 8),
                      const Text(
                        "Usa el teléfono en modo horizontal",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),

                // Botón de captura
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                      ),
                      onPressed: _isProcessing ? null : _captureAndProcess,
                      child: _isProcessing
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Icon(Icons.camera_alt,
                              color: Colors.white, size: 32),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
