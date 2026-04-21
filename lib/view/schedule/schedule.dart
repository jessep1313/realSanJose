import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:real_san_jose/common/widget/borderradius.dart';
import 'package:real_san_jose/provider/scheduleprovider.dart';
import 'package:real_san_jose/utils/decoration.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';
import 'package:real_san_jose/api/auth_service.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  static String routeName = "/schedulescreen";

  const ScheduleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ScheduleScreenState();
}

class ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  ScrollController controller = ScrollController();
  DateTime selectedDate = DateTime.now();

  List<Map<String, dynamic>> citas = [];
  bool cargandoCitas = false;

  @override
  void initState() {
    controller.addListener(scrollListener);
    super.initState();
    cargarCitas(); // carga inicial con fecha actual
  }

  void scrollListener() {
    if (controller.position.userScrollDirection == ScrollDirection.reverse) {
      if (ref.watch(scheduleProvider).isVisible) {
        ref.read(scheduleProvider).setVisible(false);
      }
    } else if (controller.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!ref.watch(scheduleProvider).isVisible) {
        ref.read(scheduleProvider).setVisible(true);
      }
    }
  }

  Future<void> cargarCitas() async {
    setState(() => cargandoCitas = true);
    try {
      final service = AuthService();
      final todas = await service.fetchCitas();

      final fechaStr = DateFormat("yyyy-MM-dd").format(selectedDate);
      citas = todas.where((c) {
        final fechaApi = DateTime.parse(c["Fecha"]);
        final fechaApiStr = DateFormat("yyyy-MM-dd").format(fechaApi);
        return fechaApiStr == fechaStr;
      }).toList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error cargando citas: $e")),
      );
    } finally {
      setState(() => cargandoCitas = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    final dayNames = {
      'es': ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'],
      'en': ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    };

    // Semana actual desde el día seleccionado
    List<DateTime> weekDays =
        List.generate(7, (i) => selectedDate.add(Duration(days: i)));

    return Container(
      decoration: bgDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius(),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.notifications_none,
                          color: Color(0xFF003DA5), size: 28),
                      Image.asset('assets/icons/logo.jpg', height: 90),
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
                  const SizedBox(height: 10),

                  // Texto del día seleccionado
                  Text(
                    DateFormat('EEEE dd MMMM yyyy',
                            lang == 'es' ? 'es_ES' : 'en_US')
                        .format(selectedDate),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003DA5)),
                  ),
                  const SizedBox(height: 10),

                  // Flechas y carrusel de días
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Color(0xFF003DA5)),
                        onPressed: () {
                          final prevDay =
                              selectedDate.subtract(const Duration(days: 1));
                          // Solo permitir regresar hasta el día actual
                          if (!prevDay.isBefore(DateTime.now())) {
                            setState(() => selectedDate = prevDay);
                            cargarCitas();
                          }
                        },
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 70,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: weekDays.length,
                            itemBuilder: (context, index) {
                              final date = weekDays[index];
                              final isSelected = date.day == selectedDate.day &&
                                  date.month == selectedDate.month &&
                                  date.year == selectedDate.year;

                              return GestureDetector(
                                onTap: () {
                                  setState(() => selectedDate = date);
                                  cargarCitas();
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF003DA5)
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        dayNames[lang]![
                                            date.weekday % 7], // nombre corto
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${date.day}',
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios,
                            color: Color(0xFF003DA5)),
                        onPressed: () {
                          final nextWeek =
                              selectedDate.add(const Duration(days: 7));
                          setState(() => selectedDate = nextWeek);
                          cargarCitas();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Listado de citas
                  Expanded(
                    child: cargandoCitas
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFF003DA5)))
                        : citas.isEmpty
                            ? Center(
                                child: Text(
                                  lang == 'es'
                                      ? "No hay citas para este día"
                                      : "No appointments for this day",
                                  style: const TextStyle(color: Colors.red),
                                ),
                              )
                            : ListView.builder(
                                controller: controller,
                                itemCount: citas.length,
                                itemBuilder: (context, index) {
                                  final cita = citas[index];
                                  final fechaHora =
                                      DateTime.parse(cita["Fecha"]);
                                  final fechaStr = DateFormat("yyyy-MM-dd")
                                      .format(fechaHora);
                                  final horaStr =
                                      DateFormat("HH:mm").format(fechaHora);

                                  final icono = cita["DescripcionEstudio"]
                                          .toString()
                                          .toUpperCase()
                                          .contains("RX")
                                      ? Icons.image_search
                                      : Icons.biotech;

                                  return _appointmentCard(
                                    icon: icono,
                                    title: cita["DescripcionEstudio"] ??
                                        "Consulta",
                                    subtitle:
                                        "Folio: ${cita["FolioAgenda"]} | $fechaStr a las $horaStr",
                                    status: cita["Status"] ?? "",
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _appointmentCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF003DA5), width: 2),
      ),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF009639), size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Text(status, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}
