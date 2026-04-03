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
  bool aceptaTerminos = false;

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
      final lines = raw
          .split('\n')
          .map((e) => e.trim().toUpperCase())
          .where((e) => e.isNotEmpty)
          .toList();

      print("=== OCR LÍNEAS DETECTADAS ===");
      for (var l in lines) print(l);

      // ---------------------------------------------------------
      // ⭐ 1. DETECTAR BLOQUE DE NOMBRE
      // ---------------------------------------------------------
      int idxNombre = lines.indexWhere((l) => l.contains("NOMBRE"));
      if (idxNombre != -1) {
        // Las siguientes líneas contienen:
        // PATERNO / MATERNO / NOMBRE(S)
        if (idxNombre + 1 < lines.length)
          paternoCtrl.text = lines[idxNombre + 1];
        if (idxNombre + 2 < lines.length)
          maternoCtrl.text = lines[idxNombre + 2];
        if (idxNombre + 3 < lines.length)
          nombreCtrl.text = lines[idxNombre + 3];
      }

      // ---------------------------------------------------------
      // ⭐ 2. DETECTAR CURP
      // ---------------------------------------------------------
      int idxCurp = lines.indexWhere((l) => l.contains("CURP"));
      if (idxCurp != -1 && idxCurp + 1 < lines.length) {
        final posibleCurp = lines[idxCurp + 1];
        final match =
            RegExp(r'[A-Z]{4}\d{6}[HM][A-Z]{5}\d{2}').firstMatch(posibleCurp);
        if (match != null) curpCtrl.text = match.group(0)!;
      }

      // ---------------------------------------------------------
      // ⭐ 3. DETECTAR FECHA DE NACIMIENTO
      // ---------------------------------------------------------
      int idxFecha = lines.indexWhere((l) => l.contains("FECHA"));
      if (idxFecha != -1 && idxFecha + 1 < lines.length) {
        final fechaRaw = lines[idxFecha + 1];
        final match =
            RegExp(r'(\d{2})[\/\-](\d{2})[\/\-](\d{4})').firstMatch(fechaRaw);

        if (match != null) {
          final dd = match.group(1)!;
          final mm = match.group(2)!;
          final yyyy = match.group(3)!;

          fechaCtrl.text = "$yyyy-$mm-$dd"; // ⭐ FORMATO CORRECTO
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
    // ⭐ Necesitamos el idioma actual
    final lang = ref.read(languageProvider);

    // ⭐ Accedemos al mapa de textos que ya tienes en build()
    final textos = {
      'es': {
        'alertaTerminos':
            'Debes aceptar los Términos y Condiciones y el Aviso de Privacidad',
      },
      'en': {
        'alertaTerminos':
            'You must accept the Terms and Conditions and the Privacy Notice',
      }
    };

    // ⭐ VALIDACIÓN DEL CHECKBOX (OBLIGATORIO)
    if (!aceptaTerminos) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(textos[lang]!['alertaTerminos']!)),
      );
      return;
    }

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

  void showLegalModal(String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          minChildSize: 0.50,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003DA5),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Text(
                        content,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
        'acepto': 'Acepto los',
        'terminos': 'Términos y Condiciones',
        'aviso': 'Aviso de Privacidad',
        'alertaTerminos':
            'Debes aceptar los Términos y Condiciones y el Aviso de Privacidad',
        'terminosText': '''
        El presente documento establece los términos y las condiciones mediante las cuales se regirá el uso de la aplicación móvil, operada por Hospital Real San José S.C.

        El usuario se compromete a leer los términos y condiciones aquí establecidas, previamente a su registro en la aplicación. En caso de instalarla, se entiende que acepta la totalidad de lo estipulado.

        El Usuario reconoce que la información personal que brinda a la aplicación es legal, real y verídica.

        USO Y ALCANCES

        El usuario entiende y acepta que, aunque la app es operada por Hospital Real San José S.C., la información contenida podrá ser referida por un tercero, limitándose a la relación médico‑paciente.

        La app permitirá visualizar información del usuario y realizar transacciones habilitadas según su perfil. El administrador podrá modificar funcionalidades sin previo aviso.

        Los tiempos de respuesta y solicitudes serán procesados conforme a las especificaciones de cada movimiento.

        El usuario acepta que los registros electrónicos constituyen prueba plena.

        REQUISITOS DE USO

        El usuario declara ser mayor de edad y contar con un dispositivo móvil seguro. Hospital Real San José S.C. no es responsable por la seguridad del dispositivo ni garantiza funcionamiento en todos los sistemas operativos.

        OBLIGACIONES DEL USUARIO

        El usuario se compromete a NO:
        a) Usar la app con fines ilícitos.
        b) Reproducir o distribuir contenidos sin autorización.
        c) Realizar acciones que dañen la app.
        d) Manipular derechos de autor.
        e) Usar información para fines comerciales o envío masivo.
        f) Permitir acceso a terceros con su clave.
        g) Realizar acciones que afecten derechos de terceros o el funcionamiento de la app.

        PROPIEDAD INTELECTUAL

        Todos los contenidos están protegidos por derechos de autor. Queda prohibida su reproducción sin autorización.

        USO DE INFORMACIÓN Y PRIVACIDAD

        El usuario autoriza el tratamiento de sus datos como paciente, conforme a la legislación vigente.

        LÍMITE DE RESPONSABILIDAD

        Hospital Real San José S.C. no será responsable por:
        a) Pérdida o robo del dispositivo.
        b) Pérdida de información por fuerza mayor.
        c) Errores del usuario.
        d) Fallas del operador móvil.
        e) Fallas de la app por fuerza mayor.

        SUSPENSIÓN

        Hospital Real San José S.C. podrá suspender el acceso por incumplimiento.

        ACEPTACIÓN

        El usuario acepta haber leído y entendido estos términos. Su uso continuo implica aceptación de modificaciones.

        JURISDICCIÓN

        Se rige por las leyes de los Estados Unidos Mexicanos.
        ''',
        'avisoText': '''AVISO DE PRIVACIDAD
HOSPITAL REAL SAN JOSE S C, con domicilio para oír y recibir notificaciones en Av. Lázaro
Cárdenas No 4149 Colonia Jardines de san Ignacio, teléfono 331078-8900 código postal
45040 en el municipio de Zapopan., Jalisco, México, es responsable de recabar sus datos
personales, del uso que se le dé a los mismos y de su protección.
Su información será utilizada con fines de trazabilidad, identificación y registro del uso de la
aplicación con fines meramente informativos para pacientes, el cual es producto de la atención
médica que se le otorgó o se planea otorgar al paciente en los Hospitales Real San José, y
por medio de la cual usted podrá dar seguimiento a los mismos.
Para la finalidad antes mencionada, requerimos obtener sus datos personales y datos
personales sensibles proporcionados directamente por usted o por un tercero autorizado como
lo son de manera enunciativa mas no limitativamente: creencias religiosas, los datos médicos
que son todos los relativos a la salud de un individuo los cuales están incluidos en el
expediente clínico conformado según la NOM-004SSA3-2012 por, Historia clínica, Notas de
evolución, Notas de Interconsulta, Notas de referencia y traslado, Nota de alta médica o
voluntaria , resultados previos y actuales de estudios de laboratorio, gabinete y otras, la
terapéutica empleada y resultados obtenidos, el diagnóstico o problemas clínicos anteriores y
actuales. Los datos personales considerados como sensibles según la Ley Federal de
Protección de Datos Personales en Posesión de los Particulares son todos los relativos a
identificar a la persona (nombre, contraseña, fotos, entre otros), los cuales serán guardados
bajo la más estricta confidencialidad y no se les podrá dar un uso distinto a los antes
mencionados, salvo que medie un cambio en este Aviso de Privacidad. Para la recolección de
datos personales, seguimos todos los principios que marca la Ley como la licitud, calidad,
consentimiento, información, finalidad, lealtad, proporcionalidad y responsabilidad.
Asimismo, le informamos que sus datos personales pueden ser transferidos y tratados dentro
y fuera del país, por personas distintas a esta empresa. En ese sentido, su información puede
ser compartida con persona o familiar autorizada por usted, o por autoridades judiciales
(siempre y cuando exista una orden judicial), para razones científicas, estadísticas o de interés
general señaladas por ley.
Una vez que se cumpla la finalidad del tratamiento de datos personales, éstos serán
bloqueados con el único propósito de determinar posibles responsabilidades en relación con
su tratamiento, hasta el plazo de prescripción legal o contractual de éstas. Durante dicho
periodo, los datos personales no podrán ser objeto de tratamiento y transcurrido éste, se
procederá a su cancelación en la base de datos que corresponde. Si usted no manifiesta su
oposición para que sus datos personales sean transferidos, se entenderá que ha otorgado su
consentimiento para ello.
Usted tiene derecho de acceder, rectificar y cancelar sus datos personales, así como de
oponerse al tratamiento de los mismos o revocar el consentimiento que para tal fin nos haya
otorgado, a través de los procedimientos que hemos implementado:
Para accionar dichos procedimientos favor de presentar una solicitud por escrito (solicitud de
ejercicio de Derechos ARCO) dirigida a Dirección Administrativa y que contenga la siguiente
información:
 Nombre del titular
 Domicilio del titular o dirección electrónica para comunicar respuesta de solicitud

 Documentos que acrediten la Identidad o autorización para representarlo en la
solicitud.
 Descripción de datos personales sobre los que se pretende ejercer algún derecho
ARCO.
 Cualquier otra elemento que permita la localización de los datos personales y/o
atención a la solicitud.
 Firma autógrafa del titular.
La presentación del documento se deberá hacer en la siguiente dirección: en Av. Lázaro
Cárdenas No. 4149 Colonia Jardines de san Ignacio teléfono 331078-8900 código postal
45040 en el municipio de Zapopan., Jalisco, México con Lic. Carolina Luna Medel de lunes a
viernes de 09:00 a 17:00 hrs. Se estipula un plazo de 15 días para la contestación de su
solicitud, cualquier duda o comentario puede usted ponerse en contacto con nuestro
departamento de datos personales.

Autorizo el uso de mi información.

______________________________________
Nombre y firma

Nos reservamos el derecho de cambiar este Aviso de Privacidad en cualquier momento.

No seremos responsables si usted no recibe la notificación de cambio en el Aviso de
Privacidad si existiere algún problema con su cuenta de correo electrónico o de transmisión de
datos por Internet.

INFORMACIÓN GENERAL SOBRE LA PRIVACIDAD DE LA INFORMACIÓN

¿Qué son los datos personales?
Es cualquier información relacionada usted, por ejemplo, su nombre, teléfono, domicilio,
fotografía o huellas dactilares, así como cualquier dato para su identificación.
¿Cuáles son los datos personales sensibles?
Son los datos que, de divulgarse de manera indebida, afectarían la esfera más íntima del ser
humano; por ejemplo: origen, estado de salud, información genética, preferencias sexuales,
creencias religiosas, filosóficas, morales, afiliación sindical, opinión política entre otros.

¿Cómo garantizamos la protección de sus datos?
 Nombrando un responsable que atienda sus solicitudes de acceso, rectificación,
cancelación y oposición de sus datos personales.
 Contando con las medidas de seguridad necesarias para garantizar sus datos contra
el uso indebido o ilícito, acceso no autorizado, o contra la pérdida, alteración, robo o
modificación de su información personal.
 Capacitando al personal.
 Informándole sobre el uso que dará a tu información.
¿Qué y cuáles son los principios rectores de la protección de datos personales?
Son una serie de reglas mínimas que se deben observar los entes privados que tratan datos
personales (personas físicas o morales), garantizando el uso adecuado de la información
personal. Estos principios son:
Principio de Licitud: Se refiere al compromiso que deben asumir los entes privados (personas
físicas o morales) que traten su información cuando se solicita la prestación de un servicio,
respetando en todo momento la confianza que se otorga a éstos para el buen uso que le
darán a los datos.
Principio de Consentimiento: Para los entes privados a las que se otorgue la información,
implica el deber de solicitar autorización expresa y por escrito para que se pueda tratar la
información.
Principio de Calidad: Se refiere a que los datos personales en posesión de particulares
deberán estar actualizados ser verídicos; que se utilicen para dar cumplimiento a los fines que
justificaron su tratamiento.

Principio de Información: Se refiere al derecho que le otorga la Ley de conocer las
características principales del tratamiento de sus datos personales previo a compartirlos; y
esto se encuentra contenido en el “Aviso de Privacidad”.
Principio de Proporcionalidad: Las empresas sólo podrán recabar los datos estrictamente
necesarios e indispensables para cumplir el objetivo.
Principio de Responsabilidad: Los entes privados (ya sean personas físicas o morales) y
quienes los conforman, que manejan datos personales, deben asegurar que ya sea dentro o
fuera de nuestro país, se cumpla con los principios esenciales de protección de datos
personales, comprometiéndose a velar siempre por el cumplimiento de estos principios y a
rendir cuentas en caso de incumplimiento.

¿Cuáles son los Derechos ARCO?
Acceso, Rectificación, Cancelación y Oposición
Derecho de Acceso:

Es el derecho que le otorga la ley de solicitar al ente privado que le informe si en su base de
datos existe alguno de tus datos personales.
Derecho de Rectificación:
Es el derecho que te otorga la Ley a que se corrijan sus datos personales en la base de datos
de los entes privados que los contengan; esto aplica cuando los datos son incorrectos,
imprecisos, incompletos o no están actualizados.
Derecho de Cancelación:
Es el derecho que le otorga la Ley para que solicite la cancelación de sus datos de las bases
de algún ente privado; y por ende éstos deberán ser bloqueados y, posteriormente, suprimidos
de las bases de datos. Sólo es procedente cuando la información personal ya no es necesaria
para las actividades relacionadas con el ente privado que los tiene en sus bases.
Derecho de Oposición:
Es le derecho que le otorga la Ley para solicitar a el ente privado que proyecte realizar el
tratamiento de tus datos personales que se abstenga de hacerlo en determinadas situaciones.''',
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
        'acepto': 'I accept the',
        'terminos': 'Terms and Conditions',
        'aviso': 'Privacy Notice',
        'alertaTerminos':
            'You must accept the Terms and Conditions and the Privacy Notice',
        'terminosText': '''
          This document establishes the terms and conditions governing the use of the mobile application operated by Hospital Real San José S.C.

          By installing the app, the user acknowledges having read and accepted all terms and conditions.

          The user confirms that all personal and clinical information provided is truthful and accurate.

          USE AND SCOPE

          Although the app is operated by Hospital Real San José S.C., certain information may be managed by third parties, limited to the doctor‑patient relationship.

          The app allows users to view their information and perform transactions enabled according to their profile. Functionalities may be modified without prior notice.

          Electronic records constitute full legal evidence.

          REQUIREMENTS

          Users must be of legal age and use a secure mobile device. Hospital Real San José S.C. is not responsible for device security nor guarantees compatibility with all operating systems.

          USER OBLIGATIONS

          Users must NOT:
          a) Use the app for unlawful purposes.
          b) Reproduce or distribute content without authorization.
          c) Damage or overload the app.
          d) Manipulate copyright.
          e) Use information for commercial or mass‑messaging purposes.
          f) Allow third‑party access with their credentials.
          g) Perform actions that affect third parties or the app’s operation.

          INTELLECTUAL PROPERTY

          All content is protected by copyright. Reproduction is prohibited without authorization.

          PRIVACY AND DATA USE

          Users authorize the processing of their data as patients, in accordance with applicable law.

          LIMITATION OF LIABILITY

          Hospital Real San José S.C. is not responsible for:
          a) Loss or theft of the device.
          b) Loss of information due to force majeure.
          c) User errors.
          d) Mobile operator failures.
          e) App failures due to force majeure.

          SUSPENSION

          Access may be suspended for violations of these terms.

          ACCEPTANCE

          Continued use of the app constitutes acceptance of any modifications.

          JURISDICTION

          Governed by the laws of the United Mexican States.
          ''',
        'avisoText': '''PRIVACY NOTICE

HOSPITAL REAL SAN JOSE S.C., with address to hear and receive notifications at 
Av. Lázaro Cárdenas No. 4149, Jardines de San Ignacio, telephone 331078-8900, 
postal code 45040, in the municipality of Zapopan, Jalisco, Mexico, is responsible 
for collecting your personal data, the use given to such data, and its protection.

Your information will be used for traceability, identification, and registration 
purposes related to the use of the application, which is intended solely for 
informational purposes for patients. This information is derived from the medical 
care that has been provided or is planned to be provided to the patient at 
Hospitales Real San José, and through which you will be able to follow up on such 
information.

For the aforementioned purpose, we require obtaining your personal data and 
sensitive personal data provided directly by you or by an authorized third party, 
including but not limited to: religious beliefs, medical data (all information 
related to an individual's health), which are included in the clinical record 
according to NOM-004SSA3-2012, such as: clinical history, progress notes, 
interconsultation notes, referral and transfer notes, medical or voluntary 
discharge notes, previous and current laboratory and imaging results, therapeutic 
treatments and outcomes, and previous and current diagnoses or clinical problems.

Personal data considered sensitive under the Federal Law on Protection of Personal 
Data Held by Private Parties includes all information used to identify a person 
(name, password, photographs, among others). Such data will be kept under strict 
confidentiality and cannot be used for purposes other than those mentioned above, 
unless changes are made to this Privacy Notice. For the collection of personal 
data, we follow all principles established by law, such as legality, quality, 
consent, information, purpose, loyalty, proportionality, and responsibility.

We also inform you that your personal data may be transferred and processed inside 
and outside the country by persons other than this company. In this regard, your 
information may be shared with an authorized person or family member, or with 
judicial authorities (only when a court order exists), for scientific, statistical, 
or legally established public interest reasons.

Once the purpose of processing your personal data has been fulfilled, such data 
will be blocked solely to determine possible responsibilities related to its 
processing, until the legal or contractual statute of limitations expires. During 
this period, personal data cannot be processed, and once the period ends, the data 
will be deleted from the corresponding database. If you do not express opposition 
to the transfer of your personal data, it will be understood that you have given 
your consent.

You have the right to access, rectify, and cancel your personal data, as well as 
to oppose its processing or revoke the consent previously granted, through the 
procedures we have implemented.

To exercise these procedures, please submit a written request (ARCO Rights 
Request) addressed to the Administrative Directorate, containing the following 
information:

• Name of the data owner  
• Address or email address to receive a response  
• Documents proving identity or authorization to act on behalf of the owner  
• Description of the personal data for which ARCO rights are being exercised  
• Any other element that facilitates locating the personal data  
• Signature of the data owner  

The request must be submitted at the following address:  
Av. Lázaro Cárdenas No. 4149, Jardines de San Ignacio, telephone 331078-8900, 
postal code 45040, Zapopan, Jalisco, Mexico, with Lic. Carolina Luna Medel, 
Monday to Friday from 09:00 to 17:00 hrs. A response will be provided within 15 
days. For any questions or comments, you may contact our personal data department.

I authorize the use of my information.

______________________________________  
Name and signature

We reserve the right to modify this Privacy Notice at any time.

We will not be responsible if you do not receive notification of changes to the 
Privacy Notice due to issues with your email account or internet transmission.

GENERAL INFORMATION ABOUT DATA PRIVACY

What are personal data?  
Any information related to you, such as your name, phone number, address, 
photograph, fingerprints, or any data used for identification.

What are sensitive personal data?  
Data that, if improperly disclosed, could affect the most intimate sphere of a 
person, such as: origin, health status, genetic information, sexual preferences, 
religious, philosophical, or moral beliefs, union affiliation, political opinions, 
among others.

How do we guarantee the protection of your data?  
• Appointing a responsible person to handle ARCO requests  
• Implementing security measures to protect your data from misuse, unauthorized 
  access, loss, alteration, theft, or modification  
• Training personnel  
• Informing you about how your information will be used  

What are the guiding principles of personal data protection?  
These are minimum rules that private entities must follow when handling personal 
data, ensuring proper use of personal information. These principles are:

Principle of Legality:  
Private entities must respect the trust granted to them when requesting a service 
and ensure proper use of the data.

Principle of Consent:  
Private entities must request express written authorization to process personal 
data.

Principle of Quality:  
Personal data must be accurate, updated, and used only for the purposes that 
justify their processing.

Principle of Information:  
You have the right to know the main characteristics of how your data will be 
processed, which is detailed in this Privacy Notice.

Principle of Proportionality:  
Companies may only collect the data strictly necessary to fulfill the intended 
purpose.

Principle of Responsibility:  
Private entities must ensure compliance with data protection principles, whether 
inside or outside the country, and must be accountable in case of non-compliance.

What are ARCO Rights?  
Access, Rectification, Cancellation, and Opposition.

Right of Access:  
The right to request whether your personal data exists in a private entity’s 
database.

Right of Rectification:  
The right to request correction of your personal data when it is incorrect, 
inaccurate, incomplete, or outdated.

Right of Cancellation:  
The right to request deletion of your personal data when it is no longer necessary 
for the activities of the private entity. Data must be blocked and later deleted.

Right of Opposition:  
The right to request that a private entity refrain from processing your personal 
data in certain situations.
''',
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
                        const SizedBox(height: 30),
                        // ⭐ ACEPTACIÓN DE TÉRMINOS Y AVISO DE PRIVACIDAD
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: aceptaTerminos,
                              activeColor: const Color(0xFF003DA5),
                              onChanged: (value) {
                                setState(() => aceptaTerminos = value ?? false);
                              },
                            ),
                            Expanded(
                              child: Wrap(
                                children: [
                                  Text(
                                    textos[lang]!['acepto']! + " ",
                                    style: const TextStyle(fontSize: 14),
                                  ),

                                  // ⭐ TÉRMINOS Y CONDICIONES
                                  GestureDetector(
                                    onTap: () {
                                      showLegalModal(
                                        textos[lang]!['terminos']!,
                                        textos[lang]!['terminosText']!,
                                      );
                                    },
                                    child: Text(
                                      textos[lang]!['terminos']!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF003DA5),
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),

                                  Text(
                                      " ${lang == 'es' ? 'y el' : 'and the'} "),

                                  // ⭐ AVISO DE PRIVACIDAD
                                  GestureDetector(
                                    onTap: () {
                                      showLegalModal(
                                        textos[lang]!['aviso']!,
                                        textos[lang]!['avisoText']!,
                                      );
                                    },
                                    child: Text(
                                      textos[lang]!['aviso']!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF003DA5),
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
