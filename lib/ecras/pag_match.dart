import 'package:flutter/material.dart';
import '../modelos/cliente.dart';
import '../data/mod.dart';

class MatchPage extends StatelessWidget {
  final Cliente client;

  const MatchPage({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    final propriedadesMatch = propriedades.where((propriedade) {
      final tipologiaOk = propriedade.tipologia == client.tipologia;

      final precoOk = propriedade.preco >= client.orcamentoMinimo &&
          propriedade.preco <= client.orcamentoMaximo;

      final localizacaoOk =
          propriedade.localizacao.toLowerCase() ==
              client.localizacao.toLowerCase();

      final garagemOk = client.garagem == 'Indiferente' ||
          propriedade.garagem == client.garagem;

      final piscinaOk = client.piscina == 'Indiferente' ||
          propriedade.piscina == client.piscina;

      return tipologiaOk &&
          precoOk &&
          localizacaoOk &&
          garagemOk &&
          piscinaOk;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Matches para ${client.nome}'),
      ),
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
                    'A procurar imóveis tipo ${client.tipologia} em ${client.localizacao}\n'
                    'Orçamento: €${client.orcamentoMinimo.toStringAsFixed(0)} - €${client.orcamentoMaximo.toStringAsFixed(0)}\n'
                    'Garagem: ${client.garagem} • Piscina: ${client.piscina}',
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
                            'Imóvel ${index + 1} - ${propriedade.tipologia}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${propriedade.localizacao}\n'
                            'Área: ${propriedade.area} m² • Garagem: ${propriedade.garagem} • Piscina: ${propriedade.piscina}',
                          ),
                          trailing: Text(
                            '€${propriedade.preco.toStringAsFixed(0)}',
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
                  ),
          ),
        ],
      ),
    );
  }
}