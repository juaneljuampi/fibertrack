import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';
import '../../core/auth/auth_controller.dart';
import '../sectors/sector_list_screen.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen(
      {super.key,
      required this.api,
      required this.auth,
      required this.project});
  final ApiClient api;
  final AuthController auth;
  final Map<String, dynamic> project;
  @override
  State<ProjectScreen> createState() => _State();
}

class _State extends State<ProjectScreen> {
  late Future<dynamic> data;
  @override
  void initState() {
    super.initState();
    data = load();
  }

  Future<dynamic> load() =>
      widget.api.get('/proyectos/${widget.project['id']}/cabeceras');
  @override
  Widget build(BuildContext c) => Scaffold(
      appBar: AppBar(title: Text(widget.project['nombre'])),
      floatingActionButton: widget.auth.has('CABECERA_CREAR')
          ? FloatingActionButton(
              onPressed: create, child: const Icon(Icons.add))
          : null,
      body: FutureBuilder<dynamic>(
          future: data,
          builder: (c, s) {
            if (!s.hasData) {
              return Center(
                  child: s.hasError
                      ? Text('${s.error}')
                      : const CircularProgressIndicator());
            }
            var list = s.data as List;
            return ListView(padding: const EdgeInsets.all(12), children: [
              for (var h in list)
                Card(
                    child: ListTile(
                        title: Text(h['nombre']),
                        subtitle: Text(
                            '${h['capacidad']} puertos • ${h['ocupados']} ocupados • ${h['reservados']} reservados • ${h['libres']} libres'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(
                            c,
                            MaterialPageRoute(
                                builder: (_) => SectorListScreen(
                                    api: widget.api,
                                    auth: widget.auth,
                                    header: h)))))
            ]);
          }));
  Future<void> create() async {
    final name = TextEditingController(text: 'Cabecera 01');
    int capacity = 144;
    if (await showDialog<bool>(
            context: context,
            builder: (c) => StatefulBuilder(
                builder: (c, set) => AlertDialog(
                        title: const Text('Nueva cabecera'),
                        content:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          TextField(
                              controller: name,
                              decoration:
                                  const InputDecoration(labelText: 'Nombre')),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<int>(
                              initialValue: capacity,
                              decoration:
                                  const InputDecoration(labelText: 'Capacidad'),
                              items: const [
                                DropdownMenuItem(
                                    value: 94, child: Text('94 puertos')),
                                DropdownMenuItem(
                                    value: 144, child: Text('144 puertos'))
                              ],
                              onChanged: (v) => set(() => capacity = v!))
                        ]),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(c, false),
                              child: const Text('Cancelar')),
                          FilledButton(
                              onPressed: () => Navigator.pop(c, true),
                              child: const Text('Crear'))
                        ]))) ==
        true) {
      await widget.api.post('/proyectos/${widget.project['id']}/cabeceras',
          {'nombre': name.text, 'capacidad': capacity});
      setState(() => data = load());
    }
  }
}
