import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/cliente.dart';
import '../modelos/propriedade.dart';

class FirebaseService {
  // Cria uma ligação direta à base de dados do Firestore
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Função para adicionar um cliente
  Future<void> guardarCliente(Cliente cliente) async {
    try {
      
    
      await _db.collection('clientes').add(cliente.toMap());
      print("Cliente guardado com sucesso no Firebase!");
    } catch (e) {
      print("Erro ao guardar cliente: $e");
    }
  }


  Stream<List<Cliente>> listarClientes() {
    return _db.collection('clientes').snapshots().map((snapshot) {
      
      return snapshot.docs.map((doc) => Cliente.fromMap(doc.data())).toList();
    });
  }
  Future<void> guardarPropriedade(Propriedade propriedade) async {
    try {
      
      await _db.collection('propriedades').add(propriedade.toMap());
      print("Propriedade guardada com sucesso no Firebase!");
    } catch (e) {
      print("Erro ao guardar propriedade: $e");
      rethrow; 
    }
  }
  Stream<List<Propriedade>> listarPropriedades() {
    return _db.collection('propriedades').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Propriedade.fromMap(doc.data())).toList();
    });
  }
  Future<void> atualizarPerfilUtilizador(String uid, String nome, String? imagemBase64) async {
    await _db.collection('utilizadores').doc(uid).set({
      'nome': nome,
      'imagemBase64': imagemBase64,
    }, SetOptions(merge: true)); 
  }

  
  Future<Map<String, dynamic>?> obterPerfilUtilizador(String uid) async {
    final doc = await _db.collection('utilizadores').doc(uid).get();
    if (doc.exists) {
      return doc.data();
    }
    return null; 
  }
}

