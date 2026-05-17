class Propriedade {
  final double preco;
  final String tipologia;
  final String localizacao;
  final String garagem;
  final String piscina;

  Propriedade({
    required this.preco,
    required this.tipologia,
    required this.localizacao,
    required this.garagem,
    required this.piscina,
  });

  Map<String, dynamic> toMap() {
    return {
      'preco': preco,
      'tipologia': tipologia,
      'localizacao': localizacao,
      'garagem': garagem,
      'piscina': piscina,
    };
  }

  factory Propriedade.fromMap(Map<String, dynamic> map) {
    return Propriedade(
      preco: (map['preco'] ?? 0.0).toDouble(),
      tipologia: map['tipologia'] ?? '',
      localizacao: map['localizacao'] ?? '',
      garagem: map['garagem'] ?? '',
      piscina: map['piscina'] ?? '',
    );
  }
}