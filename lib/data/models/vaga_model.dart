class VagaModel {
  final String id;
  final String titulo;
  final String descricao;
  final String empresaId;
  final String empresaNome;
  final double preco;
  final DateTime data;
  final DateTime? dataLimite;
  final String status; // 'aberta', 'fechada', 'em_andamento'
  final int candidatos;
  final String? empresaLogo;

  VagaModel({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.empresaId,
    required this.empresaNome,
    required this.preco,
    required this.data,
    this.dataLimite,
    this.status = 'aberta',
    this.candidatos = 0,
    this.empresaLogo,
  });

  factory VagaModel.fromJson(Map<String, dynamic> json) {
    return VagaModel(
      id: json['id'] ?? '',
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'] ?? '',
      empresaId: json['empresa_id'] ?? '',
      empresaNome: json['empresa_nome'] ?? '',
      preco: (json['preco'] ?? 0).toDouble(),
      data: json['data'] != null
          ? DateTime.parse(json['data'])
          : DateTime.now(),
      dataLimite: json['data_limite'] != null
          ? DateTime.parse(json['data_limite'])
          : null,
      status: json['status'] ?? 'aberta',
      candidatos: json['candidatos'] ?? 0,
      empresaLogo: json['empresa_logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'empresa_id': empresaId,
      'empresa_nome': empresaNome,
      'preco': preco,
      'data': data.toIso8601String(),
      'data_limite': dataLimite?.toIso8601String(),
      'status': status,
      'candidatos': candidatos,
      'empresa_logo': empresaLogo,
    };
  }

  bool get isAberta => status == 'aberta';
  bool get isFechada => status == 'fechada';
  bool get isEmAndamento => status == 'em_andamento';
}

