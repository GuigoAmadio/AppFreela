import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/vaga_model.dart';
import 'api_client.dart';

class FavoritosService {
  final ApiClient _apiClient;

  FavoritosService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Busca vagas favoritas
  Future<List<VagaModel>> getFavoritos() async {
    try {
      final response = await _apiClient.get('/favoritos');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['favoritos'] ?? response.data;
        return data.map((json) => VagaModel.fromJson(json['vaga'])).toList();
      }
      throw Exception('Falha ao buscar favoritos');
    } on DioException catch (e) {
      throw Exception('Erro ao buscar favoritos: ${e.message}');
    }
  }

  /// Adiciona vaga aos favoritos
  Future<void> addFavorito(String vagaId) async {
    try {
      await _apiClient.post(
        '/favoritos',
        data: {'vaga_id': vagaId},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception('Vaga já está nos favoritos');
      }
      throw Exception('Erro ao adicionar favorito: ${e.message}');
    }
  }

  /// Remove vaga dos favoritos
  Future<void> removeFavorito(String vagaId) async {
    try {
      await _apiClient.delete('/favoritos/$vagaId');
    } on DioException catch (e) {
      throw Exception('Erro ao remover favorito: ${e.message}');
    }
  }

  /// Verifica se vaga está nos favoritos
  Future<bool> isFavorito(String vagaId) async {
    try {
      final response = await _apiClient.get('/favoritos/$vagaId/check');
      return response.data['is_favorito'] ?? false;
    } on DioException catch (e) {
      throw Exception('Erro ao verificar favorito: ${e.message}');
    }
  }
}

