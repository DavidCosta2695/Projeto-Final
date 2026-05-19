import 'package:flutter/material.dart';
import '../modelos/cliente.dart';
import '../data/bd.dart';
import 'pag_match.dart';
import 'add_clientes.dart';
import 'lista_propriedades.dart';
import 'configuracoes.dart';

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
        title: const Text(
          'HouseConnect - Clientes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.inversePrimary),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('HouseConnect', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('Menu de Navegação', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Início / Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home'); // Vai para o dashboard
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Color(0xFFC8A46B)),
              title: const Text('Gestão de Clientes'),
              onTap: () => Navigator.pop(context), // Já está aqui, só fecha
            ),
            ListTile(
              leading: const Icon(Icons.house),
              title: const Text('Gestão de Imóveis'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/imoveis');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ConfiguracoesPage()),
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
            return Center(
              child: Text('Erro ao carregar dados: ${snapshot.error}'),
            );
          }

          final clientesDaNuvem = snapshot.data ?? [];

          if (clientesDaNuvem.isEmpty) {
            return const Center(
              child: Text('Nenhum cliente registado na nuvem.'),
            );
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
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(
                    client.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Procura: ${client.tipologia} • ${client.localizacao}\n'
                    'Orçamento: €${client.orcamentoMinimo.toStringAsFixed(0)} - €${client.orcamentoMaximo.toStringAsFixed(0)}\n'
                    'Garagem: ${client.garagem} • Piscina: ${client.piscina}',
                  ),
                  trailing: ElevatedButton.icon(
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Match'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MatchPage(client: client),
                        ),
                      );
                    },
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
          MaterialPageRoute(builder: (context) => const AddClientPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}