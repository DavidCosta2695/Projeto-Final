import 'package:flutter/material.dart';
import 'ecras/lista_clientes.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const ListaClientes(),
    );
  }
}