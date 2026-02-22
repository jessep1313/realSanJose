import 'package:flutter/material.dart';

class DirectorioScreen extends StatelessWidget {
  const DirectorioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Servicios Médicos")),
      body: const Center(child: Text("Contenido de Servicios Médicos")),
    );
  }
}
