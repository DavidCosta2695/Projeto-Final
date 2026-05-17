import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../modelos/propriedade.dart';
import '../data/bd.dart';

class AddPropertyPage extends StatefulWidget {
  const AddPropertyPage({super.key});

  @override
  State<AddPropertyPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  final _precoController = TextEditingController();
  final _localizacaoController = TextEditingController();

  final FirebaseService _firebaseService = FirebaseService();

  String? _tipologiaSelecionada;
  String? _garagemSelecionada;
  String? _piscinaSelecionada;

  final List<String> _tipologias = ['T0', 'T1', 'T2', 'T3', 'T4', 'T5+'];
  final List<String> _opcoesSimNao = ['Sim', 'Nao']; // Imóveis reais normalmente não são "Indiferentes"

  void _guardarPropriedade() async {
    final localizacao = _localizacaoController.text.trim();
    final tipologia = _tipologiaSelecionada ?? '';
    final garagem = _garagemSelecionada ?? 'Nao';
    final piscina = _piscinaSelecionada ?? 'Nao';

    // Remove os espaços do preço formatado
    final precoTexto = _precoController.text.replaceAll(' ', '');
    final preco = double.tryParse(precoTexto) ?? 0.0;

    if (localizacao.isEmpty || tipologia.isEmpty || preco <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preenche todos os campos corretamente.')),
      );
      return;
    }

    final novaPropriedade = Propriedade(
      preco: preco,
      tipologia: tipologia,
      localizacao: localizacao,
      garagem: garagem,
      piscina: piscina,
    );

    try {
      await _firebaseService.guardarPropriedade(novaPropriedade);

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao guardar imóvel: $e')),
      );
    }
  }

  @override
  void dispose() {
    _precoController.dispose();
    _localizacaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Novo Imóvel'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
          
            TextField(
              controller: _precoController,
              decoration: const InputDecoration(
                labelText: 'Preço de Venda',
                prefixText: '€ ',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                PropertyCurrencyFormatter(),
              ],
            ),
            const SizedBox(height: 16),

            
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Tipologia do Imóvel'),
              value: _tipologiaSelecionada,
              items: _tipologias.map((tipologia) {
                return DropdownMenuItem<String>(
                  value: tipologia,
                  child: Text(tipologia),
                );
              }).toList(),
              onChanged: (novoValor) => setState(() => _tipologiaSelecionada = novoValor),
            ),
            const SizedBox(height: 16),

            
            TextField(
              controller: _localizacaoController,
              decoration: const InputDecoration(labelText: 'Localização / Cidade'),
            ),
            const SizedBox(height: 16),

            

            
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Possui Garagem?'),
              value: _garagemSelecionada,
              items: _opcoesSimNao.map((opcao) {
                return DropdownMenuItem<String>(
                  value: opcao,
                  child: Text(opcao),
                );
              }).toList(),
              onChanged: (novoValor) => setState(() => _garagemSelecionada = novoValor),
            ),
            const SizedBox(height: 16),

            // Dropdown de Piscina
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Possui Piscina?'),
              value: _piscinaSelecionada,
              items: _opcoesSimNao.map((opcao) {
                return DropdownMenuItem<String>(
                  value: opcao,
                  child: Text(opcao),
                );
              }).toList(),
              onChanged: (novoValor) => setState(() => _piscinaSelecionada = novoValor),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _guardarPropriedade,
              child: const Text('Guardar Imóvel'),
            ),
          ],
        ),
      ),
    );
  }
}


class PropertyCurrencyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    final int len = newValue.text.length;
    final StringBuffer sb = StringBuffer();
    for (int i = 0; i < len; i++) {
      if (i > 0 && (len - i) % 3 == 0) sb.write(' ');
      sb.write(newValue.text[i]);
    }
    return TextEditingValue(
      text: sb.toString(),
      selection: TextSelection.collapsed(offset: sb.length),
    );
  }
}