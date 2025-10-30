import '../models/avaliacao_model.dart';
import '../services/avaliacoes_service.dart';

class AvaliacoesRepository {
  final AvaliacoesService _avaliacoesService;

  AvaliacoesRepository({AvaliacoesService? avaliacoesService})
      : _avaliacoesService = avaliacoesService ?? AvaliacoesService();

  /// Busca avaliações de um usuário
  Future<List<AvaliacaoModel>> getAvaliacoes(String userId) async {
    return await _avaliacoesService.getAvaliacoes(userId);
  }

  /// Cria nova avaliação
  Future<AvaliacaoModel> criarAvaliacao({
    required String usuarioAvaliadoId,
    required int nota,
    required String comentario,
    String? vagaId,
  }) async {
    return await _avaliacoesService.criarAvaliacao(
      usuarioAvaliadoId: usuarioAvaliadoId,
      nota: nota,
      comentario: comentario,
      vagaId: vagaId,
    );
  }

  /// Busca média de avaliações
  Future<double> getMediaAvaliacoes(String userId) async {
    return await _avaliacoesService.getMediaAvaliacoes(userId);
  }

  /// Deleta avaliação
  Future<void> deletarAvaliacao(String avaliacaoId) async {
    await _avaliacoesService.deletarAvaliacao(avaliacaoId);
  }

  /// Reporta avaliação
  Future<void> reportarAvaliacao({
    required String avaliacaoId,
    required String motivo,
  }) async {
    await _avaliacoesService.reportarAvaliacao(
      avaliacaoId: avaliacaoId,
      motivo: motivo,
    );
  }
}

