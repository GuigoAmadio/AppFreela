class UsuarioModel {
  final String id;
  final String nome;
  final String email;
  final String tipo; // 'freelancer' ou 'empresa'
  final String? telefone;
  final String? avatar;
  final double? score;
  final DateTime criadoEm;

  UsuarioModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.tipo,
    this.telefone,
    this.avatar,
    this.score,
    required this.criadoEm,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] ?? '',
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      tipo: json['tipo'] ?? 'freelancer',
      telefone: json['telefone'],
      avatar: json['avatar'],
      score: json['score']?.toDouble(),
      criadoEm: json['criado_em'] != null
          ? DateTime.parse(json['criado_em'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'tipo': tipo,
      'telefone': telefone,
      'avatar': avatar,
      'score': score,
      'criado_em': criadoEm.toIso8601String(),
    };
  }

  UsuarioModel copyWith({
    String? id,
    String? nome,
    String? email,
    String? tipo,
    String? telefone,
    String? avatar,
    double? score,
    DateTime? criadoEm,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      tipo: tipo ?? this.tipo,
      telefone: telefone ?? this.telefone,
      avatar: avatar ?? this.avatar,
      score: score ?? this.score,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }
}

