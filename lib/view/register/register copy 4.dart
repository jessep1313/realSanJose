// lib/view/register/register.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:real_san_jose/common/widget/borderradius.dart';
import 'package:real_san_jose/common/widget/custombutton.dart';
import 'package:real_san_jose/common/widget/customtextfield.dart';
import 'package:real_san_jose/utils/decoration.dart';
import 'package:real_san_jose/view/dashboard/dashboardscreen.dart';
import 'package:real_san_jose/view/login/loginscreen.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:real_san_jose/api/auth_service.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static var routeName = "/registerscreen";

  const RegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final picker = ImagePicker();

  // Imágenes específicas
  XFile? documentoImagen; // para pasaporte u otros documentos genéricos
  XFile? ineFrente;
  XFile? ineReverso;

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

  // Seguro
  bool tieneSeguro = false;
  List<Map<String, dynamic>> aseguradoras = [];
  String? aseguradoraSeleccionadaId;
  final polizaCtrl = TextEditingController();
  bool cargandoAseguradoras = false;

  // Nacionalidad y tipo de documento
  String nacionalidad = 'Mexicano'; // Mexicano | Extranjero
  String tipoDocumento = 'INE'; // INE | Pasaporte

  @override
  void initState() {
    super.initState();
    _cargarAseguradorasSiCorresponde();
  }

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
    polizaCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarAseguradorasSiCorresponde() async {
    try {
      setState(() => cargandoAseguradoras = true);
      final service = AuthService();
      final lista = await service.fetchAseguradoras();
      setState(() {
        aseguradoras = lista;
      });
    } catch (e) {
      debugPrint('Error cargando aseguradoras: $e');
    } finally {
      setState(() => cargandoAseguradoras = false);
    }
  }

  // Funciones reutilizables para cámara/galería (para pasaporte u otros)
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

  /// OCR con ML Kit (idéntico a tu implementación previa)
  Future<void> _procesarIne(File imagen) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    TextRecognizer? textRecognizer;
    try {
      final inputImage = InputImage.fromFilePath(imagen.path);
      textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      final raw = recognizedText.text;
      final text = raw.replaceAll(RegExp(r'\s+'), ' ').toUpperCase();

      final curpMatch =
          RegExp(r'[A-Z]{4}\d{6}[HM][A-Z]{5}\d{2}').firstMatch(text);
      if (curpMatch != null) {
        curpCtrl.text = curpMatch.group(0)!;
      }

      final dateMatch =
          RegExp(r'(\d{2})[\/\-](\d{2})[\/\-](\d{2,4})').firstMatch(text);
      if (dateMatch != null) {
        final dd = dateMatch.group(1);
        final mm = dateMatch.group(2);
        final yyRaw = dateMatch.group(3)!;
        final yyyy = yyRaw.length == 2 ? '19$yyRaw' : yyRaw;
        fechaCtrl.text = '$dd/$mm/$yyyy';
      }

      // heurísticas nombre/apellidos/domicilio/municipio/estado (igual que antes)
      String? nombreExtra;
      String? apellidosExtra;

      final nombreLabelMatch =
          RegExp(r'NOMBRE[S]?:\s*([A-ZÁÉÍÓÚÑ\s]+)').firstMatch(text);
      if (nombreLabelMatch != null) {
        final full = nombreLabelMatch.group(1)!.trim();
        final parts = full.split(RegExp(r'\s+'));
        if (parts.length >= 2) {
          nombreExtra = parts.last;
          apellidosExtra = parts.sublist(0, parts.length - 1).join(' ');
        } else {
          nombreExtra = full;
        }
      } else {
        final fallback =
            RegExp(r'([A-ZÁÉÍÓÚÑ]{2,}\s+[A-ZÁÉÍÓÚÑ]{2,}\s+[A-ZÁÉÍÓÚÑ]{2,})')
                .firstMatch(text);
        if (fallback != null) {
          final parts = fallback.group(1)!.split(RegExp(r'\s+'));
          if (parts.length >= 3) {
            nombreExtra = parts.sublist(parts.length - 1).join(' ');
            apellidosExtra = parts.sublist(0, parts.length - 1).join(' ');
          }
        }
      }

      if (nombreExtra != null && nombreCtrl.text.trim().isEmpty) {
        nombreCtrl.text = nombreExtra;
      }
      if (apellidosExtra != null && apellidosCtrl.text.trim().isEmpty) {
        apellidosCtrl.text = apellidosExtra;
      }

      final domMatch =
          RegExp(r'DOMICILIO[:\s]*([A-Z0-9ÁÉÍÓÚÑ\.,#\-\s]+)').firstMatch(text);
      if (domMatch != null && domicilioCtrl.text.trim().isEmpty) {
        domicilioCtrl.text = domMatch.group(1)!.trim();
      }

      final municipioMatch =
          RegExp(r'MUNICIPIO[:\s]*([A-ZÁÉÍÓÚÑ\s]+)').firstMatch(text);
      if (municipioMatch != null && municipioCtrl.text.trim().isEmpty) {
        municipioCtrl.text = municipioMatch.group(1)!.trim();
      }

      final estadoMatch =
          RegExp(r'(ENTIDAD|ESTADO)[:\s]*([A-ZÁÉÍÓÚÑ\s]+)').firstMatch(text);
      if (estadoMatch != null && estadoCtrl.text.trim().isEmpty) {
        if (estadoMatch.groupCount >= 2 && estadoMatch.group(2) != null) {
          estadoCtrl.text = estadoMatch.group(2)!.trim();
        } else {
          estadoCtrl.text = estadoMatch
              .group(0)!
              .replaceAll(RegExp(r'(ENTIDAD|ESTADO)[:\s]*'), '')
              .trim();
        }
      }

      if ((nombreCtrl.text.trim().isEmpty ||
              apellidosCtrl.text.trim().isEmpty) &&
          recognizedText.blocks.isNotEmpty) {
        for (final block in recognizedText.blocks) {
          for (final line in block.lines) {
            final lineText = line.text.trim().toUpperCase();
            final words = lineText.split(RegExp(r'\s+'));
            if (words.length >= 2 &&
                words.length <= 4 &&
                words.every((w) => w.length >= 2)) {
              if (curpMatch != null && lineText.contains(curpMatch.group(0)!))
                continue;
              if (nombreCtrl.text.trim().isEmpty) {
                nombreCtrl.text = words.last;
              }
              if (apellidosCtrl.text.trim().isEmpty) {
                apellidosCtrl.text =
                    words.sublist(0, words.length - 1).join(' ');
              }
              break;
            }
          }
          if (nombreCtrl.text.trim().isNotEmpty &&
              apellidosCtrl.text.trim().isNotEmpty) break;
        }
      }

      setState(() {});
    } catch (e, st) {
      debugPrint('OCR error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('No se pudieron extraer datos. Intenta otra foto.')),
        );
      }
    } finally {
      try {
        await textRecognizer?.close();
      } catch (_) {}
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
    }
  }

  bool validarCurpConDatos() {
    final curp = curpCtrl.text.toUpperCase().trim();
    if (curp.length < 10) return false;

    final nombre = nombreCtrl.text.trim().toUpperCase();
    final apellidos = apellidosCtrl.text.trim().toUpperCase();

    if (nombre.isEmpty || apellidos.isEmpty) return false;
    if (fechaCtrl.text.trim().isEmpty) return false;

    final partes = fechaCtrl.text.split('/');
    if (partes.length != 3) return false;

    final dd = partes[0].padLeft(2, '0');
    final mm = partes[1].padLeft(2, '0');
    final yyyy = partes[2];
    if (yyyy.length != 4) return false;

    final aa = yyyy.substring(2, 4);
    final fechaCurp = '$aa$mm$dd';

    if (curp.length < 10 || curp.substring(4, 10) != fechaCurp) return false;

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

    if (error.isEmpty && tieneSeguro) {
      if (aseguradoraSeleccionadaId == null ||
          aseguradoraSeleccionadaId!.isEmpty) {
        error = 'Selecciona una aseguradora';
      } else if (polizaCtrl.text.trim().isEmpty) {
        error = 'Número de póliza es obligatorio';
      }
    }

    if (error.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return false;
    }
    return true;
  }

  Map<String, dynamic> buildRegisterPayload() {
    final Map<String, dynamic> payload = <String, dynamic>{
      'Nombre': nombreCtrl.text.trim(),
      'Apellidos': apellidosCtrl.text.trim(),
      'FechaNacimiento': fechaCtrl.text.trim(),
      'Domicilio': domicilioCtrl.text.trim(),
      'Municipio': municipioCtrl.text.trim(),
      'CodigoPostal': cpCtrl.text.trim(),
      'Estado': estadoCtrl.text.trim(),
      'Rfc': rfcCtrl.text.trim(),
      'Curp': curpCtrl.text.trim(),
    };

    if (tieneSeguro) {
      payload['TieneSeguro'] = true;
      payload['AseguradoraId'] = aseguradoraSeleccionadaId;
      payload['NumeroPoliza'] = polizaCtrl.text.trim();
    } else {
      payload['TieneSeguro'] = false;
    }

    return payload;
  }

  Future<void> _submitRegistro() async {
    if (!_validarCampos()) return;

    final payload = buildRegisterPayload();
    debugPrint('Payload registro: $payload');

    // Llamada real al servicio de registro si la implementas en AuthService
    // final service = AuthService();
    // await service.register(payload);

    context.go(DashboardScreen.routeName);
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
        'tieneSeguro': '¿Tienes seguro?',
        'si': 'Sí',
        'no': 'No',
        'eligeAseguradora': 'Elige una aseguradora',
        'numeroPoliza': 'Número de póliza',
        'frente': 'Frente',
        'reverso': 'Reverso',
        'fotografiasINE': 'Fotografías de INE',
        'fotografiaPasaporte': 'Fotografía del Pasaporte',
        'ineFrenteLabel': 'INE Frente:',
        'ineReversoLabel': 'INE Reverso:',
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
        'tieneSeguro': 'Do you have insurance?',
        'si': 'Yes',
        'no': 'No',
        'eligeAseguradora': 'Choose an insurer',
        'numeroPoliza': 'Policy number',
        'frente': 'Front',
        'reverso': 'Back',
        'fotografiasINE': 'INE Photos',
        'fotografiaPasaporte': 'Passport Photo',
        'ineFrenteLabel': 'INE Front:',
        'ineReversoLabel': 'INE Back:',
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
                                  documentoImagen = null;
                                  ineFrente = null;
                                  ineReverso = null;
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
                                  documentoImagen = null;
                                  ineFrente = null;
                                  ineReverso = null;
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
                                onSelected: (_) => setState(() {
                                  tipoDocumento = 'INE';
                                  documentoImagen = null;
                                  ineFrente = null;
                                  ineReverso = null;
                                }),
                              ),
                            ChoiceChip(
                              label: const Text('Pasaporte'),
                              selected: tipoDocumento == 'Pasaporte',
                              onSelected: (_) => setState(() {
                                tipoDocumento = 'Pasaporte';
                                documentoImagen = null;
                                ineFrente = null;
                                ineReverso = null;
                              }),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // INE FRENTE / REVERSO o PASAPORTE
                        if (tipoDocumento == 'INE') ...[
                          Text(
                            textos[lang]!['fotografiasINE']!,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.camera_alt),
                                  label: Text(textos[lang]!['frente']!),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(
                                        color: Color(0xFF003DA5), width: 2),
                                  ),
                                  onPressed: () async {
                                    final archivo = await picker.pickImage(
                                        source: ImageSource.camera);
                                    if (archivo != null) {
                                      setState(() => ineFrente = archivo);
                                      await _procesarIne(File(archivo.path));
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.camera_alt_outlined),
                                  label: Text(textos[lang]!['reverso']!),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(
                                        color: Color(0xFF003DA5), width: 2),
                                  ),
                                  onPressed: () async {
                                    final archivo = await picker.pickImage(
                                        source: ImageSource.camera);
                                    if (archivo != null) {
                                      setState(() => ineReverso = archivo);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          if (ineFrente != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(textos[lang]!['ineFrenteLabel']!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(ineFrente!.path),
                                    height: 180,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 15),
                          if (ineReverso != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(textos[lang]!['ineReversoLabel']!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(ineReverso!.path),
                                    height: 180,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 20),
                        ] else ...[
                          Text(
                            textos[lang]!['fotografiaPasaporte']!,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.camera_alt),
                            label: Text(textos[lang]!['camera']!),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                  color: Color(0xFF003DA5), width: 2),
                            ),
                            onPressed: () async {
                              final archivo = await picker.pickImage(
                                  source: ImageSource.camera);
                              if (archivo != null) {
                                setState(() => documentoImagen = archivo);
                              }
                            },
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
                          const SizedBox(height: 20),
                        ],

                        // DATOS PERSONALES (se autocompletan si OCR está integrado)
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
                          leadingIconData: const Icon(Icons.markunread_mailbox),
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
                          leadingIconData: const Icon(Icons.assignment_ind),
                          color: Colors.grey.withOpacity(0.2),
                        ),

                        // BLOQUE: Seguro (moved after CURP)
                        const SizedBox(height: 12),
                        Text(
                          textos[lang]!['tieneSeguro']!,
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<bool>(
                                title: Text(textos[lang]!['si']!),
                                value: true,
                                groupValue: tieneSeguro,
                                onChanged: (v) {
                                  setState(() {
                                    tieneSeguro = true;
                                    if (aseguradoras.isEmpty) {
                                      _cargarAseguradorasSiCorresponde();
                                    }
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<bool>(
                                title: Text(textos[lang]!['no']!),
                                value: false,
                                groupValue: tieneSeguro,
                                onChanged: (v) {
                                  setState(() {
                                    tieneSeguro = false;
                                    aseguradoraSeleccionadaId = null;
                                    polizaCtrl.clear();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),

                        if (tieneSeguro) ...[
                          const SizedBox(height: 8),
                          cargandoAseguradoras
                              ? const Center(child: CircularProgressIndicator())
                              : SizedBox(
                                  width: double.infinity,
                                  // isExpanded true avoids RenderFlex overflow inside InputDecorator
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    value: aseguradoraSeleccionadaId,
                                    items: aseguradoras.map((a) {
                                      final id = a['id']?.toString() ?? '';
                                      final label = a['Servicio']?.toString() ??
                                          a['servicio']?.toString() ??
                                          a['nombre']?.toString() ??
                                          a['Nombre']?.toString() ??
                                          '';
                                      return DropdownMenuItem<String>(
                                        value: id,
                                        child: Text(label,
                                            overflow: TextOverflow.ellipsis),
                                      );
                                    }).toList(),
                                    onChanged: (v) {
                                      setState(() {
                                        aseguradoraSeleccionadaId = v;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey.withOpacity(0.2),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 14),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide.none),
                                      hintText:
                                          textos[lang]!['eligeAseguradora'] ??
                                              '',
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            hintText: textos[lang]!['numeroPoliza'] ?? '',
                            controller: polizaCtrl,
                            leadingIconData:
                                const Icon(Icons.confirmation_number),
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ],

                        const SizedBox(height: 20),

                        // BOTÓN FINAL DE REGISTRO
                        CustomButton(
                          title: textos[lang]!['signup']!,
                          ontap: () {
                            if (_validarCampos()) {
                              _submitRegistro();
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
                        fontSize: 13,
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
