// lib/view/agendar/agendar_cirugia_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:real_san_jose/common/widget/custombutton.dart';
import 'package:real_san_jose/common/widget/customtextfield.dart';
import 'package:real_san_jose/common/widget/custom_header.dart';
import 'package:real_san_jose/common/widget/borderradius.dart';
import 'package:real_san_jose/utils/decoration.dart';
import 'package:real_san_jose/api/auth_service.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';
import 'package:real_san_jose/view/dashboard/dashboardscreen.dart';

class AgendarCirugiaScreen extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> sucursales;
  final List<String>? aseguradoras;

  const AgendarCirugiaScreen({
    super.key,
    required this.sucursales,
    this.aseguradoras,
  });

  @override
  ConsumerState<AgendarCirugiaScreen> createState() =>
      _AgendarCirugiaScreenState();
}

class _AgendarCirugiaScreenState extends ConsumerState<AgendarCirugiaScreen> {
  int? selectedHospitalId;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedAseguradora;

  final TextEditingController medicoCtrl = TextEditingController();
  final TextEditingController comentarioCtrl = TextEditingController();
  final TextEditingController cirugiaCtrl = TextEditingController();

  // Controller visual para mostrar la fecha en el CustomTextField sin modificarlo
  final TextEditingController fechaVisualCtrl = TextEditingController();

  bool isLoading = false;

  // Aseguradoras
  bool loadingAseguradoras = false;
  List<String> aseguradorasList = [];

  @override
  void initState() {
    super.initState();
    if (widget.aseguradoras != null && widget.aseguradoras!.isNotEmpty) {
      aseguradorasList = List<String>.from(widget.aseguradoras!);
    } else {
      _loadAseguradoras();
    }
  }

