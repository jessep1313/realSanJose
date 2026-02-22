import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_san_jose/common/widget/borderradius.dart';
import 'package:real_san_jose/common/widget/custombutton.dart';
import 'package:real_san_jose/common/widget/customtextfield.dart';
import 'package:real_san_jose/utils/decoration.dart';
import 'package:real_san_jose/view/dashboard/dashboardscreen.dart';
import 'package:real_san_jose/view/login/loginscreen.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static var routeName = "/registerscreen";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final picker = ImagePicker();
  XFile? documentoImagen;

  // Controladores
  final nombreCtrl = TextEditingController();
  final apellidosCtrl = TextEditingController();
  final fechaCtrl = TextEditingController(); // formato sugerido: DD/MM/AAAA
  final domicilioCtrl = TextEditingController();
  final municipioCtrl = TextEditingController();
  final cpCtrl = TextEditingController();
  final estadoCtrl = TextEditingController();
  final rfcCtrl = TextEditingController();
  final curpCtrl = TextEditingController();

  // Nacionalidad y tipo de documento
  String nacionalidad = 'Mexicano'; // Mexicano | Extranjero
  String tipoDocumento = 'INE';     // INE | Pasaporte

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

  Future<void> _pickFromCamera() async {
    final archivo = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      maxWidth: 1080,
      maxHeight: 1920,
    );
    if (archivo != null) {
      setState(() => documentoImagen = archivo);
      if (tipoDocumento == 'INE') {
        await _procesarIne(File(archivo.path));
      }
    }
  }

  Future<void> _pickFromGallery() async {
    final archivo = await picker.pickImage(source: ImageSource.gallery);
    if (archivo != null) {
      setState(() => documentoImagen = archivo);
      if (tipoDocumento == 'INE') {
        await _procesarIne(File(archivo.path));
      }
    }
  }

  Future<void> _procesarIne(File imagen) async {
    // OCR deshabilitado temporalmente (ML Kit removido)
    debugPrint('OCR deshabilitado temporalmente');
  }

  bool validarCurpConDatos() {
    final curp = curpCtrl.text.toUpperCase().trim();
    if (curp.length < 10) return false;

    final nombre = nombreCtrl.text.trim().toUpperCase();
    final apellidos = apellidosCtrl.text.trim().toUpperCase();

    if (nombre.isEmpty || apellidos.isEmpty) return false;
    if (fechaCtrl.text.trim().isEmpty) return false;

    // Se espera fecha en formato DD/MM/AAAA
    final partes = fechaCtrl.text.split('/');
    if (partes.length != 3) return false;

    final dd = partes[0].padLeft(2, '0');
    final mm = partes[1].padLeft(2, '0');
    final yyyy = partes[2];
    if (yyyy.length != 4) return false;

    final aa = yyyy.substring(2, 4);
    final fechaCurp = '$aa$mm$dd';

    // Fecha en CURP posiciones 5–10 (índices 4–9)
    if (curp.length < 10 || curp.substring(4, 10) != fechaCurp) return false;

    // Primera letra del primer apellido debe coincidir con la primera letra de la CURP
    if (apellidos.isEmpty || curp[0] != apellidos[0]) return false;

    return true;
  }

  bool _validarCampos() {
    String error = '';
    if (nombreCtrl.text.trim().isEmpty) {
      error = 'Nombre es obligatorio';
    } else if (apellidosCtrl.text.trim().isEmpty) {
      error = 'Apellidos son obligatorios';
    } else if (fechaCtrl.text.trim().isEmpty) {
      error = 'Fecha de nacimiento es obligatoria';
    } else if (domicilioCtrl.text.trim().isEmpty) {
      error = 'Domicilio es obligatorio';
    } else if (municipioCtrl.text.trim().isEmpty) {
      error = 'Municipio es obligatorio';
    } else if (cpCtrl.text.trim().isEmpty ||
        !RegExp(r'^\d{5}$').hasMatch(cpCtrl.text)) {
      error = 'Código Postal inválido';
    } else if (estadoCtrl.text.trim().isEmpty) {
      error = 'Estado es obligatorio';
    } else if (rfcCtrl.text.trim().isEmpty ||
        !RegExp(r'^[A-ZÑ&]{3,4}\d{6}[A-Z0-9]{3}$')
            .hasMatch(rfcCtrl.text.toUpperCase())) {
      error = 'RFC inválido';
    } else if (curpCtrl.text.trim().isEmpty ||
        !RegExp(r'^[A-Z]{4}\d{6}[HM][A-Z]{5}\d{2}$')
            .hasMatch(curpCtrl.text.toUpperCase())) {
      error = 'CURP inválida';
    } else if (!validarCurpConDatos()) {
      error = 'CURP no coincide con los datos personales';
    }

    if (error.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    final textos = {
      'es': {
        'titulo': 'Registro de usuario',
        'nacionalidad': 'Nacionalidad',
        'mexicano': 'Mexicano',
        'extranjero': 'Extranjero',
        'tipo': 'Tipo de documento',
        'doc': 'Documento oficial',
        'docHint': '(INE con OCR / Pasaporte / CURP)',
        'camera': 'Tomar foto',
        'gallery': 'Elegir de galería',
        'nombre': 'Nombre',
        'apellidos': 'Apellidos',
        'fecha': 'Fecha de nacimiento (DD/MM/AAAA)',
        'domicilio': 'Domicilio',
        'municipio': 'Municipio',
        'cp': 'Código Postal',
        'estado': 'Estado',
        'rfc': 'RFC',
        'curp': 'CURP',
        'signup': 'Registrarse',
        'login': '¿Ya tienes cuenta?',
        'backLogin': 'Login',
      },
      'en': {
        'titulo': 'User Registration',
        'nacionalidad': 'Nationality',
        'mexicano': 'Mexican',
        'extranjero': 'Foreigner',
        'tipo': 'Document type',
        'doc': 'Official document',
        'docHint': '(INE with OCR / Passport / CURP)',
        'camera': 'Take photo',
        'gallery': 'Choose from gallery',
        'nombre': 'First Name',
        'apellidos': 'Last Name',
        'fecha': 'Date of Birth (DD/MM/YYYY)',
        'domicilio': 'Address',
        'municipio': 'Municipality',
        'cp': 'Postal Code',
        'estado': 'State',
        'rfc': 'RFC',
        'curp': 'CURP',
        'signup': 'Sign Up',
        'login': 'Already have an account?',
        'backLogin': 'Login',
      }
    };

    return Container(
      decoration: bgDecoration(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF003DA5)),
            onPressed: () => context.push(OnboardingScreen.routeName),
          ),
          actions: [
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
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: borderRadius(),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Center(
                          child: Image.asset(
                            'assets/icons/logo.jpg',
                            height: 90,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            textos[lang]!['titulo']!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Nacionalidad
                        Text(
                          textos[lang]!['nacionalidad']!,
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          children: [
                            ChoiceChip(
                              label: Text(textos[lang]!['mexicano']!),
                              selected: nacionalidad == 'Mexicano',
                              onSelected: (_) {
                                setState(() {
                                  nacionalidad = 'Mexicano';
                                  tipoDocumento = 'INE';
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text(textos[lang]!['extranjero']!),
                              selected: nacionalidad == 'Extranjero',
                              onSelected: (_) {
                                setState(() {
                                  nacionalidad = 'Extranjero';
                                  tipoDocumento = 'Pasaporte';
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Tipo de documento
                        Text(
                          textos[lang]!['tipo']!,
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          children: [
                            if (nacionalidad == 'Mexicano')
                              ChoiceChip(
                                label: const Text('INE'),
                                selected: tipoDocumento == 'INE',
                                onSelected: (_) =>
                                    setState(() => tipoDocumento = 'INE'),
                              ),
                            ChoiceChip(
                              label: const Text('Pasaporte'),
                              selected: tipoDocumento == 'Pasaporte',
                              onSelected: (_) =>
                                  setState(() => tipoDocumento = 'Pasaporte'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Datos personales
                        CustomTextField(
                          hintText: textos[lang]!['nombre']!,
                          controller: nombreCtrl,
                          leadingIconData: const Icon(Icons.person),
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        CustomTextField(
                          hintText: textos[lang]!['apellidos']!,
                          controller: apellidosCtrl,
                          leadingIconData: const Icon(Icons.person_outline),
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        CustomTextField(
                          hintText: textos[lang]!['fecha']!,
                          controller: fechaCtrl,
                          leadingIconData: const Icon(Icons.cake),
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        CustomTextField(
                          hintText: textos[lang]!['domicilio']!,
                          controller: domicilioCtrl,
                          leadingIconData: const Icon(Icons.home),
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        CustomTextField(
                          hintText: textos[lang]!['municipio']!,
                          controller: municipioCtrl,
                          leadingIconData: const Icon(Icons.location_city),
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        CustomTextField(
                          hintText: textos[lang]!['cp']!,
                          controller: cpCtrl,
                          leadingIconData:
                              const Icon(Icons.markunread_mailbox),
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        CustomTextField(
                          hintText: textos[lang]!['estado']!,
                          controller: estadoCtrl,
                          leadingIconData: const Icon(Icons.map),
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        CustomTextField(
                          hintText: textos[lang]!['rfc']!,
                          controller: rfcCtrl,
                          leadingIconData: const Icon(Icons.credit_card),
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        CustomTextField(
                          hintText: textos[lang]!['curp']!,
                          controller: curpCtrl,
                          leadingIconData:
                              const Icon(Icons.assignment_ind),
                          color: Colors.grey.withOpacity(0.2),
                        ),

                        const SizedBox(height: 20),

                        // Documento oficial (después de datos personales)
                        Row(
                          children: [
                            Text(
                              '${textos[lang]!['doc']!} ',
                              style: const TextStyle(fontSize: 15),
                            ),
                            Text(
                              textos[lang]!['docHint']!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.camera_alt),
                                label: Text(textos[lang]!['camera']!),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: Color(0xFF003DA5),
                                    width: 2,
                                  ),
                                ),
                                onPressed: _pickFromCamera,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.photo_library),
                                label: Text(textos[lang]!['gallery']!),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: Color(0xFF003DA5),
                                    width: 2,
                                  ),
                                ),
                                onPressed: _pickFromGallery,
                              ),
                            ),
                          ],
                        ),

                        if (documentoImagen != null)
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            child: Image.file(
                              File(documentoImagen!.path),
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),

                        const SizedBox(height: 20),
                        CustomButton(
                          title: textos[lang]!['signup']!,
                          ontap: () {
                            if (_validarCampos()) {
                              context.go(DashboardScreen.routeName);
                            }
                          },
                          color: const Color(0xFF003DA5),
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    textos[lang]!['login']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push(LoginScreen.routeName),
                    child: Text(
                      ' ${textos[lang]!['backLogin']!}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
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
