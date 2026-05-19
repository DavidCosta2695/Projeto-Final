import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../modelos/cliente.dart';
import '../data/bd.dart';

class AddClientPage extends StatefulWidget {
  final Cliente? clienteAEditar; 

  const AddClientPage({super.key, this.clienteAEditar});

  @override
  State<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  final _nomeController = TextEditingController();
  final _orcamentoMinimoController = TextEditingController();
  final _orcamentoMaximoController = TextEditingController();
  final _localizacaoController = TextEditingController();

  final FirebaseService _firebaseService = FirebaseService();

  String? _tipologiaSelecionada;
  String? _garagemSelecionada;
  String? _piscinaSelecionada;

  final List<String> _tipologias = ['T0', 'T1', 'T2', 'T3', 'T4', 'T5+'];
  final List<String> _opcoesSimNao = ['Indiferente', 'Sim', 'Nao'];

  @override
  void initState() {
    super.initState();

    if (widget.clienteAEditar != null) {
      final c = widget.clienteAEditar!;
      _nomeController.text = c.nome;
      _localizacaoController.text = c.localizacao;
      _orcamentoMinimoController.text = _formatarPrecoInicial(c.orcamentoMinimo.toInt().toString());
      _orcamentoMaximoController.text = _formatarPrecoInicial(c.orcamentoMaximo.toInt().toString());
      _tipologiaSelecionada = c.tipologia;
      _garagemSelecionada = c.garagem;
      _piscinaSelecionada = c.piscina;
    }
  }

  String _formatarPrecoInicial(String texto) {
    if (texto.isEmpty) return texto;
    final int len = texto.length;
    final StringBuffer sb = StringBuffer();
    for (int i = 0; i < len; i++) {
      if (i > 0 && (len - i) % 3 == 0) sb.write(' ');
      sb.write(texto[i]);
    }
    return sb.toString();
  }

  void _guardarCliente() async {
    final nome = _nomeController.text.trim();
    final tipologia = _tipologiaSelecionada ?? '';
    final localizacao = _localizacaoController.text.trim();
    final garagem = _garagemSelecionada ?? 'Indiferente';
    final piscina = _piscinaSelecionada ?? 'Indiferente';

    final orcamentoMinimoTexto = _orcamentoMinimoController.text.replaceAll(' ', '');
    final orcamentoMaximoTexto = _orcamentoMaximoController.text.replaceAll(' ', '');

    final orcamentoMinimo = double.tryParse(orcamentoMinimoTexto) ?? 0.0;
    final orcamentoMaximo = double.tryParse(orcamentoMaximoTexto) ?? 0.0;

    if (nome.isEmpty || tipologia.isEmpty || localizacao.isEmpty || orcamentoMinimo <= 0 || orcamentoMaximo <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preenche todos os campos corretamente.')),
      );
      return;
    }

    if (orcamentoMinimo > orcamentoMaximo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O orçamento mínimo não pode ser superior ao máximo.')),
      );
      return;
    }

    final novoCliente = Cliente(
      nome: nome,
      tipologia: tipologia,
      orcamentoMinimo: orcamentoMinimo,
      orcamentoMaximo: orcamentoMaximo,
      localizacao: localizacao,
      garagem: garagem,
      piscina: piscina,
    );

    try {
      if (widget.clienteAEditar != null) {
        await _firebaseService.atualizarCliente(widget.clienteAEditar!.id!, novoCliente);
      } else {
        await _firebaseService.guardarCliente(novoCliente);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao guardar: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _orcamentoMinimoController.dispose();
    _orcamentoMaximoController.dispose();
    _localizacaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.clienteAEditar != null ? 'Editar Cliente' : 'Adicionar Novo Cliente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome do Cliente'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Tipologia Desejada'),
              initialValue: _tipologiaSelecionada,
              items: _tipologias.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => _tipologiaSelecionada = v),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _localizacaoController,
              decoration: const InputDecoration(labelText: 'Localização'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _orcamentoMinimoController,
              decoration: const InputDecoration(labelText: 'Orçamento Mínimo', prefixText: '€ '),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, CurrencySpaceFormatter()],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _orcamentoMaximoController,
              decoration: const InputDecoration(labelText: 'Orçamento Máximo', prefixText: '€ '),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, CurrencySpaceFormatter()],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Garagem'),
              initialValue: _garagemSelecionada,
              items: _opcoesSimNao.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: (v) => setState(() => _garagemSelecionada = v),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Piscina'),
              initialValue: _piscinaSelecionada,
              items: _opcoesSimNao.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: (v) => setState(() => _piscinaSelecionada = v),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _guardarCliente,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: Text(
                widget.clienteAEditar != null ? 'Atualizar Cliente' : 'Guardar Cliente',
                style: const TextStyle(fontSize: 16)
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencySpaceFormatter extends TextInputFormatter {
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