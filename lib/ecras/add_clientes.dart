import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../modelos/cliente.dart';
import '../data/mod.dart'; 
import '../data/bd.dart'; 

class AddClientPage extends StatefulWidget {
  const AddClientPage({super.key});

  @override
  State<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();

  
  final FirebaseService _firebaseService = FirebaseService();

  String? _selectedType;
  final List<String> _tipologias = ['T0', 'T1', 'T2', 'T3', 'T4', 'T5+'];

  
  void _saveClient() async {
    final name = _nameController.text;
    final type = _selectedType ?? '';

    final budgetText = _budgetController.text.replaceAll(' ', '');
    final budget = double.tryParse(budgetText) ?? 0.0;

    if (name.isNotEmpty && type.isNotEmpty && budget > 0) {
      final novoCliente = Cliente(
        name: name,
        desiredType: type,
        maxBudget: budget,
      );

      
      try {
        // Envia para o Firebase e espera que termine
        await _firebaseService.guardarCliente(novoCliente);

        // Verifica se o ecrã ainda está aberto antes de voltar atrás
        if (!mounted) return;

        // Se gravou com sucesso, volta para a lista
        Navigator.pop(context, true);
      } catch (e) {
        // Se a net falhar ou houver erro, avisa o utilizador
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao guardar: $e')),
        );
      }
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preenche todos os campos corretamente.')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Novo Cliente'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome do Cliente'),
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Tipologia Desejada'),
              value: _selectedType,
              items: _tipologias.map((String tipologia) {
                return DropdownMenuItem<String>(
                  value: tipologia,
                  child: Text(tipologia),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedType = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _budgetController,
              decoration: const InputDecoration(
                labelText: 'Orçamento Máximo',
                prefixText: '€ ', 
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, 
                CurrencySpaceFormatter(), 
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveClient,
              child: const Text('Guardar Cliente'),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencySpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final int newTextLength = newValue.text.length;
    final StringBuffer newText = StringBuffer();

    for (int i = 0; i < newTextLength; i++) {
      if (i > 0 && (newTextLength - i) % 3 == 0) {
        newText.write(' '); 
      }
      newText.write(newValue.text[i]);
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}