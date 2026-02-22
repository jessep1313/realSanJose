import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_san_jose/common/widget/custom_header.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class PersonaFormScreen extends ConsumerWidget {
  const PersonaFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    final textos = {
      'es': {
        'title': 'Nueva persona autorizada',
        'desc': 'Completa la información de la persona',
        'guardar': 'Guardar'
      },
      'en': {
        'title': 'New authorized person',
        'desc': 'Fill in the person’s information',
        'guardar': 'Save'
      },
    };

    // Controladores de texto
    final nombreController = TextEditingController();
    final parentescoController = TextEditingController();
    final completoController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header fijo
            const CustomHeader(title: "Formulario"),

            // Contenido con scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      textos[lang]!['title']!,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003DA5)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      textos[lang]!['desc']!,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 20),

                    // Campos del formulario
                    TextField(
                      controller: nombreController,
                      decoration: InputDecoration(
                        labelText: lang == 'es' ? "Nombre corto" : "Short name",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: parentescoController,
                      decoration: InputDecoration(
                        labelText: lang == 'es' ? "Parentesco" : "Relationship",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: completoController,
                      decoration: InputDecoration(
                        labelText: lang == 'es' ? "Nombre completo" : "Full name",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 80), // espacio para no tapar footer
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Footer fijo con botón guardar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF009639),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const Icon(Icons.save, color: Colors.white),
          label: Text(textos[lang]!['guardar']!,
              style: const TextStyle(color: Colors.white)),
          onPressed: () {
            // TODO: lógica para guardar la persona
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(lang == 'es'
                    ? "Persona guardada correctamente"
                    : "Person saved successfully"),
              ),
            );
            Navigator.pop(context); // regresar a la lista
          },
        ),
      ),
    );
  }
}
