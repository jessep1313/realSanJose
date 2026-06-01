import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:real_san_jose/api/auth_service.dart';
import 'package:real_san_jose/provider/configprovider.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  static var routeName = "/editprofilescreen";

  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final correoCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();
  final rfcCtrl = TextEditingController();
  final curpCtrl = TextEditingController();
  final paternoCtrl = TextEditingController();
  final maternoCtrl = TextEditingController();
  final nombreCtrl = TextEditingController();
  final fechaCtrl = TextEditingController();
  final calleCtrl = TextEditingController();
  final cpCtrl = TextEditingController();
  final noExteriorCtrl = TextEditingController();
  final noInteriorCtrl = TextEditingController();
  final coloniaCtrl = TextEditingController();
  final ciudadCtrl = TextEditingController();
  final estadoCtrl = TextEditingController();
  final paisCtrl = TextEditingController();
  final nacionalidadCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      correoCtrl.text = prefs.getString("Correo") ?? "";
      telefonoCtrl.text = prefs.getString("Telefono") ?? "";
      rfcCtrl.text = prefs.getString("Rfc") ?? "";
      curpCtrl.text = prefs.getString("Curp") ?? "";
      paternoCtrl.text = prefs.getString("Paterno") ?? "";
      maternoCtrl.text = prefs.getString("Materno") ?? "";
      nombreCtrl.text = prefs.getString("Nombre") ?? "";
      fechaCtrl.text = prefs.getString("FechaNacimiento") ?? "";
      calleCtrl.text = prefs.getString("Calle") ?? "";
      cpCtrl.text = prefs.getString("CodigoPostal") ?? "";
      noExteriorCtrl.text = prefs.getString("NoExterior") ?? "";
      noInteriorCtrl.text = prefs.getString("NoInterior") ?? "";
      coloniaCtrl.text = prefs.getString("Colonia") ?? "";
      ciudadCtrl.text = prefs.getString("Ciudad") ?? "";
      estadoCtrl.text = prefs.getString("Estado") ?? "";
      paisCtrl.text = prefs.getString("Pais") ?? "";
      nacionalidadCtrl.text = prefs.getString("Nacionalidad") ?? "";
    });
  }

  Future<void> _actualizar() async {
    if (_formKey.currentState!.validate()) {
      final payload = {
        "Correo": correoCtrl.text,
        "Telefono": telefonoCtrl.text,
        "Rfc": rfcCtrl.text,
        "Curp": curpCtrl.text,
        "Paterno": paternoCtrl.text,
        "Materno": maternoCtrl.text,
        "Nombre": nombreCtrl.text,
        "FechaNacimiento": fechaCtrl.text,
        "Calle": calleCtrl.text,
        "CodigoPostal": cpCtrl.text,
        "NoExterior": noExteriorCtrl.text,
        "NoInterior": noInteriorCtrl.text,
        "Colonia": coloniaCtrl.text,
        "Ciudad": ciudadCtrl.text,
        "Estado": estadoCtrl.text,
        "Pais": paisCtrl.text,
        "Nacionalidad": nacionalidadCtrl.text,
      };

      try {
        final service = AuthService();
        await service.actualizarPaciente(payload);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Paciente actualizado correctamente")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Color(0xFF003DA5), size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Center(
          child: Image.asset('assets/icons/logo.jpg', height: 90),
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildField("Correo", correoCtrl),
                _buildField("Teléfono", telefonoCtrl),
                _buildField("RFC", rfcCtrl),
                _buildField("CURP", curpCtrl),
                _buildField("Apellido Paterno", paternoCtrl),
                _buildField("Apellido Materno", maternoCtrl),
                _buildField("Nombre", nombreCtrl),
                _buildField("Fecha de Nacimiento", fechaCtrl),
                _buildField("Calle", calleCtrl),
                _buildField("Código Postal", cpCtrl),
                _buildField("No Exterior", noExteriorCtrl),
                _buildField("No Interior", noInteriorCtrl),
                _buildField("Colonia", coloniaCtrl),
                _buildField("Ciudad", ciudadCtrl),
                _buildField("Estado", estadoCtrl),
                _buildField("País", paisCtrl),
                _buildField("Nacionalidad", nacionalidadCtrl),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _actualizar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003DA5),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text("Actualizar",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
