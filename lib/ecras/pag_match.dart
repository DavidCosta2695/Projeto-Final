import 'package:flutter/material.dart';
import '../modelos/cliente.dart';
import '../data/mod.dart';

class MatchPage extends StatelessWidget {
  final Cliente client;

  const MatchPage({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    
    final propriedadesMatch = propriedades.where((propriedade) {
      return propriedade.type == client.desiredType &&
          propriedade.price <= client.maxBudget;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Matches para ${client.name}')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                const Icon(Icons.radar, size: 40, color: Colors.teal),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'A procurar imóveis tipo ${client.desiredType} até €${client.maxBudget / 1000}k...',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: propriedadesMatch.isEmpty
                ? const Center(
                    child: Text('Nenhum imóvel encontrado com este perfil.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: propriedadesMatch.length,
                    itemBuilder: (context, index) {
                      final propriedade = propriedadesMatch[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.house, size: 40),
                          title: Text(
                            propriedade.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${propriedade.location} • ${propriedade.type}',
                          ),
                          trailing: Text(
                            '€${propriedade.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}