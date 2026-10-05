import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';
import '../../core/auth/auth_controller.dart';
import 'project_screen.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key, required this.api, required this.auth});
  final ApiClient api;
  final AuthController auth;
  @override
  State<ProjectListScreen> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectListScreen> {
  late Future<dynamic> data;
  @override
  void initState() {
    super.initState();
    data = widget.api.get('/proyectos');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Proyectos / Edificios')),
        floatingActionButton: widget.auth.has('PROYECTO_CREAR')
            ? FloatingActionButton(
                onPressed: create, child: const Icon(Icons.add))
            : null,
        body: FutureBuilder<dynamic>(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              }
              final items = snapshot.data as List;
              if (items.isEmpty) {
                return const Center(child: Text('Aún no hay proyectos.'));
              }
              return RefreshIndicator(
                  onRefresh: refresh,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final project = Map<String, dynamic>.from(items[index]);
                      return Card(
                          child: ListTile(
                              leading: const Icon(Icons.apartment),
                              title: Text(project['nombre']),
                              subtitle: Text(
                                  '${project['direccion']}\n${project['comuna'] ?? ''}'),
                              isThreeLine: true,
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ProjectScreen(
                                          api: widget.api,
                                          auth: widget.auth,
                                          project: project)))));
                    },
                  ));
            }),
      );

  Future<void> refresh() async {
    setState(() => data = widget.api.get('/proyectos'));
    await data;
  }

  Future<void> create() async {
    final name = TextEditingController(),
        address = TextEditingController(),
        commune = TextEditingController();
    final accepted = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Nuevo proyecto'),
              content: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                    controller: name,
                    decoration: const InputDecoration(labelText: 'Nombre')),
                const SizedBox(height: 12),
                TextField(
                    controller: address,
                    decoration: const InputDecoration(labelText: 'Dirección')),
                const SizedBox(height: 12),
                TextField(
                    controller: commune,
                    decoration: const InputDecoration(labelText: 'Comuna'))
              ])),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancelar')),
                FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Crear'))
              ],
            ));
    if (accepted == true) {
      await widget.api.post('/proyectos', {
        'nombre': name.text,
        'direccion': address.text,
        'comuna': commune.text
      });
      await refresh();
    }
    name.dispose();
    address.dispose();
    commune.dispose();
  }
}
