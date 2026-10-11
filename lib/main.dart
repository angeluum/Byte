import 'package:device_preview/device_preview.dart';
import 'package:device_preview/presets.dart';
import 'package:flutter/material.dart';
import 'view/login.dart';
import 'view/cadastro.dart';
import 'view/esqueceu.dart';
import 'view/sobre.dart';

Future<void> main() async {
  DevicePreview.enable();
  runApp(const MyApp());
  await DevicePreview.maybeController?.applyPreset(DevicePresets.iPhone16);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Byte',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginView(),
        '/cadastro': (_) => const CadastroView(),
        '/esqueceu-senha': (_) => const EsqueceuView(),
        '/home': (_) => const Scaffold(body: Center(child: Text('Home'))),
        '/sobre': (_) => const SobreView(),
      },
    );
  }
}