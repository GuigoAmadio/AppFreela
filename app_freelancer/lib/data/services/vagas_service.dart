import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/vaga_model.dart';
import 'api_client.dart';

class VagasService {
  final ApiClient _apiClient;

  VagasService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Busca lista de vagas com filtros opcionais
  Future<List<VagaModel>> getVagas({
    String? cargo,
    double? latitude,
    double? longitude,
    double? raioKm,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (cargo != null) queryParameters['cargo'] = cargo;
      if (latitude != null) queryParameters['latitude'] = latitude;
      if (longitude != null) queryParameters['longitude'] = longitude;
      if (raioKm != null) queryParameters['raio'] = raioKm;
      if (status != null) queryParameters['status'] = status;

      final response = await _apiClient.get(
        ApiConstants.vagasEndpoint,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['vagas'] ?? response.data;
        return data.map((json) => VagaModel.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao buscar vagas');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao buscar vagas: ${e.message}');
    }
  }

  /// Busca uma vaga específica por ID
  Future<VagaModel> getVagaById(String id) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.vagaByIdEndpoint(id),
      );

      if (response.statusCode == 200) {
        return VagaModel.fromJson(response.data);
      } else {
        throw Exception('Falha ao buscar vaga');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao buscar vaga: ${e.message}');
    }
  }

  /// Candidata-se a uma vaga
  Future<void> candidatarVaga(String vagaId) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.candidatarVagaEndpoint(vagaId),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Falha ao candidatar-se à vaga');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception('Você já se candidatou a esta vaga');
      }
      throw Exception('Erro ao candidatar-se: ${e.message}');
    }
  }

  /// Remove candidatura de uma vaga
  Future<void> removerCandidatura(String vagaId) async {
    try {
      final response = await _apiClient.delete(
        ApiConstants.candidatarVagaEndpoint(vagaId),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Falha ao remover candidatura');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao remover candidatura: ${e.message}');
    }
  }

  /// Busca vagas nas quais o usuário se candidatou
  Future<List<VagaModel>> getMinhasCandidaturas() async {
    try {
      final response = await _apiClient.get('/candidaturas');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['candidaturas'] ?? response.data;
        return data.map((json) => VagaModel.fromJson(json['vaga'])).toList();
      } else {
        throw Exception('Falha ao buscar candidaturas');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao buscar candidaturas: ${e.message}');
    }
  }

  /// Cria uma nova vaga (para empresas)
  Future<VagaModel> criarVaga({
    required String cargo,
    required String descricao,
    required double valorHora,
    required DateTime dataInicio,
    required DateTime dataFim,
    required int numeroVagas,
    required String endereco,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.vagasEndpoint,
        data: {
          'cargo': cargo,
          'descricao': descricao,
          'valor_hora': valorHora,
          'data_inicio': dataInicio.toIso8601String(),
          'data_fim': dataFim.toIso8601String(),
          'numero_vagas': numeroVagas,
          'endereco': endereco,
          'latitude': latitude,
          'longitude': longitude,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return VagaModel.fromJson(response.data);
      } else {
        throw Exception('Falha ao criar vaga');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao criar vaga: ${e.message}');
    }
  }

  /// Atualiza uma vaga existente
  Future<VagaModel> atualizarVaga({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _apiClient.put(
        ApiConstants.vagaByIdEndpoint(id),
        data: data,
      );

      if (response.statusCode == 200) {
        return VagaModel.fromJson(response.data);
      } else {
        throw Exception('Falha ao atualizar vaga');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao atualizar vaga: ${e.message}');
    }
  }

  /// Deleta uma vaga
  Future<void> deletarVaga(String id) async {
    try {
      final response = await _apiClient.delete(
        ApiConstants.vagaByIdEndpoint(id),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Falha ao deletar vaga');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao deletar vaga: ${e.message}');
    }
  }

  /// Busca vagas criadas pela empresa do usuário
  Future<List<VagaModel>> getMinhasVagas() async {
    try {
      final response = await _apiClient.get('/empresas/minhas-vagas');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['vagas'] ?? response.data;
        return data.map((json) => VagaModel.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao buscar vagas');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao buscar vagas: ${e.message}');
    }
  }

  /// Busca candidatos de uma vaga
  Future<List<dynamic>> getCandidatos(String vagaId) async {
    try {
      final response = await _apiClient.get(
        '/vagas/$vagaId/candidatos',
      );

      if (response.statusCode == 200) {
        return response.data['candidatos'] ?? response.data;
      } else {
        throw Exception('Falha ao buscar candidatos');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao buscar candidatos: ${e.message}');
    }
  }

  /// Aceita um candidato para uma vaga
  Future<void> aceitarCandidato({
    required String vagaId,
    required String usuarioId,
  }) async {
    try {
      final response = await _apiClient.post(
        '/vagas/$vagaId/candidatos/$usuarioId/aceitar',
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Falha ao aceitar candidato');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao aceitar candidato: ${e.message}');
    }
  }

  /// Rejeita um candidato de uma vaga
  Future<void> rejeitarCandidato({
    required String vagaId,
    required String usuarioId,
  }) async {
    try {
      final response = await _apiClient.post(
        '/vagas/$vagaId/candidatos/$usuarioId/rejeitar',
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Falha ao rejeitar candidato');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao rejeitar candidato: ${e.message}');
    }
  }
}

