import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';

class SectorCreateScreen extends StatefulWidget {
  const SectorCreateScreen(
      {super.key, required this.api, required this.headerId});
  final ApiClient api;
  final String headerId;
  @override
  State<SectorCreateScreen> createState() => _SectorCreateState();
}

class _SectorCreateState extends State<SectorCreateScreen> {
  final floor = TextEditingController(),
      quantity = TextEditingController(text: '6'),
      first = TextEditingController();
  String side = 'A';
  List<TextEditingController> numbers = [];
  bool second = false, busy = false;
  String? error;

  void generate() {
    final count = int.tryParse(quantity.text) ?? 0;
    if (count < 1 || count > 72) {
      setState(() =>
          error = 'Ingresa una cantidad válida según la capacidad disponible.');
      return;
    }
    final start = int.tryParse(first.text);
    for (final controller in numbers) {
      controller.dispose();
    }
    numbers = List.generate(
        count,
        (index) => TextEditingController(
            text: start == null ? '' : '${start + index}'));
    setState(() {
      second = true;
      error = null;
    });
  }

  Future<void> save() async {
    setState(() => busy = true);
    try {
      await widget.api.post('/cabeceras/${widget.headerId}/sectores', {
        'piso': floor.text,
        'lado': side,
        'departamentos': numbers.map((value) => value.text).toList()
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: Text(
                second ? 'Configurar departamentos' : 'Nuevo piso / sector')),
        body: ListView(
            padding: const EdgeInsets.all(20),
            children:
                second ? _departmentFields(context) : _sectorFields(context)),
      );

  List<Widget> _departmentFields(BuildContext context) => [
        Text('Cada número puede editarse antes de guardar.',
            style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        for (var index = 0; index < numbers.length; index++)
          Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                  controller: numbers[index],
                  decoration:
                      InputDecoration(labelText: 'Departamento ${index + 1}'))),
        if (error != null)
          Text(error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error)),
        const SizedBox(height: 12),
        FilledButton.icon(
            onPressed: busy ? null : save,
            icon: const Icon(Icons.save),
            label: const Padding(
                padding: EdgeInsets.all(14), child: Text('GUARDAR'))),
        const SizedBox(height: 60),
      ];

  List<Widget> _sectorFields(BuildContext context) => [
        TextField(
            controller: floor,
            decoration: const InputDecoration(labelText: 'Piso')),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
            initialValue: side,
            decoration: const InputDecoration(labelText: 'Lado'),
            items: const [
              DropdownMenuItem(value: 'A', child: Text('A')),
              DropdownMenuItem(value: 'B', child: Text('B'))
            ],
            onChanged: (value) => side = value!),
        const SizedBox(height: 12),
        TextField(
            controller: quantity,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: 'Cantidad de departamentos',
                helperText:
                    'Sin límite artificial de 6; depende de la cabecera')),
        const SizedBox(height: 12),
        TextField(
            controller: first,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: 'Departamento inicial (opcional)')),
        if (error != null)
          Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(error!,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.error))),
        const SizedBox(height: 20),
        FilledButton(
            onPressed: generate,
            child: const Padding(
                padding: EdgeInsets.all(14),
                child: Text('CONTINUAR / GENERAR'))),
      ];

  @override
  void dispose() {
    floor.dispose();
    quantity.dispose();
    first.dispose();
    for (final controller in numbers) {
      controller.dispose();
    }
    super.dispose();
  }
}
