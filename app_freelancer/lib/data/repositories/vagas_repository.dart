import '../models/vaga_model.dart';
import '../services/vagas_service.dart';

class VagasRepository {
  final VagasService _vagasService;

  VagasRepository({VagasService? vagasService})
      : _vagasService = vagasService ?? VagasService();

  /// Busca lista de vagas com filtros
  Future<List<VagaModel>> getVagas({
    String? cargo,
    double? latitude,
    double? longitude,
    double? raioKm,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    return await _vagasService.getVagas(
      cargo: cargo,
      latitude: latitude,
      longitude: longitude,
      raioKm: raioKm,
      status: status,
      page: page,
      limit: limit,
    );
  }

  /// Busca vaga por ID
  Future<VagaModel> getVagaById(String id) async {
    return await _vagasService.getVagaById(id);
  }

  /// Candidata-se a uma vaga
  Future<void> candidatarVaga(String vagaId) async {
    await _vagasService.candidatarVaga(vagaId);
  }

  /// Remove candidatura
  Future<void> removerCandidatura(String vagaId) async {
    await _vagasService.removerCandidatura(vagaId);
  }

  /// Busca candidaturas do usuário
  Future<List<VagaModel>> getMinhasCandidaturas() async {
    return await _vagasService.getMinhasCandidaturas();
  }

  /// Cria nova vaga (para empresas)
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
    return await _vagasService.criarVaga(
      cargo: cargo,
      descricao: descricao,
      valorHora: valorHora,
      dataInicio: dataInicio,
      dataFim: dataFim,
      numeroVagas: numeroVagas,
      endereco: endereco,
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Atualiza vaga existente
  Future<VagaModel> atualizarVaga({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    return await _vagasService.atualizarVaga(id: id, data: data);
  }

  /// Deleta vaga
  Future<void> deletarVaga(String id) async {
    await _vagasService.deletarVaga(id);
  }

  /// Busca vagas da empresa
  Future<List<VagaModel>> getMinhasVagas() async {
    return await _vagasService.getMinhasVagas();
  }

  /// Busca candidatos de uma vaga
  Future<List<dynamic>> getCandidatos(String vagaId) async {
    return await _vagasService.getCandidatos(vagaId);
  }

  /// Aceita candidato
  Future<void> aceitarCandidato({
    required String vagaId,
    required String usuarioId,
  }) async {
    await _vagasService.aceitarCandidato(
      vagaId: vagaId,
      usuarioId: usuarioId,
    );
  }

  /// Rejeita candidato
  Future<void> rejeitarCandidato({
    required String vagaId,
    required String usuarioId,
  }) async {
    await _vagasService.rejeitarCandidato(
      vagaId: vagaId,
      usuarioId: usuarioId,
    );
  }
}

