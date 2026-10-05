import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';
import '../../core/auth/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.auth, required this.api});
  final AuthController auth;
  final ApiClient api;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool busy = false, resetRequested = false;
  String? error;

  Future<void> submit() async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await widget.auth.login(email.text, password.text);
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> requestReset() async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await widget.api.post('/auth/password/request', {'email': email.text});
      if (mounted) setState(() => resetRequested = true);
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> resetPassword() async {
    final token = TextEditingController(),
        next = TextEditingController(),
        confirm = TextEditingController();
    final accepted = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Nueva contraseña'),
              content: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                    controller: token,
                    decoration:
                        const InputDecoration(labelText: 'Token recibido')),
                const SizedBox(height: 12),
                TextField(
                    controller: next,
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: 'Nueva contraseña')),
                const SizedBox(height: 12),
                TextField(
                    controller: confirm,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Confirmar contraseña'))
              ])),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancelar')),
                FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Guardar'))
              ],
            ));
    if (accepted != true) return;
    if (next.text != confirm.text) {
      setState(() => error = 'Las contraseñas no coinciden.');
      return;
    }
    try {
      await widget.api.post('/auth/password/reset',
          {'token': token.text.trim(), 'password': next.text});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Contraseña guardada. Ya puedes iniciar sesión.')));
      }
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      token.dispose();
      next.dispose();
      confirm.dispose();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: SafeArea(
              child: Center(
                  child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.hub_outlined,
                      size: 72, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 16),
                  Text('FIBERTRACK',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const Text('Gestión y trazabilidad\nde fibra óptica',
                      textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      decoration: const InputDecoration(
                          labelText: 'Correo',
                          prefixIcon: Icon(Icons.email_outlined))),
                  const SizedBox(height: 12),
                  TextField(
                      controller: password,
                      obscureText: true,
                      onSubmitted: (_) => submit(),
                      decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock_outline))),
                  if (error != null)
                    Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(error!,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error))),
                  if (resetRequested)
                    const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text(
                            'Si el correo está registrado en FiberTrack, recibirás instrucciones.')),
                  const SizedBox(height: 20),
                  FilledButton(
                      onPressed: busy ? null : submit,
                      child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: busy
                              ? const SizedBox.square(
                                  dimension: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2))
                              : const Text('INICIAR SESIÓN'))),
                  TextButton(
                      onPressed: busy ? null : requestReset,
                      child: const Text('¿Crear o recuperar contraseña?')),
                  TextButton(
                      onPressed: busy ? null : resetPassword,
                      child: const Text('Ya tengo un token'))
                ])),
      ))));

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
