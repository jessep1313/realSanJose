import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_san_jose/common/widget/borderradius.dart';
import 'package:real_san_jose/common/widget/custombutton.dart';
import 'package:real_san_jose/common/widget/customtextfield.dart';
import 'package:real_san_jose/provider/accountprovider.dart';
import 'package:real_san_jose/provider/editprofileprovider.dart';
import 'package:real_san_jose/utils/appcolor.dart';
import 'package:real_san_jose/utils/decoration.dart';

// ⭐ Provider de idioma
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  static var routeName = "/editprofilescreen";

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final picker = ImagePicker();
  XFile? documentoImagen;

  // Controladores
  final nombreCtrl = TextEditingController();
  final apellidosCtrl = TextEditingController();
  final fechaCtrl = TextEditingController();
  final domicilioCtrl = TextEditingController();
  final municipioCtrl = TextEditingController();
  final cpCtrl = TextEditingController();
  final estadoCtrl = TextEditingController();
  final rfcCtrl = TextEditingController();
  final curpCtrl = TextEditingController();

  @override
  void dispose() {
    nombreCtrl.dispose();
    apellidosCtrl.dispose();
    fechaCtrl.dispose();
    domicilioCtrl.dispose();
    municipioCtrl.dispose();
    cpCtrl.dispose();
    estadoCtrl.dispose();
    rfcCtrl.dispose();
    curpCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    final archivo = await picker.pickImage(source: ImageSource.gallery);
    if (archivo != null) {
      setState(() => documentoImagen = archivo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final selectedImage = ref.watch(editProfileProvider).selectedImage;

    final t = {
      'es': {
        'editar': 'Editar perfil',
        'nombre': 'Nombre',
        'apellidos': 'Apellidos',
        'fecha': 'Fecha de nacimiento (DD/MM/AAAA)',
        'domicilio': 'Domicilio',
        'municipio': 'Municipio',
        'cp': 'Código Postal',
        'estado': 'Estado',
        'rfc': 'RFC',
        'curp': 'CURP',
        'doc': 'Documento oficial',
        'gallery': 'Elegir de galería',
        'guardar': 'Actualizar',
        'editarFoto': 'Editar',
        'alertaTitulo': 'Datos actualizados',
        'alertaMsg': 'Tu información ha sido actualizada correctamente.',
        'ok': 'Aceptar',
      },
      'en': {
        'editar': 'Edit Profile',
        'nombre': 'First Name',
        'apellidos': 'Last Name',
        'fecha': 'Date of Birth (DD/MM/YYYY)',
        'domicilio': 'Address',
        'municipio': 'Municipality',
        'cp': 'Postal Code',
        'estado': 'State',
        'rfc': 'RFC',
        'curp': 'CURP',
        'doc': 'Official Document',
        'gallery': 'Choose from gallery',
        'guardar': 'Update',
        'editarFoto': 'Edit',
        'alertaTitulo': 'Profile updated',
        'alertaMsg': 'Your information has been successfully updated.',
        'ok': 'OK',
      }
    };

    return Container(
      decoration: bgDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        // ⭐ HEAD UNIFICADO
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          toolbarHeight: 60,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF003DA5)),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: Image.asset('assets/icons/logo.jpg', height: 90),
                  ),
                ),
                DropdownButton<String>(
                  value: lang,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'es', child: Text('ES 🇲🇽')),
                    DropdownMenuItem(value: 'en', child: Text('EN 🇺🇸')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(languageProvider.notifier).state = value;
                    }
                  },
                ),
              ],
            ),
          ),
        ),

        // ⭐ BODY
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.appBackgroundColor,
                  borderRadius: borderRadius(),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ⭐ FOTO DE PERFIL
                          GestureDetector(
                            onTap: () {
                              ref.read(editProfileProvider).getImageFromGallery();
                            },
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Stack(
                                  children: [
                                    selectedImage.isEmpty
                                        ? Image.asset(
                                            "assets/images/specialist2.jpg",
                                            width: 90,
                                            height: 90,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(selectedImage),
                                            width: 90,
                                            height: 90,
                                            fit: BoxFit.cover,
                                          ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 30,
                                        color: Colors.black45,
                                        child: Center(
                                          child: Text(
                                            t[lang]!['editarFoto']!,
                                            style: const TextStyle(color: Colors.white, fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ⭐ CAMPOS
                          CustomTextField(hintText: t[lang]!['nombre']!, controller: nombreCtrl),
                          CustomTextField(hintText: t[lang]!['apellidos']!, controller: apellidosCtrl),
                          CustomTextField(hintText: t[lang]!['fecha']!, controller: fechaCtrl),
                          CustomTextField(hintText: t[lang]!['domicilio']!, controller: domicilioCtrl),
                          CustomTextField(hintText: t[lang]!['municipio']!, controller: municipioCtrl),
                          CustomTextField(hintText: t[lang]!['cp']!, controller: cpCtrl),
                          CustomTextField(hintText: t[lang]!['estado']!, controller: estadoCtrl),
                          CustomTextField(hintText: t[lang]!['rfc']!, controller: rfcCtrl),
                          CustomTextField(hintText: t[lang]!['curp']!, controller: curpCtrl),

                          const SizedBox(height: 20),

                          // ⭐ DOCUMENTO
                          Text(t[lang]!['doc']!, style: const TextStyle(fontSize: 15)),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.photo_library),
                            label: Text(t[lang]!['gallery']!),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Color(0xFF003DA5), width: 2),
                            ),
                            onPressed: _pickFromGallery,
                          ),

                          if (documentoImagen != null)
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: Image.file(
                                File(documentoImagen!.path),
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),

                          const SizedBox(height: 40), // ⭐ ESPACIO PARA QUE NO SE OCUPE EL BOTÓN
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ⭐ BOTÓN ACTUALIZAR SIEMPRE VISIBLE
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: CustomButton(
                color: Colors.white.withOpacity(0.3),
                title: t[lang]!['guardar']!,
                ontap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: Text(
                          t[lang]!['alertaTitulo']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003DA5),
                          ),
                        ),
                        content: Text(t[lang]!['alertaMsg']!),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              context.go('/profilescreen');
                            },
                            child: Text(
                              t[lang]!['ok']!,
                              style: const TextStyle(color: Color(0xFF003DA5)),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

