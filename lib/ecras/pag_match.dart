import 'package:flutter/material.dart';
import '../modelos/cliente.dart';
import '../modelos/propriedade.dart';
import '../data/bd.dart';
import 'dart:convert'; 

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
          // Cabeçalho com o perfil do cliente
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

                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: propriedadesMatch.length,
                  itemBuilder: (context, index) {
                    final propriedade = propriedadesMatch[index];

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: propriedade.imagemBase64 != null && propriedade.imagemBase64!.isNotEmpty
                              ? Image.memory(
                                  base64Decode(propriedade.imagemBase64!),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : const CircleAvatar(child: Icon(Icons.house)),
                        ),
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