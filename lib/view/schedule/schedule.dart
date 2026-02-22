import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:real_san_jose/common/widget/borderradius.dart';
import 'package:real_san_jose/provider/scheduleprovider.dart';
import 'package:real_san_jose/utils/decoration.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  static String routeName = "/schedulescreen";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ScheduleScreenState();
}

class ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  ScrollController controller = ScrollController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    controller.addListener(scrollListener);
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    final dayNames = {
      'es': ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'],
      'en': ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    };

    final textos = {
      'es': {
        'consulta': 'Consulta médica',
        'estudios': 'Estudios clínicos',
        'confirmada': 'Confirmada',
        'pendiente': 'Pendiente',
      },
      'en': {
        'consulta': 'Medical consultation',
        'estudios': 'Clinical studies',
        'confirmada': 'Confirmed',
        'pendiente': 'Pending',
      }
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
            color: Colors.white, // ✅ Fondo blanco
            borderRadius: borderRadius(),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
            child: SafeArea(
              child: Column(
                children: [
                  // Header con campanita, logo y selector de idioma
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
                          final prevWeek =
                              selectedDate.subtract(const Duration(days: 7));
                          if (!prevWeek.isBefore(DateTime.now())) {
                            setState(() => selectedDate = prevWeek);
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
                              final isToday = date.day == DateTime.now().day &&
                                  date.month == DateTime.now().month &&
                                  date.year == DateTime.now().year;
                              final isSelected = date.day == selectedDate.day &&
                                  date.month == selectedDate.month &&
                                  date.year == selectedDate.year;

                              return GestureDetector(
                                onTap: () {
                                  setState(() => selectedDate = date);
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
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Listado de citas (solo 2 ejemplos)
                  Expanded(
                    child: ListView(
                      controller: controller,
                      children: [
                        _appointmentCard(
                          icon: Icons.medical_services_outlined,
                          title: textos[lang]!['consulta']!,
                          subtitle: "08:00 AM - 08:30 AM",
                          status: textos[lang]!['confirmada']!,
                        ),
                        const SizedBox(height: 12),
                        _appointmentCard(
                          icon: Icons.biotech,
                          title: textos[lang]!['estudios']!,
                          subtitle: "10:00 AM - 10:45 AM",
                          status: textos[lang]!['pendiente']!,
                        ),
                      ],
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