  @override
  void dispose() {
    medicoCtrl.dispose();
    comentarioCtrl.dispose();
    cirugiaCtrl.dispose();
    fechaVisualCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAseguradoras() async {
    setState(() => loadingAseguradoras = true);
    try {
      final service = AuthService();
      final raw = await service.fetchAseguradoras();
      final List<String> names = raw
          .map((m) {
            if (m.containsKey('Servicio')) return m['Servicio'].toString();
            if (m.containsKey('nombre')) return m['nombre'].toString();
            if (m.containsKey('Nombre')) return m['Nombre'].toString();
            return m.values.isNotEmpty ? m.values.first.toString() : '';
          })
          .where((s) => s.isNotEmpty)
          .toList();
      if (mounted) setState(() => aseguradorasList = names);
    } catch (e) {
      if (mounted) {
        _showSnackBar(
          ref.read(languageProvider) == 'es'
              ? 'Error cargando aseguradoras: $e'
              : 'Error loading insurers: $e',
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => loadingAseguradoras = false);
    }
  }

  // Genera slots cada 30 minutos (00:00 - 23:30)
  List<TimeOfDay> _generateTimeSlots() {
    final List<TimeOfDay> slots = [];
    for (int h = 0; h < 24; h++) {
      slots.add(TimeOfDay(hour: h, minute: 0));
      slots.add(TimeOfDay(hour: h, minute: 30));
    }
    return slots;
  }

  String _formatTimeOfDay(TimeOfDay t) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    return DateFormat.Hm().format(dt); // HH:mm 24h
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? today,
      firstDate: today,
      lastDate: DateTime(today.year + 2),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedTime = null;
        // actualizar controller visual con formato YYYY-MM-DD
        fechaVisualCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Componer ISO con offset local (ej. 2026-06-22T09:30:00-06:00)
  String _composeIsoWithLocalOffset(DateTime date, TimeOfDay time) {
    final dt =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    final offset = DateTime.now().timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    final iso = dt.toIso8601String();
    return '$iso$sign$hours:$minutes';
  }

  Map<String, dynamic>? _tryDecode(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  String _localizedMessage(String raw, String lang) {
    final lower = raw.toLowerCase();
    if (lower.contains('no se pueden generar mas de 3 solicitudes') ||
        lower.contains('no se pueden generar más de 3 solicitudes')) {
      return lang == 'es'
          ? 'No se pueden generar más de 3 solicitudes de cirugía sin confirmar.'
          : 'You cannot create more than 3 surgery requests without confirmation.';
    }
    return raw;
  }

  Future<void> _solicitarCirugia() async {
    final lang = ref.read(languageProvider);

    if (selectedHospitalId == null) {
      _showSnackBar(
          lang == 'es' ? 'Selecciona un hospital' : 'Select a hospital',
          isError: true);
      return;
    }
    if (selectedDate == null) {
      _showSnackBar(lang == 'es' ? 'Selecciona una fecha' : 'Select a date',
          isError: true);
      return;
    }
    if (selectedTime == null) {
      _showSnackBar(lang == 'es' ? 'Selecciona un horario' : 'Select a time',
          isError: true);
      return;
    }
    if (cirugiaCtrl.text.trim().isEmpty) {
      _showSnackBar(
          lang == 'es'
              ? 'Ingresa el nombre de la cirugía'
              : 'Enter surgery name',
          isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      final fechaHoraIso =
          _composeIsoWithLocalOffset(selectedDate!, selectedTime!);
      final body = {
        "SucursalId": selectedHospitalId,
        "FechaHora": fechaHoraIso,
        "Medico":
            medicoCtrl.text.trim().isEmpty ? null : medicoCtrl.text.trim(),
        "Aseguradora": selectedAseguradora,
        "Comentarios": comentarioCtrl.text.trim().isEmpty
            ? null
            : comentarioCtrl.text.trim(),
        "Cirugia": cirugiaCtrl.text.trim(),
      };

      final service = AuthService();
      final response = await service.postCirugia(body);

      final raw = response.body;
      final decoded = _tryDecode(raw);

      if (response.statusCode == 200 && decoded != null) {
        // ✅ Caso exitoso con JSON
        final msg = lang == 'es'
            ? 'Solicitud de cirugía registrada'
            : 'Surgery request registered';

        // Mostrar modal y navegar al dashboard al dar OK
        if (mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(lang == 'es' ? 'Éxito' : 'Success'),
              content: Text(msg),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(); // cerrar el dialog
                    // 🔹 Limpiar campos y estado
                    setState(() {
                      medicoCtrl.clear();
                      comentarioCtrl.clear();
                      cirugiaCtrl.clear();
                      fechaVisualCtrl.clear();
                      selectedHospitalId = null;
                      selectedDate = null;
                      selectedTime = null;
                      selectedAseguradora = null;
                    });
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        // ❌ Caso error: mostrar texto tal cual
        final msg = decoded != null
            ? (decoded['Mensaje'] ?? decoded['Message'] ?? raw).toString()
            : raw.toString();
        _showSnackBar(msg, isError: true);
      }
    } catch (e) {
      _showSnackBar(lang == 'es' ? 'Error: $e' : 'Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // SnackBar helper: fondo azul para éxito, rojo para error, texto blanco
  void _showSnackBar(String message, {required bool isError}) {
    final bg = isError ? Colors.red : const Color(0xFF0166B8);
    final snack = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: bg,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final times = _generateTimeSlots();

    // Lista fija de hospitales que indicaste
    final hospitales = [
      {"id": 0, "nombre": "Hospital Lázaro Cárdenas"},
      {"id": 1, "nombre": "Hospital Valle Real"},
    ];

    return Container(
      decoration: bgDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const CustomHeader(title: "Solicitar cirugía"),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: borderRadius(),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label arriba + Dropdown hospital
                      Text(
                        lang == 'es'
                            ? 'Seleccionar hospital'
                            : 'Select hospital',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFF0166B8), width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.withOpacity(0.04),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            isExpanded: true,
                            value: selectedHospitalId,
                            items: hospitales
                                .map((s) => DropdownMenuItem<int>(
                                      value: s['id'] as int,
                                      child: Text(s['nombre'].toString()),
                                    ))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => selectedHospitalId = v),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Fecha label + campo (YYYY-MM-DD) usando CustomTextField sin modificar otros archivos
                      Text(
                        lang == 'es' ? 'Fecha' : 'Date',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      // GestureDetector + AbsorbPointer para usar CustomTextField como solo lectura
                      GestureDetector(
                        onTap: _pickDate,
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: fechaVisualCtrl,
                            hintText: selectedDate == null
                                ? (lang == 'es'
                                    ? 'Selecciona fecha'
                                    : 'Select date')
                                : DateFormat('yyyy-MM-dd')
                                    .format(selectedDate!),
                            leadingIconData: const Icon(Icons.calendar_today),
                            textInputType: TextInputType.datetime,
                            color: Colors.grey.withOpacity(0.08),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Horario label + dropdown
                      Text(
                        lang == 'es' ? 'Horario' : 'Time',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFF0166B8), width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.withOpacity(0.04),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<TimeOfDay>(
                            isExpanded: true,
                            value: selectedTime,
                            items: times
                                .map((t) => DropdownMenuItem<TimeOfDay>(
                                      value: t,
                                      child: Text(_formatTimeOfDay(t)),
                                    ))
                                .toList(),
                            onChanged: (t) => setState(() => selectedTime = t),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Médico (label + CustomTextField)
                      Text(
                        lang == 'es' ? 'Médico' : 'Doctor',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      CustomTextField(
                        controller: medicoCtrl,
                        hintText: lang == 'es'
                            ? 'Nombre del médico (opcional)'
                            : 'Doctor name (optional)',
                        leadingIconData: const Icon(Icons.person),
                        textInputType: TextInputType.text,
                        color: Colors.grey.withOpacity(0.08),
                      ),
                      const SizedBox(height: 12),

                      // Cirugía (label + CustomTextField)
                      Text(
                        lang == 'es' ? 'Cirugía' : 'Surgery',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      CustomTextField(
                        controller: cirugiaCtrl,
                        hintText: lang == 'es'
                            ? 'Nombre de la cirugía'
                            : 'Surgery name',
                        leadingIconData: const Icon(Icons.medical_services),
                        textInputType: TextInputType.text,
                        color: Colors.grey.withOpacity(0.08),
                      ),
                      const SizedBox(height: 12),

                      // Comentarios (label + TextFormField multiline para no tocar CustomTextField)
                      Text(
                        lang == 'es' ? 'Comentarios' : 'Comments',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFF0166B8), width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.withOpacity(0.04),
                        ),
                        child: TextFormField(
                          controller: comentarioCtrl,
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: lang == 'es'
                                ? 'Comentarios adicionales'
                                : 'Additional comments',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Aseguradora (label + dropdown)
                      Text(
                        lang == 'es' ? 'Aseguradora' : 'Insurer',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      loadingAseguradoras
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xFF0166B8), width: 1.5),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.withOpacity(0.04),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedAseguradora,
                                  items: [
                                    DropdownMenuItem<String>(
                                      value: null,
                                      child: Text(
                                          lang == 'es' ? 'Ninguna' : 'None'),
                                    ),
                                    ...aseguradorasList
                                        .map((a) => DropdownMenuItem<String>(
                                              value: a,
                                              child: Text(a),
                                            )),
                                  ],
                                  onChanged: (v) =>
                                      setState(() => selectedAseguradora = v),
                                ),
                              ),
                            ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // Botón inferior
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      title: ref.watch(languageProvider) == 'es'
                          ? 'Solicitar cirugía'
                          : 'Request surgery',
                      ontap: _solicitarCirugia,
                      color: const Color(0xFF0166B8),
                      textColor: Colors.white,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
