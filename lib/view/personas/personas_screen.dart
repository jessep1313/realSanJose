import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_san_jose/common/widget/custom_header.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';
import 'persona_form_screen.dart'; // 👈 importamos la pantalla del formulario

class PersonasScreen extends ConsumerWidget {
  const PersonasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    final textos = {
      'es': {
        'title': 'Personas autorizadas',
        'desc': 'Gestiona quién puede acceder a tu información',
        'agregar': 'Agregar persona autorizada'
      },
      'en': {
        'title': 'Authorized persons',
        'desc': 'Manage who can access your information',
        'agregar': 'Add authorized person'
      },
    };

    // Lista simulada de personas autorizadas
    final personas = [
      {
        "nombre": "María Pérez",
        "parentesco": lang == 'es' ? "Hermana" : "Sister",
        "completo": "María Fernanda Pérez López"
      },
      {
        "nombre": "Juan García",
        "parentesco": lang == 'es' ? "Padre" : "Father",
        "completo": "Juan Antonio García Ramírez"
      },
      {
        "nombre": "Ana Torres",
        "parentesco": lang == 'es' ? "Esposa" : "Wife",
        "completo": "Ana Sofía Torres Martínez"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header fijo
            const CustomHeader(title: "Personas"),

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

                    // Listado de personas
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: personas.length,
                      itemBuilder: (context, index) {
                        final p = personas[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                                color: Color(0xFF003DA5), width: 2),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.person,
                                color: Color(0xFF009639)),
                            title: Text(p["nombre"]!),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p["parentesco"]!),
                                Text(p["completo"]!,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black54)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 80), // espacio para no tapar footer
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Footer fijo con botón
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
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(textos[lang]!['agregar']!,
              style: const TextStyle(color: Colors.white)),
          onPressed: () {
            // Navegar al formulario
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PersonaFormScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}

