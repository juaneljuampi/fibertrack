import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';
import '../../core/auth/auth_controller.dart';
import 'sector_create_screen.dart';

class SectorListScreen extends StatefulWidget {
  const SectorListScreen(
      {super.key, required this.api, required this.auth, required this.header});
  final ApiClient api;
  final AuthController auth;
  final Map<String, dynamic> header;
  @override
  State<SectorListScreen> createState() => _State();
}

class _State extends State<SectorListScreen> {
  late Future<dynamic> data;
  @override
  void initState() {
    super.initState();
    data = load();
  }

  Future<dynamic> load() =>
      widget.api.get('/cabeceras/${widget.header['id']}/sectores');
  @override
  Widget build(BuildContext c) => Scaffold(
      appBar: AppBar(title: Text(widget.header['nombre'])),
      floatingActionButton: widget.auth.has('SECTOR_CREAR')
          ? FloatingActionButton.extended(
              onPressed: create,
              icon: const Icon(Icons.add),
              label: const Text('Piso / lado'))
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
            if (list.isEmpty) {
              return const Center(child: Text('Crea el primer piso / lado.'));
            }
            return ListView(padding: const EdgeInsets.all(12), children: [
              for (var x in list)
                Card(
                    child: ListTile(
                        leading: const Icon(Icons.view_list),
                        title: Text('Piso ${x['piso']} • Lado ${x['lado']}'),
                        subtitle: Text(
                            '${x['departamentos']} departamentos • ${x['departamentos'] * 2} posiciones'),
                        onTap: () => show(x['id'])))
            ]);
          }));
  Future<void> create() async {
    var ok = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SectorCreateScreen(
                api: widget.api, headerId: widget.header['id'])));
    if (ok == true) setState(() => data = load());
  }

  Future<void> show(String id) async {
    var s = await widget.api.get('/sectores/$id');
    if (!mounted) return;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (c) => DraggableScrollableSheet(
            expand: false,
            builder: (c, scroll) => ListView(
                    controller: scroll,
                    padding: const EdgeInsets.all(20),
                    children: [
                      Text('Piso ${s['piso']} • Lado ${s['lado']}',
                          style: Theme.of(c).textTheme.titleLarge),
                      for (var d in s['departamentos'])
                        ListTile(
                            title: Text('${d['numero']}'),
                            subtitle: Text((d['posiciones'] as List)
                                .map((p) =>
                                    '${p['tipo']} • Puerto ${p['puerto']} • ${p['estado']}')
                                .join('\n')))
                    ])));
  }
}
