import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'dart:convert';
import '../modelos/propriedade.dart';
import '../data/bd.dart';
import 'add_propriedade.dart';
import 'configuracoes.dart';

final formatter = NumberFormat.currency(
  locale: 'pt_PT',
  symbol: '€ ',
  decimalDigits: 0,
);

class PropertyListPage extends StatefulWidget {
  const PropertyListPage({super.key});

  @override
  State<PropertyListPage> createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  final FirebaseService _firebaseService = FirebaseService();

  

  String? _filtroTipologia;
  String? _filtroGaragem;
  String? _filtroPiscina;
  RangeValues _valoresPreco = const RangeValues(0, 1000000); 

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
                      const Text('Filtros', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          
                          setModalState(() {
                            _filtroTipologia = null;
                            _filtroGaragem = null;
                            _filtroPiscina = null;
                            _valoresPreco = const RangeValues(0, 1000000);
                          });
                          setState(() {}); 
                        },
                        child: const Text('Limpar', style: TextStyle(color: Colors.red)),
                      )
                    ],
                  ),
                  const Divider(),
                  
                  
                  const SizedBox(height: 16),
                  Text(
                    'Preço: ${formatter.format(_valoresPreco.start)} - ${formatter.format(_valoresPreco.end)}', 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                  RangeSlider(
                    values: _valoresPreco,
                    min: 0,
                    max: 1000000,
                    divisions: 100, 
                    activeColor: const Color(0xFFC8A46B),
                    labels: RangeLabels(
                      formatter.format(_valoresPreco.start), 
                      formatter.format(_valoresPreco.end)
                    ),
                    onChanged: (RangeValues novosValores) {
                      setModalState(() => _valoresPreco = novosValores);
                    },
                  ),

                  
                  const SizedBox(height: 16),
                  const Text('Tipologia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                  const Text('Detalhes do Imóvel', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))
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
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900, foregroundColor: Colors.white, minimumSize: const Size(0, 50)),
                      icon: const Icon(Icons.delete), label: const Text('Eliminar'),
                      onPressed: () async {
                        final confirmar = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Eliminar Imóvel'),
                            content: const Text('Tens a certeza que queres eliminar este imóvel para sempre?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
                            ],
                          ),
                        );
                        if (confirmar == true && imovel.id != null) {
                          await _firebaseService.eliminarPropriedade(imovel.id!);
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Imóvel eliminado com sucesso!')));
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC8A46B), foregroundColor: Colors.black, minimumSize: const Size(0, 50)),
                      icon: const Icon(Icons.edit), label: const Text('Editar'),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddPropertyPage(propriedadeAEditar: imovel)));
                      },
                    ),
                  ),
                ],
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
        title: const Text('HouseConnect - Imóveis', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtrar Imóveis',
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
            ListTile(leading: const Icon(Icons.dashboard), title: const Text('Início / Dashboard'), onTap: () { Navigator.pop(context); Navigator.pushReplacementNamed(context, '/home'); }),
            ListTile(leading: const Icon(Icons.people), title: const Text('Gestão de Clientes'), onTap: () { Navigator.pop(context); Navigator.pushReplacementNamed(context, '/clientes'); }),
            ListTile(leading: const Icon(Icons.house, color: Color(0xFFC8A46B)), title: const Text('Gestão de Imóveis'), onTap: () => Navigator.pop(context)),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings), title: const Text('Configurações'),
              onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfiguracoesPage())); },
            ),
          ],
        ),
      ),
      
      body: StreamBuilder<List<Propriedade>>(
        stream: _firebaseService.listarPropriedades(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Erro ao carregar imóveis: ${snapshot.error}'));

          final listaDeImoveis = snapshot.data ?? [];

          
          final imoveisFiltrados = listaDeImoveis.where((imovel) {
            
            if (_filtroTipologia != null && imovel.tipologia != _filtroTipologia) return false;
            
            if (_filtroGaragem != null && imovel.garagem != _filtroGaragem) return false;
           
            if (_filtroPiscina != null && imovel.piscina != _filtroPiscina) return false;
            
            if (imovel.preco < _valoresPreco.start || imovel.preco > _valoresPreco.end) return false;
            
            return true; 
          }).toList();

          
          if (imoveisFiltrados.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Nenhum imóvel corresponde aos filtros.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  TextButton(
                    onPressed: () => setState(() {
                      _filtroTipologia = null;
                      _filtroGaragem = null;
                      _filtroPiscina = null;
                      _valoresPreco = const RangeValues(0, 1000000);
                    }),
                    child: const Text('Limpar Filtros'),
                  )
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: imoveisFiltrados.length,
            itemBuilder: (context, index) {
              final imovel = imoveisFiltrados[index];

              return Card(
                clipBehavior: Clip.antiAlias,
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 24.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  onTap: () => _mostrarDetalhes(context, imovel),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      imovel.imagemBase64 != null && imovel.imagemBase64!.isNotEmpty
                          ? Image.memory(
                              base64Decode(imovel.imagemBase64!),
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
                            Text(imovel.tipologia, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            Text(formatter.format(imovel.preco), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 22)),
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
      
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddPropertyPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}