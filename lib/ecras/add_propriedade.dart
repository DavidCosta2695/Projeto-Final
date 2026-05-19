import 'dart:io';
import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../modelos/propriedade.dart';
import '../data/bd.dart';

class AddPropertyPage extends StatefulWidget {
  final Propriedade? propriedadeAEditar; 

  const AddPropertyPage({super.key, this.propriedadeAEditar});

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
  
  File? _imagemSelecionada;
  String? _imagemEmTextoBase64;

  final List<String> _tipologias = ['T0', 'T1', 'T2', 'T3', 'T4', 'T5+'];
  final List<String> _opcoesSimNao = ['Sim', 'Nao'];

  @override
  void initState() {
    super.initState();
    if (widget.propriedadeAEditar != null) {
      final p = widget.propriedadeAEditar!;
      _localizacaoController.text = p.localizacao;
      _precoController.text = _formatarPrecoInicial(p.preco.toInt().toString());
      _tipologiaSelecionada = p.tipologia;
      _garagemSelecionada = p.garagem;
      _piscinaSelecionada = p.piscina;
      _imagemEmTextoBase64 = p.imagemBase64;
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

  Future<void> _escolherImagem(ImageSource fonte) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: fonte, 
      imageQuality: 50,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64String = base64Encode(bytes);

      setState(() {
        _imagemSelecionada = File(pickedFile.path);
        _imagemEmTextoBase64 = base64String;
      });
    }
  }

  void _mostrarMenuDeImagem() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Escolher da Galeria'),
              onTap: () {
                Navigator.of(context).pop();
                _escolherImagem(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tirar Fotografia'),
              onTap: () {
                Navigator.of(context).pop();
                _escolherImagem(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _guardarPropriedade() async {
    final localizacao = _localizacaoController.text.trim();
    final tipologia = _tipologiaSelecionada ?? '';
    final garagem = _garagemSelecionada ?? 'Nao';
    final piscina = _piscinaSelecionada ?? 'Nao';

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
      imagemBase64: _imagemEmTextoBase64,
    );

    try {
      if (widget.propriedadeAEditar != null) {
        
        await _firebaseService.atualizarPropriedade(widget.propriedadeAEditar!.id!, novaPropriedade);
      } else {
        
        await _firebaseService.guardarPropriedade(novaPropriedade);
      }
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
    
    Widget widgetImagem = const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
        SizedBox(height: 8),
        Text('Adicionar Fotografia', style: TextStyle(color: Colors.grey)),
      ],
    );

    if (_imagemSelecionada != null) {
      widgetImagem = Image.file(_imagemSelecionada!, fit: BoxFit.cover);
    } else if (_imagemEmTextoBase64 != null && _imagemEmTextoBase64!.isNotEmpty) {
      widgetImagem = Image.memory(base64Decode(_imagemEmTextoBase64!), fit: BoxFit.cover);
    }

    return Scaffold(
      appBar: AppBar(
        
        title: Text(widget.propriedadeAEditar != null ? 'Editar Imóvel' : 'Adicionar Novo Imóvel')
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _mostrarMenuDeImagem,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: widgetImagem,
                ),
              ),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: _precoController,
              decoration: const InputDecoration(labelText: 'Preço de Venda', prefixText: '€ '),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                PropertyCurrencyFormatter(),
              ],
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Tipologia do Imóvel'),
              initialValue: _tipologiaSelecionada,
              items: _tipologias.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => _tipologiaSelecionada = v),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _localizacaoController,
              decoration: const InputDecoration(labelText: 'Localização / Cidade'),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Possui Garagem?'),
              initialValue: _garagemSelecionada,
              items: _opcoesSimNao.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: (v) => setState(() => _garagemSelecionada = v),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Possui Piscina?'),
              initialValue: _piscinaSelecionada,
              items: _opcoesSimNao.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: (v) => setState(() => _piscinaSelecionada = v),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _guardarPropriedade,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              
              child: Text(
                widget.propriedadeAEditar != null ? 'Atualizar Imóvel' : 'Guardar Imóvel', 
                style: const TextStyle(fontSize: 16)
              ),
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