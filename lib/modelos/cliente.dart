class Cliente {
  final String name;
  final String desiredType;
  final double maxBudget;

  Cliente({
    required this.name,
    required this.desiredType,
    required this.maxBudget,
  });

Map<String, dynamic> toMap() {
    return {'nome': name, 'tipologia': desiredType, 'orcamento': maxBudget};
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      name: map['nome'] ?? '',
      desiredType: map['tipologia'] ?? '',
      maxBudget: (map['orcamento'] ?? 0.0).toDouble(),
    );
  }
}