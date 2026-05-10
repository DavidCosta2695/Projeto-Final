import 'package:flutter/material.dart';
import '../data/mod.dart';
import 'pag_match.dart';

class ListaClientes extends StatelessWidget {
  const ListaClientes({super.key});

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
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: clientes.length,
        itemBuilder: (context, index) {
          final client = clientes[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(
                client.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Procura: ${client.desiredType} • Orçamento: €${client.maxBudget / 1000}k',
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
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Funcionalidade de adicionar cliente em breve!'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}