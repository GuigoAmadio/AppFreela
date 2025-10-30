class AvaliacaoModel {
  final String id;
  final String autorId;
  final String autorNome;
  final String? autorAvatar;
  final String avaliadoId;
  final double nota; // 1-5
  final String? comentario;
  final DateTime criadaEm;

  AvaliacaoModel({
    required this.id,
    required this.autorId,
    required this.autorNome,
    this.autorAvatar,
    required this.avaliadoId,
    required this.nota,
    this.comentario,
    required this.criadaEm,
  });

  factory AvaliacaoModel.fromJson(Map<String, dynamic> json) {
    return AvaliacaoModel(
      id: json['id'] ?? '',
      autorId: json['autor_id'] ?? '',
      autorNome: json['autor_nome'] ?? '',
      autorAvatar: json['autor_avatar'],
      avaliadoId: json['avaliado_id'] ?? '',
      nota: (json['nota'] ?? 0).toDouble(),
      comentario: json['comentario'],
      criadaEm: json['criada_em'] != null
          ? DateTime.parse(json['criada_em'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'autor_id': autorId,
      'autor_nome': autorNome,
      'autor_avatar': autorAvatar,
      'avaliado_id': avaliadoId,
      'nota': nota,
      'comentario': comentario,
      'criada_em': criadaEm.toIso8601String(),
    };
  }
}

