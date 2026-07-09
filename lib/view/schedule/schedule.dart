import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:real_san_jose/common/widget/custom_header.dart'; // ⬅️ Importar
import 'package:real_san_jose/provider/scheduleprovider.dart';
import 'package:real_san_jose/api/auth_service.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  static String routeName = "/schedulescreen";
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ScheduleScreenState();
}

class ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  ScrollController controller = ScrollController();
  List<Map<String, dynamic>> citas = [];
  bool cargandoCitas = false;

  @override
  void initState() {
    controller.addListener(scrollListener);
    super.initState();
    cargarCitas();
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

  void _confirmarCancelacion(
      int folioAgenda, int codigoSucursal, String fechaHoraIso) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmar"),
        content: const Text("¿Está seguro de cancelar la cita?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                final service = AuthService();
                final msg = await service.cancelarCita(
                  agendaId: folioAgenda,
                  sucursal: codigoSucursal,
                  fechaHora: fechaHoraIso,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(msg)),
                );
                cargarCitas(); // 🔹 recarga el listado
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error al cancelar cita: $e")),
                );
              }
            },
            child: const Text("Sí"),
          ),
        ],
      ),
    );
  }

  Future<void> cargarCitas() async {
    setState(() => cargandoCitas = true);
    try {
      final service = AuthService();
      citas = await service.fetchCitas();
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

    // Filtrar próximas y pasadas
    final now = DateTime.now();
    final proximas = citas.where((c) {
      final fecha = DateTime.parse(c["Fecha"]);
      return fecha.isAfter(now) || fecha.isAtSameMomentAs(now);
    }).toList();

    final pasadas = citas.where((c) {
      final fecha = DateTime.parse(c["Fecha"]);
      return fecha.isBefore(now);
    }).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const CustomHeader(),
              const SizedBox(height: 10),

              // Tabs
              TabBar(
                labelColor: const Color(0xFF0166B8),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF0166B8),
                tabs: [
                  Tab(text: lang == 'es' ? 'Próximas' : 'Upcoming'),
                  Tab(text: lang == 'es' ? 'Pasadas' : 'Past'),
                ],
              ),

              Expanded(
                child: cargandoCitas
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: Color(0xFF0166B8)))
                    : TabBarView(
                        children: [
                          _buildList(proximas, lang,
                              cancelable: true), // ✅ botón activo
                          _buildList(pasadas, lang,
                              cancelable: false), // ✅ botón desactivado
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> lista, String lang,
      {bool cancelable = false}) {
    if (lista.isEmpty) {
      return Center(
        child: Text(
          lang == 'es'
              ? "No hay citas en esta sección"
              : "No appointments in this section",
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return ListView.builder(
      controller: controller,
      itemCount: lista.length,
      itemBuilder: (context, index) {
        final cita = lista[index];
        final fechaHora = DateTime.parse(cita["Fecha"]);
        final fechaStr = DateFormat("yyyy-MM-dd").format(fechaHora);
        final horaStr = DateFormat("HH:mm").format(fechaHora);

        final icono =
            cita["DescripcionEstudio"].toString().toUpperCase().contains("RX")
                ? Icons.image_search
                : Icons.biotech;

        return _appointmentCard(
          icon: icono,
          title: cita["DescripcionEstudio"] ?? "Consulta",
          subtitle: "Folio: ${cita["FolioAgenda"]} | $fechaStr a las $horaStr",
          status: cita["Status"] ?? "",
          codigoSucursal: cita["CodigoSucursal"] ?? 0,
          folioAgenda: cita["FolioAgenda"],
          fechaHoraIso: cita["Fecha"],
          cancelable: cancelable, // 🔹 aquí decides
        );
      },
    );
  }

  Widget _appointmentCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
    required int codigoSucursal,
    required int folioAgenda,
    required String fechaHoraIso,
    bool cancelable = false, // 🔹 por defecto no cancelable
  }) {
    final hospital = codigoSucursal == 0
        ? "Hospital Lázaro Cárdenas"
        : "Hospital Valle Real";

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF0166B8), width: 2),
      ),
      elevation: 2,
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: const Color(0xFF8B8E00), size: 32),
            title: Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("$subtitle\nHospital: $hospital"),
            trailing: Text(status, style: const TextStyle(color: Colors.grey)),
          ),
          if (cancelable && status.toLowerCase() != "cancelada")
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.cancel, color: Colors.white),
                label: const Text("Cancelar cita",
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  _confirmarCancelacion(
                      folioAgenda, codigoSucursal, fechaHoraIso);
                },
              ),
            ),
        ],
      ),
    );
  }
}
