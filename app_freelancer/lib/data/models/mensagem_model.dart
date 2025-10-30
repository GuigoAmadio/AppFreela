import 'package:equatable/equatable.dart';

class MensagemModel extends Equatable {
  final String id;
  final String conversaId;
  final String remetenteId;
  final String remetenteNome;
  final String? remetenteFoto;
  final String texto;
  final String? anexoUrl;
  final bool lida;
  final DateTime criadoEm;

  const MensagemModel({
    required this.id,
    required this.conversaId,
    required this.remetenteId,
    required this.remetenteNome,
    this.remetenteFoto,
    required this.texto,
    this.anexoUrl,
    required this.lida,
    required this.criadoEm,
  });

  factory MensagemModel.fromJson(Map<String, dynamic> json) {
    return MensagemModel(
      id: json['id'].toString(),
      conversaId: json['conversa_id'].toString(),
      remetenteId: json['remetente_id'].toString(),
      remetenteNome: json['remetente_nome'] ?? '',
      remetenteFoto: json['remetente_foto'],
      texto: json['texto'] ?? '',
      anexoUrl: json['anexo_url'],
      lida: json['lida'] ?? false,
      criadoEm: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversa_id': conversaId,
      'remetente_id': remetenteId,
      'remetente_nome': remetenteNome,
      'remetente_foto': remetenteFoto,
      'texto': texto,
      'anexo_url': anexoUrl,
      'lida': lida,
      'created_at': criadoEm.toIso8601String(),
    };
  }

  MensagemModel copyWith({
    String? id,
    String? conversaId,
    String? remetenteId,
    String? remetenteNome,
    String? remetenteFoto,
    String? texto,
    String? anexoUrl,
    bool? lida,
    DateTime? criadoEm,
  }) {
    return MensagemModel(
      id: id ?? this.id,
      conversaId: conversaId ?? this.conversaId,
      remetenteId: remetenteId ?? this.remetenteId,
      remetenteNome: remetenteNome ?? this.remetenteNome,
      remetenteFoto: remetenteFoto ?? this.remetenteFoto,
      texto: texto ?? this.texto,
      anexoUrl: anexoUrl ?? this.anexoUrl,
      lida: lida ?? this.lida,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }

  @override
  List<Object?> get props => [
        id,
        conversaId,
        remetenteId,
        remetenteNome,
        remetenteFoto,
        texto,
        anexoUrl,
        lida,
        criadoEm,
      ];
}

class ConversaModel extends Equatable {
  final String id;
  final String outroUsuarioId;
  final String outroUsuarioNome;
  final String? outroUsuarioFoto;
  final String? vagaId;
  final String? vagaTitulo;
  final MensagemModel? ultimaMensagem;
  final int naoLidas;
  final DateTime atualizadoEm;

  const ConversaModel({
    required this.id,
    required this.outroUsuarioId,
    required this.outroUsuarioNome,
    this.outroUsuarioFoto,
    this.vagaId,
    this.vagaTitulo,
    this.ultimaMensagem,
    required this.naoLidas,
    required this.atualizadoEm,
  });

  factory ConversaModel.fromJson(Map<String, dynamic> json) {
    return ConversaModel(
      id: json['id'].toString(),
      outroUsuarioId: json['outro_usuario_id'].toString(),
      outroUsuarioNome: json['outro_usuario_nome'] ?? '',
      outroUsuarioFoto: json['outro_usuario_foto'],
      vagaId: json['vaga_id']?.toString(),
      vagaTitulo: json['vaga_titulo'],
      ultimaMensagem: json['ultima_mensagem'] != null
          ? MensagemModel.fromJson(json['ultima_mensagem'])
          : null,
      naoLidas: json['nao_lidas'] ?? 0,
      atualizadoEm: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'outro_usuario_id': outroUsuarioId,
      'outro_usuario_nome': outroUsuarioNome,
      'outro_usuario_foto': outroUsuarioFoto,
      'vaga_id': vagaId,
      'vaga_titulo': vagaTitulo,
      'ultima_mensagem': ultimaMensagem?.toJson(),
      'nao_lidas': naoLidas,
      'updated_at': atualizadoEm.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        outroUsuarioId,
        outroUsuarioNome,
        outroUsuarioFoto,
        vagaId,
        vagaTitulo,
        ultimaMensagem,
        naoLidas,
        atualizadoEm,
      ];
}

