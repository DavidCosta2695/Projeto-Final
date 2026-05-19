import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'ecras/lista_clientes.dart';
import 'ecras/login.dart';
import 'servicos/auth_servico.dart';
import 'ecras/dashboard.dart';
import 'ecras/lista_propriedades.dart';

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
    final auth = AuthService();

    return MaterialApp(
      title: 'HouseConnect',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC8A46B),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 27, 26, 26),
        useMaterial3: true,
      ),

      initialRoute: auth.currentUser == null ? '/login' : '/home',

      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const DashboardPage(),        
        '/clientes': (context) => const ClientListPage(),   
        '/imoveis': (context) => const PropertyListPage(), 
      },
    );
  }
}