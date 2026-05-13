import 'package:flutter/material.dart';
import '../modelos/cliente.dart';
import '../data/bd.dart';
import 'pag_match.dart';
import 'add_clientes.dart';

class ClientListPage extends StatefulWidget {
  const ClientListPage({super.key});

  @override
  State<ClientListPage> createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HouseConnect - Clientes', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

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
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.house),
              title: const Text('Gestão de Imóveis'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ecrã de imóveis em breve!')),
                );
              },
            ),
          ],
        ),
      ),
      
      body: StreamBuilder<List<Cliente>>(
        stream: _firebaseService.listarClientes(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
          }

          final clientesDaNuvem = snapshot.data ?? [];
          if (clientesDaNuvem.isEmpty) {
            return const Center(child: Text('Nenhum cliente registado na nuvem.'));
          }


          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: clientesDaNuvem.length,
            itemBuilder: (context, index) {
              final client = clientesDaNuvem[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(client.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Procura: ${client.desiredType} • Orçamento: €${client.maxBudget.toStringAsFixed(0)}'),
                  trailing: ElevatedButton.icon(
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Match'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MatchPage(client: client)),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddClientPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}