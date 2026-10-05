import 'package:flutter/material.dart';
import '../../core/auth/auth_controller.dart';
import '../../core/api/api_client.dart';
import '../projects/project_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.auth, required this.api});
  final AuthController auth;
  final ApiClient api;
  @override
  Widget build(BuildContext c) {
    var u = auth.user!;
    return Scaffold(
        appBar: AppBar(title: const Text('FiberTrack'), actions: [
          IconButton(
              tooltip: 'Cerrar sesión',
              onPressed: () => _logout(c),
              icon: const Icon(Icons.logout))
        ]),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          Text('Hola, ${u.nombre}', style: Theme.of(c).textTheme.headlineSmall),
          Text(u.owner
              ? '👑 Propietario • Administrador principal'
              : u.roles.join(' • ')),
          const SizedBox(height: 24),
          if (auth.has('PROYECTO_VER'))
            _tile(
                c,
                Icons.apartment,
                'PROYECTOS',
                () => Navigator.push(
                    c,
                    MaterialPageRoute(
                        builder: (_) =>
                            ProjectListScreen(api: api, auth: auth)))),
          if (auth.has('USUARIO_VER'))
            _tile(c, Icons.people_alt_outlined, 'USUARIOS', () {}),
          if (auth.has('FUSION_VER'))
            _tile(c, Icons.merge_type, 'FUSIONES', () {}),
          if (auth.has('CERTIFICACION_VER'))
            _tile(c, Icons.fact_check_outlined, 'CERTIFICACIONES', () {}),
          if (auth.has('AUDITORIA_VER'))
            _tile(c, Icons.history, 'AUDITORÍA', () {})
        ]));
  }

  Widget _tile(BuildContext c, IconData i, String t, VoidCallback tap) => Card(
      child: ListTile(
          minVerticalPadding: 20,
          leading: Icon(i, size: 32),
          title: Text(t),
          trailing: const Icon(Icons.chevron_right),
          onTap: tap));
  Future<void> _logout(BuildContext c) async {
    if (await showDialog<bool>(
            context: c,
            builder: (x) => AlertDialog(
                    title: const Text('Cerrar sesión'),
                    content: const Text(
                        '¿Deseas cerrar la sesión en este dispositivo?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(x, false),
                          child: const Text('Cancelar')),
                      FilledButton(
                          onPressed: () => Navigator.pop(x, true),
                          child: const Text('Cerrar sesión'))
                    ])) ==
        true) {
      await auth.logout();
    }
  }
}
