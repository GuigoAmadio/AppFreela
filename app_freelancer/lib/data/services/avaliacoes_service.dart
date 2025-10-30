import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/avaliacao_model.dart';
import 'api_client.dart';

class AvaliacoesService {
  final ApiClient _apiClient;

  AvaliacoesService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Busca avaliações de um usuário
  Future<List<AvaliacaoModel>> getAvaliacoes(String userId) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.avaliacoesEndpoint(userId),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['avaliacoes'] ?? response.data;
        return data.map((json) => AvaliacaoModel.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao buscar avaliações');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao buscar avaliações: ${e.message}');
    }
  }

  /// Cria uma nova avaliação
  Future<AvaliacaoModel> criarAvaliacao({
    required String usuarioAvaliadoId,
    required int nota,
    required String comentario,
    String? vagaId,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.criarAvaliacaoEndpoint,
        data: {
          'usuario_avaliado_id': usuarioAvaliadoId,
          'nota': nota,
          'comentario': comentario,
          if (vagaId != null) 'vaga_id': vagaId,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return AvaliacaoModel.fromJson(response.data);
      } else {
        throw Exception('Falha ao criar avaliação');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data['message'] ?? 'Dados inválidos');
      }
      throw Exception('Erro ao criar avaliação: ${e.message}');
    }
  }

  /// Busca média de avaliações de um usuário
  Future<double> getMediaAvaliacoes(String userId) async {
    try {
      final response = await _apiClient.get(
        '/avaliacoes/$userId/media',
      );

      if (response.statusCode == 200) {
        return (response.data['media'] ?? 0.0).toDouble();
      } else {
        throw Exception('Falha ao buscar média');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao buscar média: ${e.message}');
    }
  }

  /// Deleta uma avaliação
  Future<void> deletarAvaliacao(String avaliacaoId) async {
    try {
      final response = await _apiClient.delete(
        '/avaliacoes/$avaliacaoId',
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Falha ao deletar avaliação');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao deletar avaliação: ${e.message}');
    }
  }

  /// Reporta uma avaliação inapropriada
  Future<void> reportarAvaliacao({
    required String avaliacaoId,
    required String motivo,
  }) async {
    try {
      await _apiClient.post(
        '/avaliacoes/$avaliacaoId/reportar',
        data: {'motivo': motivo},
      );
    } on DioException catch (e) {
      throw Exception('Erro ao reportar avaliação: ${e.message}');
    }
  }
}

