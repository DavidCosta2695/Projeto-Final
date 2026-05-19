class Cliente {
  final String? id; 
  final String nome;
  final String tipologia;
  final double orcamentoMaximo;
  final double orcamentoMinimo;
  final String localizacao;
  final String garagem;
  final String piscina;

  Cliente({
    this.id, 
    required this.nome,
    required this.tipologia,
    required this.orcamentoMaximo,
    required this.orcamentoMinimo,
    required this.localizacao,
    required this.garagem,
    required this.piscina,
  });

  Map<String, dynamic> toMap() {
    return {
      
      'nome': nome,
      'tipologia': tipologia,
      'orcamento_maximo': orcamentoMaximo,
      'orcamento_minimo': orcamentoMinimo,
      'localizacao': localizacao,
      'garagem': garagem,
      'piscina': piscina
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'], 
      nome: map['nome'] ?? '',
      tipologia: map['tipologia'] ?? '',
      orcamentoMaximo: (map['orcamento_maximo'] ?? 0.0).toDouble(),
      orcamentoMinimo: (map['orcamento_minimo'] ?? 0.0).toDouble(),
      localizacao: map['localizacao'] ?? '',
      garagem: map['garagem'] ?? 'Indiferente',
      piscina: map['piscina'] ?? 'Indiferente',
    );
  }
}