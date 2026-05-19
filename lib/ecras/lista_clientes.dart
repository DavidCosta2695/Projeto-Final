import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../modelos/cliente.dart';
import '../data/bd.dart';
import 'pag_match.dart';
import 'add_clientes.dart';
import 'configuracoes.dart';


final formatter = NumberFormat.currency(
  locale: 'pt_PT',
  symbol: '€ ',
  decimalDigits: 0,
);

class ClientListPage extends StatefulWidget {
  const ClientListPage({super.key});

  @override
  State<ClientListPage> createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  final FirebaseService _firebaseService = FirebaseService();

  
  void _confirmarEliminacao(BuildContext context, Cliente cliente) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Cliente'),
        content: Text('Tens a certeza que queres eliminar o cliente ${cliente.nome}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true && cliente.id != null) {
      await _firebaseService.eliminarCliente(cliente.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cliente eliminado com sucesso!')),
      );
    }
  }

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
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Color(0xFFC8A46B)),
              title: const Text('Gestão de Clientes'),
              onTap: () => Navigator.pop(context),
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
            return Center(child: Text('Erro ao carregar dados: ${snapshot.error}'));
          }

          final clientesDaNuvem = snapshot.data ?? [];

          if (clientesDaNuvem.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Ainda não tens clientes registados.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: clientesDaNuvem.length,
            itemBuilder: (context, index) {
              final client = clientesDaNuvem[index];
              
              final letraAvatar = client.nome.isNotEmpty ? client.nome[0].toUpperCase() : '?';

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: const Color(0xFFC8A46B).withOpacity(0.2),
                            foregroundColor: const Color(0xFFC8A46B),
                            child: Text(letraAvatar, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              client.nome,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, color: Colors.grey),
                            onSelected: (valor) {
                              if (valor == 'editar') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddClientPage(clienteAEditar: client)),
                                );
                              } else if (valor == 'eliminar') {
                                _confirmarEliminacao(context, client);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: 'editar', child: Text('Editar')),
                              const PopupMenuItem(value: 'eliminar', child: Text('Eliminar', style: TextStyle(color: Colors.red))),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                     
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          Chip(
                            label: Text('${client.tipologia} • ${client.localizacao}'),
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            side: BorderSide.none,
                          ),
                          Chip(
                            label: Text('${formatter.format(client.orcamentoMinimo)} - ${formatter.format(client.orcamentoMaximo)}'),
                            backgroundColor: Colors.green.withOpacity(0.1),
                            side: BorderSide.none,
                          ),
                          if (client.garagem != 'Indiferente')
                            Chip(
                              avatar: const Icon(Icons.garage, size: 16),
                              label: Text(client.garagem),
                              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                              side: BorderSide.none,
                            ),
                          if (client.piscina != 'Indiferente')
                            Chip(
                              avatar: const Icon(Icons.pool, size: 16),
                              label: Text(client.piscina),
                              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                              side: BorderSide.none,
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC8A46B), 
                            foregroundColor: Colors.black,
                          ),
                          icon: const Icon(Icons.auto_awesome),
                          label: const Text('Procurar Match', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MatchPage(client: client)),
                            );
                          },
                        ),
                      ),
                    ],
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