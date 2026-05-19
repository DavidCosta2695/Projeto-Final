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

  String? _filtroTipologia;
  String? _filtroGaragem;
  String? _filtroPiscina;
  RangeValues _valoresOrcamento = const RangeValues(0, 1000000); // De 0€ a 1 Milhão de orçamento

  final List<String> _tipologias = ['Todas', 'T0', 'T1', 'T2', 'T3', 'T4', 'T5+'];
  final List<String> _opcoesSimNao = ['Indiferente', 'Sim', 'Nao'];


  void _abrirFiltros() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Filtros de Clientes', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          
                          setModalState(() {
                            _filtroTipologia = null;
                            _filtroGaragem = null;
                            _filtroPiscina = null;
                            _valoresOrcamento = const RangeValues(0, 1000000);
                          });
                          setState(() {}); // Atualiza a lista em segundo plano
                        },
                        child: const Text('Limpar', style: TextStyle(color: Colors.red)),
                      )
                    ],
                  ),
                  const Divider(),
                  
                  
                  const SizedBox(height: 16),
                  Text(
                    'Orçamento do Cliente: ${formatter.format(_valoresOrcamento.start)} - ${formatter.format(_valoresOrcamento.end)}', 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                  RangeSlider(
                    values: _valoresOrcamento,
                    min: 0,
                    max: 1000000,
                    divisions: 100, 
                    activeColor: const Color(0xFFC8A46B),
                    labels: RangeLabels(
                      formatter.format(_valoresOrcamento.start), 
                      formatter.format(_valoresOrcamento.end)
                    ),
                    onChanged: (RangeValues novosValores) {
                      setModalState(() => _valoresOrcamento = novosValores);
                    },
                  ),

                  
                  const SizedBox(height: 16),
                  const Text('Tipologia Desejada', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    children: _tipologias.map((tipo) {
                      final isSelected = _filtroTipologia == tipo || (tipo == 'Todas' && _filtroTipologia == null);
                      return ChoiceChip(
                        label: Text(tipo),
                        selected: isSelected,
                        selectedColor: const Color(0xFFC8A46B).withOpacity(0.3),
                        onSelected: (bool selected) {
                          setModalState(() => _filtroTipologia = (tipo == 'Todas' ? null : tipo));
                        },
                      );
                    }).toList(),
                  ),

                  
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Garagem', style: TextStyle(fontWeight: FontWeight.bold)),
                            DropdownButton<String>(
                              isExpanded: true,
                              value: _filtroGaragem ?? 'Indiferente',
                              items: _opcoesSimNao.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
                              onChanged: (val) => setModalState(() => _filtroGaragem = val == 'Indiferente' ? null : val),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Piscina', style: TextStyle(fontWeight: FontWeight.bold)),
                            DropdownButton<String>(
                              isExpanded: true,
                              value: _filtroPiscina ?? 'Indiferente',
                              items: _opcoesSimNao.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
                              onChanged: (val) => setModalState(() => _filtroPiscina = val == 'Indiferente' ? null : val),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC8A46B),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context); 
                      },
                      child: const Text('Aplicar Filtros', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            );
          }
        );
      }
    );
  }


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
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtrar Clientes',
            onPressed: _abrirFiltros,
          ),
        ],
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

          
          final clientesFiltrados = clientesDaNuvem.where((client) {
            
            if (_filtroTipologia != null && client.tipologia != _filtroTipologia) return false;
            
            if (_filtroGaragem != null && client.garagem != _filtroGaragem) return false;
            
            if (_filtroPiscina != null && client.piscina != _filtroPiscina) return false;
           
            if (client.orcamentoMinimo < _valoresOrcamento.start || client.orcamentoMaximo > _valoresOrcamento.end) return false;
            
            return true;
          }).toList();

         
          if (clientesFiltrados.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Nenhum cliente corresponde aos filtros.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  TextButton(
                    onPressed: () => setState(() {
                      _filtroTipologia = null;
                      _filtroGaragem = null;
                      _filtroPiscina = null;
                      _valoresOrcamento = const RangeValues(0, 1000000);
                    }),
                    child: const Text('Limpar Filtros'),
                  )
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: clientesFiltrados.length,
            itemBuilder: (context, index) {
              final client = clientesFiltrados[index];
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
                              label: Text('Garagem: ${client.garagem}'),
                              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                              side: BorderSide.none,
                            ),
                          if (client.piscina != 'Indiferente')
                            Chip(
                              avatar: const Icon(Icons.pool, size: 16),
                              label: Text('Piscina: ${client.piscina}'),
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