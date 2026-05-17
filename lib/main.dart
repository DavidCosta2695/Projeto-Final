import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'ecras/lista_clientes.dart'; 

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const HouseConnectApp());
}

class HouseConnectApp extends StatelessWidget {
  const HouseConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HouseConnect',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFC8A46B),
      brightness: Brightness.dark,
    ),

    scaffoldBackgroundColor: const Color(0xFF111111),

    useMaterial3: true,
  ),

  home: const ClientListPage(),
);
  }
}