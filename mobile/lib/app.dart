import 'package:flutter/material.dart';
import 'core/api/api_client.dart';
import 'core/auth/auth_controller.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/login_screen.dart';
import 'features/dashboard/dashboard_screen.dart';

class FiberTrackApp extends StatefulWidget {
  const FiberTrackApp({super.key});
  @override
  State<FiberTrackApp> createState() => _FiberTrackAppState();
}

class _FiberTrackAppState extends State<FiberTrackApp> {
  late final TokenStorage storage;
  late final ApiClient api;
  late final AuthController auth;
  @override
  void initState() {
    super.initState();
    storage = const TokenStorage();
    api = ApiClient(storage);
    auth = AuthController(api, storage)..addListener(_refresh);
    auth.restore();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    auth.removeListener(_refresh);
    auth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FiberTrack',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xff006a60), brightness: Brightness.light),
          useMaterial3: true,
          inputDecorationTheme:
              const InputDecorationTheme(border: OutlineInputBorder())),
      home: switch (auth.status) {
        AuthStatus.restoring => const _Splash(),
        AuthStatus.unauthenticated => LoginScreen(auth: auth, api: api),
        AuthStatus.authenticated => DashboardScreen(auth: auth, api: api)
      });
}

class _Splash extends StatelessWidget {
  const _Splash();
  @override
  Widget build(BuildContext c) => const Scaffold(
          body: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.hub_outlined, size: 80),
        SizedBox(height: 24),
        CircularProgressIndicator()
      ])));
}
