import 'package:flutter/material.dart';
import '../modelos/cliente.dart';
import '../modelos/propriedade.dart';
import '../data/bd.dart';

class MatchPage extends StatefulWidget {
  final Cliente client;

  const MatchPage({super.key, required this.client});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matches para ${widget.client.nome}'),
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
                    'A procurar imóveis tipo ${widget.client.tipologia} em ${widget.client.localizacao}\n'
                    'Orçamento: €${widget.client.orcamentoMinimo.toStringAsFixed(0)} - €${widget.client.orcamentoMaximo.toStringAsFixed(0)}\n'
                    'Garagem: ${widget.client.garagem} • Piscina: ${widget.client.piscina}',
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
          
          // Lista de Matches 
          Expanded(
            child: StreamBuilder<List<Propriedade>>(
              stream: _firebaseService.listarPropriedades(),
              builder: (context, snapshot) {
                
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar imóveis: ${snapshot.error}'));
                }

                final todasPropriedades = snapshot.data ?? [];

                
                final propriedadesMatch = todasPropriedades.where((propriedade) {
                  final tipologiaOk = propriedade.tipologia == widget.client.tipologia;
                  final precoOk = propriedade.preco >= widget.client.orcamentoMinimo &&
                                  propriedade.preco <= widget.client.orcamentoMaximo;
                  final localizacaoOk = propriedade.localizacao.toLowerCase() == widget.client.localizacao.toLowerCase();
                  final garagemOk = widget.client.garagem == 'Indiferente' || propriedade.garagem == widget.client.garagem;
                  final piscinaOk = widget.client.piscina == 'Indiferente' || propriedade.piscina == widget.client.piscina;

                  return tipologiaOk && precoOk && localizacaoOk && garagemOk && piscinaOk;
                }).toList();

                
                if (propriedadesMatch.isEmpty) {
                  return const Center(
                    child: Text('Nenhum imóvel encontrado na nuvem com este perfil.'),
                  );
                }

                // Se houver matches, desenha a lista
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: propriedadesMatch.length,
                  itemBuilder: (context, index) {
                    final propriedade = propriedadesMatch[index];

                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.house, size: 40),
                        title: Text(
                          'Imóvel ${index + 1} - ${propriedade.tipologia}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${propriedade.localizacao}\n'
                          'Garagem: ${propriedade.garagem} • Piscina: ${propriedade.piscina}',
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}