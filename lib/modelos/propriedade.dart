class Propriedade {
  final double preco;
  final String tipologia;
  final String localizacao;
  final String area;
  final String garagem;
  final String piscina;

  Propriedade({
    required this.preco,
    required this.tipologia,
    required this.localizacao,
    required this.area,
    required this.garagem,
    required this.piscina,
  });

  factory Propriedade.fromMap(Map<String, dynamic> map) {
    return Propriedade(
      preco: (map['preco'] ?? 0.0).toDouble(),
      tipologia: map['tipologia'] ?? '',
      localizacao: map['localizacao'] ?? '',
      area: map['area'] ?? '',
      garagem: map['garagem'] ?? '',
      piscina: map['piscina'] ?? '',
    );
  }
}