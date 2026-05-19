import 'package:flutter/material.dart';
import '../modelos/cliente.dart';
import '../modelos/propriedade.dart';
import '../data/bd.dart';
import 'configuracoes.dart'; 

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseService _firebaseService = FirebaseService();

  
  final List<String> _tipologiasGlobais = ['T0', 'T1', 'T2', 'T3', 'T4', 'T5+'];

  @override
  Widget build(BuildContext context) {
    const corTema = Color(0xFFC8A46B); 
  

    return Scaffold(
      appBar: AppBar(
        title: const Text('HouseConnect - Painel', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      
      // --- DRAWER ---
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
              leading: const Icon(Icons.dashboard, color: corTema),
              title: const Text('Início / Dashboard'),
              onTap: () => Navigator.pop(context), 
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Gestão de Clientes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/clientes');
              },
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
        builder: (context, clientSnapshot) {
          return StreamBuilder<List<Propriedade>>(
            stream: _firebaseService.listarPropriedades(),
            builder: (context, propertySnapshot) {
              
              
              if (clientSnapshot.connectionState == ConnectionState.waiting ||
                  propertySnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final clientes = clientSnapshot.data ?? [];
              final propriedades = propertySnapshot.data ?? [];

             
              int totalClientes = clientes.length;
              int totalImoveis = propriedades.length;

              
              Map<String, int> contagemClientesTipologia = {for (var t in _tipologiasGlobais) t: 0};
              for (var c in clientes) {
                if (contagemClientesTipologia.containsKey(c.tipologia)) {
                  contagemClientesTipologia[c.tipologia] = contagemClientesTipologia[c.tipologia]! + 1;
                }
              }

              Map<String, int> contagemImoveisTipologia = {for (var t in _tipologiasGlobais) t: 0};
              for (var p in propriedades) {
                if (contagemImoveisTipologia.containsKey(p.tipologia)) {
                  contagemImoveisTipologia[p.tipologia] = contagemImoveisTipologia[p.tipologia]! + 1;
                }
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Resumo Geral', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    
                    Row(
                      children: [
                        Expanded(
                          child: _construirCartaoTotal(
                            'Clientes', 
                            totalClientes.toString(), 
                            Icons.people, 
                            Colors.blue.shade700
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _construirCartaoTotal(
                            'Imóveis', 
                            totalImoveis.toString(), 
                            Icons.house, 
                            corTema
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    
                    const Text('Procura de Clientes por Tipologia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: _tipologiasGlobais.map((t) {
                            int qtd = contagemClientesTipologia[t] ?? 0;
                            double percentagem = totalClientes > 0 ? qtd / totalClientes : 0.0;
                            return _construirBarraEstatistica(t, qtd, percentagem, Colors.blue);
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    
                    const Text('Imóveis em Stock por Tipologia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: _tipologiasGlobais.map((t) {
                            int qtd = contagemImoveisTipologia[t] ?? 0;
                            double percentagem = totalImoveis > 0 ? qtd / totalImoveis : 0.0;
                            return _construirBarraEstatistica(t, qtd, percentagem, corTema);
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  
  Widget _construirCartaoTotal(String titulo, String valor, IconData icone, Color cor) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: cor.withOpacity(0.2),
              child: Icon(icone, color: cor),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                Text(valor, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  
  Widget _construirBarraEstatistica(String tipologia, int quantidade, double percentagem, Color corDaBarra) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(tipologia, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentagem,
                backgroundColor: Colors.grey.shade800,
                color: corDaBarra,
                minHeight: 10,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 30,
            alignment: Alignment.centerRight,
            child: Text(
              quantidade.toString(), 
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
            ),
          ),
        ],
      ),
    );
  }
}