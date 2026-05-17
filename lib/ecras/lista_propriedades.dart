import 'package:flutter/material.dart';
import '../modelos/propriedade.dart';
import '../data/bd.dart';
import 'add_propriedade.dart';
import 'lista_clientes.dart';
import 'dart:convert';

class PropertyListPage extends StatefulWidget {
  const PropertyListPage({super.key});

  @override
  State<PropertyListPage> createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HouseConnect - Imóveis',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // --- Menu Lateral (Drawer) para navegação ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 8),
                  Text(
                    'Menu Principal',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Gestão de Clientes'),
              onTap: () {
                // Fecha o menu e muda para o ecrã de clientes
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ClientListPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.house),
              title: const Text('Gestão de Imóveis'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      // --- Fim do Drawer ---
      body: StreamBuilder<List<Propriedade>>(
        stream: _firebaseService.listarPropriedades(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar imóveis: ${snapshot.error}'),
            );
          }

          final listaDeImoveis = snapshot.data ?? [];

          if (listaDeImoveis.isEmpty) {
            return const Center(
              child: Text('Nenhum imóvel registado na nuvem.'),
            );
          }

          
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: listaDeImoveis.length,
            itemBuilder: (context, index) {
              final imovel = listaDeImoveis[index];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  // O leading (a imagem)
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: imovel.imagemBase64 != null && imovel.imagemBase64!.isNotEmpty
                        ? Image.memory(
                            base64Decode(imovel.imagemBase64!),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const CircleAvatar(child: Icon(Icons.house)),
                  ),
                  title: Text(
                    'Imóvel ${index + 1} - ${imovel.tipologia}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${imovel.localizacao}\n'
                    'Garagem: ${imovel.garagem} • Piscina: ${imovel.piscina}',
                  ),
                  trailing: Text(
                    '€ ${imovel.preco.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  isThreeLine: true,
                ), 
              ); 
            },
          ); 
        }, 
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddPropertyPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}