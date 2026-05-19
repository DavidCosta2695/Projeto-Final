import 'package:flutter/material.dart';
import '../modelos/cliente.dart';
import '../modelos/propriedade.dart';
import '../data/bd.dart';
import 'dart:convert'; 
import 'package:intl/intl.dart';

final formatter = NumberFormat.currency(
  locale: 'pt_PT',
  symbol: '€ ',
  decimalDigits: 0,
);

class MatchPage extends StatefulWidget {
  final Cliente client;

  const MatchPage({super.key, required this.client});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  final FirebaseService _firebaseService = FirebaseService();

  
  void _mostrarDetalhes(BuildContext context, Propriedade imovel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Detalhes do Imóvel', 
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const Divider(height: 32),
              ListTile(
                leading: Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary, size: 30),
                title: const Text('Localização', style: TextStyle(color: Colors.grey)),
                subtitle: Text(imovel.localizacao, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              ),
              ListTile(
                leading: Icon(Icons.garage, color: Theme.of(context).colorScheme.primary, size: 30),
                title: const Text('Garagem', style: TextStyle(color: Colors.grey)),
                subtitle: Text(imovel.garagem, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              ),
              ListTile(
                leading: Icon(Icons.pool, color: Theme.of(context).colorScheme.primary, size: 30),
                title: const Text('Piscina', style: TextStyle(color: Colors.grey)),
                subtitle: Text(imovel.piscina, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check),
                  label: const Text('Entendido', style: TextStyle(fontSize: 16)),
                ),
              )
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matches para ${widget.client.nome}'),
      ),
      body: Column(
        children: [
          // Cabeçalho com o resumo do que o cliente procura
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
                    'Orçamento: ${formatter.format(widget.client.orcamentoMinimo)} - ${formatter.format(widget.client.orcamentoMaximo)}\n'
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
          
          // Lista de resultados do Match
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
                  padding: const EdgeInsets.all(16.0),
                  itemCount: propriedadesMatch.length,
                  itemBuilder: (context, index) {
                    final propriedade = propriedadesMatch[index];

                    
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 24.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: InkWell(
                        onTap: () => _mostrarDetalhes(context, propriedade),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            propriedade.imagemBase64 != null && propriedade.imagemBase64!.isNotEmpty
                                ? Image.memory(
                                    base64Decode(propriedade.imagemBase64!),
                                    height: 220,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 220,
                                    width: double.infinity,
                                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                    child: const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    propriedade.tipologia,
                                    style: const TextStyle(
                                      fontSize: 24, 
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    formatter.format(propriedade.preco),
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
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
          ),
        ],
      ),
    );
  }
}