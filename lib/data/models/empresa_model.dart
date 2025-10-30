class EmpresaModel {
  final String id;
  final String nome;
  final String cnpj;
  final String descricao;
  final String? logo;
  final double latitude;
  final double longitude;
  final String endereco;
  final double? score;
  final int vagasAbertas;

  EmpresaModel({
    required this.id,
    required this.nome,
    required this.cnpj,
    required this.descricao,
    this.logo,
    required this.latitude,
    required this.longitude,
    required this.endereco,
    this.score,
    this.vagasAbertas = 0,
  });

  factory EmpresaModel.fromJson(Map<String, dynamic> json) {
    return EmpresaModel(
      id: json['id'] ?? '',
      nome: json['nome'] ?? '',
      cnpj: json['cnpj'] ?? '',
      descricao: json['descricao'] ?? '',
      logo: json['logo'],
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      endereco: json['endereco'] ?? '',
      score: json['score']?.toDouble(),
      vagasAbertas: json['vagas_abertas'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cnpj': cnpj,
      'descricao': descricao,
      'logo': logo,
      'latitude': latitude,
      'longitude': longitude,
      'endereco': endereco,
      'score': score,
      'vagas_abertas': vagasAbertas,
    };
  }

  bool get temVagasAbertas => vagasAbertas > 0;
}

