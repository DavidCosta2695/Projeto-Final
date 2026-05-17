import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../servicos/auth_servico.dart';
import '../data/bd.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  final authService = AuthService();
  final FirebaseService _firebaseService = FirebaseService();
  
  User? utilizadorAtual;
  
  // Variáveis da Base de Dados (Firestore)
  String _nomePersonalizado = '';
  String? _imagemBase64;
  bool _aCarregar = true; 

  @override
  void initState() {
    super.initState();
    utilizadorAtual = authService.currentUser;
    _carregarPerfilDaNuvem();
  }

  // Vai ao Firestore buscar os dados extra
  Future<void> _carregarPerfilDaNuvem() async {
    if (utilizadorAtual != null) {
      final dados = await _firebaseService.obterPerfilUtilizador(utilizadorAtual!.uid);
      
      if (dados != null) {
        setState(() {
          _nomePersonalizado = dados['nome'] ?? '';
          _imagemBase64 = dados['imagemBase64'];
        });
      }
    }
    setState(() => _aCarregar = false);
  }

  // --- Função para alterar o NOME ---
  Future<void> _alterarNome() async {
    final controlador = TextEditingController(text: _nomePersonalizado);
    
    final novoNome = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterar Nome'),
        content: TextField(
          controller: controlador,
          decoration: const InputDecoration(
            labelText: 'O teu nome',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controlador.text),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (novoNome != null && novoNome.trim().isNotEmpty && utilizadorAtual != null) {
      setState(() {
        _nomePersonalizado = novoNome.trim();
        _aCarregar = true;
      });
      
      await _firebaseService.atualizarPerfilUtilizador(
        utilizadorAtual!.uid, 
        _nomePersonalizado, 
        _imagemBase64
      );
      
      setState(() => _aCarregar = false);
    }
  }

  
  Future<void> _escolherImagem(ImageSource fonte) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: fonte, 
      imageQuality: 50, 
      maxWidth: 800, 
      maxHeight: 800
    );

    if (pickedFile != null && utilizadorAtual != null) {
      setState(() => _aCarregar = true);

      final bytes = await pickedFile.readAsBytes();
      final base64String = base64Encode(bytes);

      setState(() {
        _imagemBase64 = base64String;
      });

      await _firebaseService.atualizarPerfilUtilizador(
        utilizadorAtual!.uid, 
        _nomePersonalizado, 
        _imagemBase64
      );

      setState(() => _aCarregar = false);
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
            
            if (_imagemBase64 != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remover Fotografia', style: TextStyle(color: Colors.red)),
                onTap: () async {
                  Navigator.of(context).pop();
                  setState(() {
                    _aCarregar = true;
                    _imagemBase64 = null;
                  });
                  await _firebaseService.atualizarPerfilUtilizador(
                    utilizadorAtual!.uid, 
                    _nomePersonalizado, 
                    null
                  );
                  setState(() => _aCarregar = false);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? imagemDoPerfil;
    if (_imagemBase64 != null && _imagemBase64!.isNotEmpty) {
      imagemDoPerfil = MemoryImage(base64Decode(_imagemBase64!));
    } else if (utilizadorAtual?.photoURL != null) {
      imagemDoPerfil = NetworkImage(utilizadorAtual!.photoURL!);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: _aCarregar 
        ? const Center(child: CircularProgressIndicator()) 
        : Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Perfil da Conta',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                       
                        GestureDetector(
                          onTap: _mostrarMenuDeImagem,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: const Color(0xFFC8A46B),
                                backgroundImage: imagemDoPerfil,
                                child: imagemDoPerfil == null 
                                    ? const Icon(Icons.person, color: Colors.white, size: 40) 
                                    : null,
                              ),
                              
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black87,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _nomePersonalizado.isEmpty 
                                    ? (utilizadorAtual?.displayName ?? 'Sem Nome Definido') 
                                    : _nomePersonalizado,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                utilizadorAtual?.email ?? 'Email não encontrado',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        
                        
                        IconButton(
                          icon: const Icon(Icons.edit, color: Color(0xFFC8A46B)),
                          onPressed: _alterarNome,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade800,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text('Terminar Sessão', style: TextStyle(fontSize: 16)),
                    onPressed: () async {
                      await authService.logout();
                      if (!context.mounted) return;
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }
}