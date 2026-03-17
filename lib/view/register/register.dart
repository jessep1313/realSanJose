// lib/view/register/register.dart
import 'dart:io';
import 'dart:convert';
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
  XFile? documentoImagen;
  XFile? ineFrente;
  XFile? ineReverso;

  // Controladores (todos los campos solicitados)
  final paternoCtrl = TextEditingController();
  final maternoCtrl = TextEditingController();
  final nombreCtrl = TextEditingController();
  final fechaCtrl = TextEditingController(); // stores yyyy-MM-dd when selected
  String sexo = 'MASCULINO'; // default to Masculino
  final correoCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();
  final curpCtrl = TextEditingController();
  final rfcCtrl = TextEditingController();
  final pasaporteCtrl = TextEditingController();
  final calleCtrl = TextEditingController();
  final noExteriorCtrl = TextEditingController();
  final noInteriorCtrl = TextEditingController();
  final coloniaCtrl = TextEditingController();
  final ciudadCtrl = TextEditingController();
  final estadoCtrl = TextEditingController();
  final paisCtrl = TextEditingController(); // start empty
  final cpCtrl = TextEditingController();
  final nacionalidadCtrl = TextEditingController(); // start empty
  final passwordCtrl = TextEditingController();

  // Seguro (moved to end of form)
  bool tieneSeguro = false;
  List<Map<String, dynamic>> aseguradoras = [];
  String? aseguradoraSeleccionadaId;
  final polizaCtrl = TextEditingController();
  bool cargandoAseguradoras = false;

  // Nacionalidad y tipo de documento (no defaults)
  String nacionalidad = ''; // '' | 'Mexicano' | 'Extranjero'
  String tipoDocumento = ''; // '' | 'INE' | 'Pasaporte'

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _cargarAseguradorasSiCorresponde();
  }

  @override
  void dispose() {
    paternoCtrl.dispose();
    maternoCtrl.dispose();
    nombreCtrl.dispose();
    fechaCtrl.dispose();
    correoCtrl.dispose();
    telefonoCtrl.dispose();
    curpCtrl.dispose();
    rfcCtrl.dispose();
    pasaporteCtrl.dispose();
    calleCtrl.dispose();
    noExteriorCtrl.dispose();
    noInteriorCtrl.dispose();
    coloniaCtrl.dispose();
    ciudadCtrl.dispose();
    estadoCtrl.dispose();
    paisCtrl.dispose();
    cpCtrl.dispose();
    nacionalidadCtrl.dispose();
    passwordCtrl.dispose();
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

  // Funciones para cámara/galería (kept)
  Future<void> _pickIneFront() async {
    final archivo = await picker.pickImage(source: ImageSource.camera);
    if (archivo != null) {
      setState(() => ineFrente = archivo);
      await _procesarIne(File(archivo.path));
    }
  }

  Future<void> _pickIneBack() async {
    final archivo = await picker.pickImage(source: ImageSource.camera);
    if (archivo != null) setState(() => ineReverso = archivo);
  }

  Future<void> _pickPassportPhoto() async {
    final archivo = await picker.pickImage(source: ImageSource.camera);
    if (archivo != null) setState(() => documentoImagen = archivo);
  }

  // OCR (adapted)
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
      if (curpMatch != null) curpCtrl.text = curpMatch.group(0)!;

      final dateMatch =
          RegExp(r'(\d{2})[\/\-](\d{2})[\/\-](\d{2,4})').firstMatch(text);
      if (dateMatch != null) {
        final dd = dateMatch.group(1);
        final mm = dateMatch.group(2);
        final yyRaw = dateMatch.group(3)!;
        final yyyy = yyRaw.length == 2 ? '19$yyRaw' : yyRaw;
        // store as yyyy-MM-dd
        fechaCtrl.text = '$yyyy-${mm!.padLeft(2, '0')}-${dd!.padLeft(2, '0')}';
      }

      final nombreLabelMatch =
          RegExp(r'NOMBRE[S]?:\s*([A-ZÁÉÍÓÚÑ\s]+)').firstMatch(text);
      if (nombreLabelMatch != null) {
        final full = nombreLabelMatch.group(1)!.trim();
        final parts = full.split(RegExp(r'\s+'));
        if (parts.length >= 2) {
          nombreCtrl.text = parts.last;
          paternoCtrl.text = parts.first;
          if (parts.length > 2) {
            maternoCtrl.text = parts.sublist(1, parts.length - 1).join(' ');
          }
        } else {
          nombreCtrl.text = full;
        }
      }

      final domMatch =
          RegExp(r'DOMICILIO[:\s]*([A-Z0-9ÁÉÍÓÚÑ\.,#\-\s]+)').firstMatch(text);
      if (domMatch != null && calleCtrl.text.trim().isEmpty) {
        calleCtrl.text = domMatch.group(1)!.trim();
      }

      final municipioMatch =
          RegExp(r'MUNICIPIO[:\s]*([A-ZÁÉÍÓÚÑ\s]+)').firstMatch(text);
      if (municipioMatch != null && ciudadCtrl.text.trim().isEmpty) {
        ciudadCtrl.text = municipioMatch.group(1)!.trim();
      }

      final estadoMatch =
          RegExp(r'(ENTIDAD|ESTADO)[:\s]*([A-ZÁÉÍÓÚÑ\s]+)').firstMatch(text);
      if (estadoMatch != null && estadoCtrl.text.trim().isEmpty) {
        if (estadoMatch.groupCount >= 2 && estadoMatch.group(2) != null) {
          estadoCtrl.text = estadoMatch.group(2)!.trim();
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
    final apellidos =
        (paternoCtrl.text + ' ' + maternoCtrl.text).trim().toUpperCase();

    if (nombre.isEmpty || apellidos.isEmpty) return false;
    if (fechaCtrl.text.trim().isEmpty) return false;

    final partes = fechaCtrl.text.split('-');
    if (partes.length != 3) return false;

    final yyyy = partes[0];
    final mm = partes[1];
    final dd = partes[2];
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
    } else if (paternoCtrl.text.trim().isEmpty) {
      error = 'Apellido paterno es obligatorio';
    } else if (fechaCtrl.text.trim().isEmpty) {
      error = 'Fecha de nacimiento es obligatoria';
    } else if (sexo.trim().isEmpty) {
      error = 'Sexo es obligatorio';
    } else if (correoCtrl.text.trim().isEmpty ||
        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(correoCtrl.text.trim())) {
      error = 'Correo inválido';
    } else if (telefonoCtrl.text.trim().isEmpty) {
      error = 'Teléfono es obligatorio';
    } else if (curpCtrl.text.trim().isEmpty ||
        !RegExp(r'^[A-Z]{4}\d{6}[HM][A-Z]{5}\d{2}$')
            .hasMatch(curpCtrl.text.toUpperCase())) {
      error = 'CURP inválida';
    } else if (nacionalidad == 'Mexicano' &&
        (rfcCtrl.text.trim().isEmpty ||
            !RegExp(r'^[A-ZÑ&]{3,4}\d{6}[A-Z0-9]{3}$')
                .hasMatch(rfcCtrl.text.toUpperCase()))) {
      error = 'RFC inválido';
    } else if (tipoDocumento == 'Pasaporte' &&
        pasaporteCtrl.text.trim().isEmpty) {
      error = 'Número de pasaporte es obligatorio';
    } else if (calleCtrl.text.trim().isEmpty) {
      error = 'Calle es obligatoria';
    } else if (noExteriorCtrl.text.trim().isEmpty) {
      error = 'Número exterior es obligatorio';
    } else if (coloniaCtrl.text.trim().isEmpty) {
      error = 'Colonia es obligatoria';
    } else if (ciudadCtrl.text.trim().isEmpty) {
      error = 'Ciudad es obligatoria';
    } else if (estadoCtrl.text.trim().isEmpty) {
      error = 'Estado es obligatorio';
    } else if (paisCtrl.text.trim().isEmpty) {
      error = 'País es obligatorio';
    } else if (cpCtrl.text.trim().isEmpty ||
        !RegExp(r'^\d{5}$').hasMatch(cpCtrl.text.trim())) {
      error = 'Código Postal inválido';
    } else if (passwordCtrl.text.trim().isEmpty ||
        passwordCtrl.text.trim().length < 6) {
      error = 'Password es obligatorio (mínimo 6 caracteres)';
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return false;
    }
    return true;
  }

  Map<String, dynamic> buildRegisterPayload() {
    // FechaCtrl is stored as yyyy-MM-dd when selected via date picker.
    String fechaEnvio = fechaCtrl.text.trim();
    // If it's already yyyy-MM-dd, append T00:00:00
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(fechaEnvio)) {
      fechaEnvio = '${fechaEnvio}T00:00:00';
    } else {
      // fallback: try to parse dd/mm/yyyy
      final parts = fechaEnvio.split('/');
      if (parts.length == 3) {
        final dd = parts[0].padLeft(2, '0');
        final mm = parts[1].padLeft(2, '0');
        final yyyy = parts[2].length == 2 ? '19${parts[2]}' : parts[2];
        fechaEnvio = '$yyyy-$mm-${dd}T00:00:00';
      } else {
        // leave as-is
      }
    }

    final Map<String, dynamic> payload = <String, dynamic>{
      'Paterno': paternoCtrl.text.trim(),
      'Materno': maternoCtrl.text.trim(),
      'Nombre': nombreCtrl.text.trim(),
      'FechaNacimiento': fechaEnvio,
      'Sexo': sexo,
      'Correo': correoCtrl.text.trim(),
      'Telefono': telefonoCtrl.text.trim(),
      'Curp': curpCtrl.text.trim(),
      'Rfc': rfcCtrl.text.trim(),
      'Pasaporte': pasaporteCtrl.text.trim(),
      'Calle': calleCtrl.text.trim(),
      'NoExterior': noExteriorCtrl.text.trim(),
      'NoInterior': noInteriorCtrl.text.trim(),
      'Colonia': coloniaCtrl.text.trim(),
      'Ciudad': ciudadCtrl.text.trim(),
      'Estado': estadoCtrl.text.trim(),
      'Pais': paisCtrl.text.trim(),
      'CodigoPostal': cpCtrl.text.trim(),
      'Nacionalidad': nacionalidadCtrl.text.trim(),
      'Password': passwordCtrl.text.trim(),
      // Seguro fields are included but the UI places the block at the end
      'TieneSeguro': tieneSeguro,
      'AseguradoraId': aseguradoraSeleccionadaId,
      'NumeroPoliza': polizaCtrl.text.trim(),
    };

    return payload;
  }

  Future<void> _submitRegistro() async {
    if (!_validarCampos()) return;

    setState(() => isSubmitting = true);
    final payload = buildRegisterPayload();
    debugPrint('Payload registro: ${jsonEncode(payload)}');

    try {
      final service = AuthService();
      final resp = await service.register(payload);

      if (resp['success'] == true) {
        final message = resp['message'] ?? 'Registro exitoso';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        // No borrar formulario. Navegar opcionalmente.
        Future.delayed(const Duration(milliseconds: 800), () {
          context.go(DashboardScreen.routeName);
        });
      } else {
        final serverMsg = resp['message'] ?? 'Error en registro';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(serverMsg)));
      }
    } catch (e) {
      debugPrint('Error en registro: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  // Date picker helper: shows calendar and stores yyyy-MM-dd in fechaCtrl
  Future<void> _selectFechaNacimiento() async {
    final now = DateTime.now();
    final initial = DateTime(now.year - 25, now.month, now.day);
    final first = DateTime(1900);
    final last = DateTime(now.year, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      initialEntryMode: DatePickerEntryMode.calendar,
      helpText: 'Selecciona fecha de nacimiento',
      builder: (BuildContext context, Widget? child) {
        // Force a light dialog background and ensure the calendar is visible (avoids transparent dialog)
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: const Color(0xFF003DA5),
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      final yyyy = picked.year.toString().padLeft(4, '0');
      final mm = picked.month.toString().padLeft(2, '0');
      final dd = picked.day.toString().padLeft(2, '0');
      // store as yyyy-MM-dd (display and later converted to ISO with T00:00:00)
      setState(() {
        fechaCtrl.text = '$yyyy-$mm-$dd';
      });
    }
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
        'paterno': 'Apellido paterno',
        'materno': 'Apellido materno',
        'nombre': 'Nombre(s)',
        'fecha': 'Fecha de nacimiento (YYYY-MM-DD)',
        'sexo': 'Sexo',
        'correo': 'Correo',
        'telefono': 'Teléfono',
        'curp': 'CURP',
        'rfc': 'RFC',
        'pasaporte': 'Número de pasaporte',
        'calle': 'Calle',
        'noExterior': 'No. Exterior',
        'noInterior': 'No. Interior',
        'colonia': 'Colonia',
        'ciudad': 'Ciudad',
        'estado': 'Estado',
        'pais': 'País',
        'cp': 'Código Postal',
        'nacionalidadField': 'Nacionalidad',
        'password': 'Password',
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
        'paterno': 'Last name (paternal)',
        'materno': 'Last name (maternal)',
        'nombre': 'First name(s)',
        'fecha': 'Date of Birth (YYYY-MM-DD)',
        'sexo': 'Sex',
        'correo': 'Email',
        'telefono': 'Phone',
        'curp': 'CURP',
        'rfc': 'RFC',
        'pasaporte': 'Passport number',
        'calle': 'Street',
        'noExterior': 'Exterior No.',
        'noInterior': 'Interior No.',
        'colonia': 'Neighborhood',
        'ciudad': 'City',
        'estado': 'State',
        'pais': 'Country',
        'cp': 'Postal Code',
        'nacionalidadField': 'Nationality',
        'password': 'Password',
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Image.asset('assets/icons/logo.jpg',
                                height: 90)),
                        const SizedBox(height: 12),
                        Center(
                            child: Text(textos[lang]!['titulo']!,
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold))),
                        const SizedBox(height: 18),

                        // Nacionalidad selector (no default)
                        Text(textos[lang]!['nacionalidad']!,
                            style: const TextStyle(fontSize: 15)),
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
                                  nacionalidadCtrl.text = 'MEXICANA';
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
                                  nacionalidadCtrl.text = '';
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

                        // Tipo de documento (visibilidad dependiente)
                        Text(textos[lang]!['tipo']!,
                            style: const TextStyle(fontSize: 15)),
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

                        // INE / Pasaporte photo block (kept)
                        if (tipoDocumento == 'INE') ...[
                          Text(textos[lang]!['fotografiasINE']!,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
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
                                          color: Color(0xFF003DA5), width: 2)),
                                  onPressed: _pickIneFront,
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
                                          color: Color(0xFF003DA5), width: 2)),
                                  onPressed: _pickIneBack,
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
                                    child: Image.file(File(ineFrente!.path),
                                        height: 180, fit: BoxFit.cover)),
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
                                    child: Image.file(File(ineReverso!.path),
                                        height: 180, fit: BoxFit.cover)),
                              ],
                            ),
                          const SizedBox(height: 20),
                        ] else if (tipoDocumento == 'Pasaporte') ...[
                          Text(textos[lang]!['fotografiaPasaporte']!,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.camera_alt),
                            label: Text(textos[lang]!['camera']!),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(
                                    color: Color(0xFF003DA5), width: 2)),
                            onPressed: _pickPassportPhoto,
                          ),
                          if (documentoImagen != null)
                            Container(
                                margin: const EdgeInsets.only(top: 15),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Image.file(File(documentoImagen!.path),
                                    height: 200, fit: BoxFit.cover)),
                          const SizedBox(height: 20),
                        ],

                        // DATOS PERSONALES (orden)
                        CustomTextField(
                            hintText: textos[lang]!['paterno']!,
                            controller: paternoCtrl,
                            leadingIconData: const Icon(Icons.person),
                            color: Colors.grey.withOpacity(0.2)),
                        CustomTextField(
                            hintText: textos[lang]!['materno']!,
                            controller: maternoCtrl,
                            leadingIconData: const Icon(Icons.person),
                            color: Colors.grey.withOpacity(0.2)),
                        CustomTextField(
                            hintText: textos[lang]!['nombre']!,
                            controller: nombreCtrl,
                            leadingIconData: const Icon(Icons.person_outline),
                            color: Colors.grey.withOpacity(0.2)),

                        // Fecha: readOnly, opens date picker, stores yyyy-MM-dd
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _selectFechaNacimiento,
                          child: AbsorbPointer(
                            child: CustomTextField(
                              hintText: textos[lang]!['fecha']!,
                              controller: fechaCtrl,
                              leadingIconData: const Icon(Icons.cake),
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),
                        // Sexo selector: only Masculino / Femenino
                        InputDecorator(
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.2),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: sexo,
                              isExpanded: true,
                              items: ['MASCULINO', 'FEMENINO']
                                  .map((s) => DropdownMenuItem(
                                      value: s, child: Text(s)))
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) setState(() => sexo = v);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        CustomTextField(
                            hintText: textos[lang]!['correo']!,
                            controller: correoCtrl,
                            leadingIconData: const Icon(Icons.email),
                            color: Colors.grey.withOpacity(0.2)),
                        CustomTextField(
                            hintText: textos[lang]!['telefono']!,
                            controller: telefonoCtrl,
                            leadingIconData: const Icon(Icons.phone),
                            color: Colors.grey.withOpacity(0.2)),

                        // CURP
                        CustomTextField(
                            hintText: textos[lang]!['curp']!,
                            controller: curpCtrl,
                            leadingIconData: const Icon(Icons.assignment_ind),
                            color: Colors.grey.withOpacity(0.2)),

                        const SizedBox(height: 12),

                        // RFC only if Mexican
                        if (nacionalidad == 'Mexicano') ...[
                          CustomTextField(
                              hintText: textos[lang]!['rfc']!,
                              controller: rfcCtrl,
                              leadingIconData: const Icon(Icons.credit_card),
                              color: Colors.grey.withOpacity(0.2)),
                        ],

                        // Pasaporte only if Pasaporte selected
                        if (tipoDocumento == 'Pasaporte') ...[
                          CustomTextField(
                              hintText: textos[lang]!['pasaporte']!,
                              controller: pasaporteCtrl,
                              leadingIconData: const Icon(Icons.badge),
                              color: Colors.grey.withOpacity(0.2)),
                        ],

                        // Domicilio
                        CustomTextField(
                            hintText: textos[lang]!['calle']!,
                            controller: calleCtrl,
                            leadingIconData: const Icon(Icons.home),
                            color: Colors.grey.withOpacity(0.2)),
                        CustomTextField(
                            hintText: textos[lang]!['noExterior']!,
                            controller: noExteriorCtrl,
                            leadingIconData:
                                const Icon(Icons.format_list_numbered),
                            color: Colors.grey.withOpacity(0.2)),
                        CustomTextField(
                            hintText: textos[lang]!['noInterior']!,
                            controller: noInteriorCtrl,
                            leadingIconData:
                                const Icon(Icons.format_list_numbered_rtl),
                            color: Colors.grey.withOpacity(0.2)),
                        CustomTextField(
                            hintText: textos[lang]!['colonia']!,
                            controller: coloniaCtrl,
                            leadingIconData: const Icon(Icons.location_on),
                            color: Colors.grey.withOpacity(0.2)),
                        CustomTextField(
                            hintText: textos[lang]!['ciudad']!,
                            controller: ciudadCtrl,
                            leadingIconData: const Icon(Icons.location_city),
                            color: Colors.grey.withOpacity(0.2)),
                        CustomTextField(
                            hintText: textos[lang]!['estado']!,
                            controller: estadoCtrl,
                            leadingIconData: const Icon(Icons.map),
                            color: Colors.grey.withOpacity(0.2)),
                        CustomTextField(
                            hintText: textos[lang]!['pais']!,
                            controller: paisCtrl,
                            leadingIconData: const Icon(Icons.public),
                            color: Colors.grey.withOpacity(0.2)),
                        CustomTextField(
                            hintText: textos[lang]!['cp']!,
                            controller: cpCtrl,
                            leadingIconData:
                                const Icon(Icons.markunread_mailbox),
                            color: Colors.grey.withOpacity(0.2)),

                        // Nacionalidad / Password
                        CustomTextField(
                            hintText: textos[lang]!['nacionalidadField']!,
                            controller: nacionalidadCtrl,
                            leadingIconData: const Icon(Icons.flag),
                            color: Colors.grey.withOpacity(0.2)),
                        CustomTextField(
                            hintText: textos[lang]!['password']!,
                            controller: passwordCtrl,
                            leadingIconData: const Icon(Icons.lock),
                            isPassword: true,
                            color: Colors.grey.withOpacity(0.2)),

                        const SizedBox(height: 16),

                        // BLOQUE: Seguro (moved to end, after password)
                        Text(textos[lang]!['tieneSeguro']!,
                            style: const TextStyle(fontSize: 15)),
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
                                  if (aseguradoras.isEmpty)
                                    _cargarAseguradorasSiCorresponde();
                                });
                              },
                            )),
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
                            )),
                          ],
                        ),

                        if (tieneSeguro) ...[
                          const SizedBox(height: 8),
                          cargandoAseguradoras
                              ? const Center(child: CircularProgressIndicator())
                              : SizedBox(
                                  width: double.infinity,
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
                                              overflow: TextOverflow.ellipsis));
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
                                                ''),
                                  ),
                                ),
                          const SizedBox(height: 12),
                          CustomTextField(
                              hintText: textos[lang]!['numeroPoliza'] ?? '',
                              controller: polizaCtrl,
                              leadingIconData:
                                  const Icon(Icons.confirmation_number),
                              color: Colors.grey.withOpacity(0.2)),
                        ],

                        const SizedBox(height: 20),

                        // BOTÓN FINAL DE REGISTRO
                        CustomButton(
                          title: isSubmitting
                              ? (lang == 'es' ? 'Enviando...' : 'Sending...')
                              : textos[lang]!['signup']!,
                          ontap: isSubmitting ? null : () => _submitRegistro(),
                          color: const Color(0xFF003DA5),
                          textColor: Colors.white,
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(textos[lang]!['login']!,
                      style: const TextStyle(color: Colors.white)),
                  GestureDetector(
                      onTap: () => context.push(LoginScreen.routeName),
                      child: Text(' ${textos[lang]!['backLogin']!}',
                          style: const TextStyle(color: Colors.white))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
