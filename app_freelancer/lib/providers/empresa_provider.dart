import 'package:flutter/foundation.dart';
import '../data/models/vaga_model.dart';
import '../data/repositories/vagas_repository.dart';

class EmpresaProvider with ChangeNotifier {
  final VagasRepository _repository;

  EmpresaProvider({VagasRepository? repository})
      : _repository = repository ?? VagasRepository();

  List<VagaModel> _minhasVagas = [];
  Map<String, List<dynamic>> _candidatosPorVaga = {};
  bool _isLoading = false;
  String? _error;

  List<VagaModel> get minhasVagas => _minhasVagas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Obtém candidatos de uma vaga específica
  List<dynamic> getCandidatos(String vagaId) {
    return _candidatosPorVaga[vagaId] ?? [];
  }

  /// Carrega vagas da empresa
  Future<void> loadMinhasVagas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _minhasVagas = await _repository.getMinhasVagas();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _minhasVagas = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cria uma nova vaga
  Future<bool> criarVaga({
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
      final novaVaga = await _repository.criarVaga(
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

      _minhasVagas.insert(0, novaVaga);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Atualiza uma vaga
  Future<bool> atualizarVaga({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final vagaAtualizada = await _repository.atualizarVaga(id: id, data: data);
      
      final index = _minhasVagas.indexWhere((vaga) => vaga.id == id);
      if (index != -1) {
        _minhasVagas[index] = vagaAtualizada;
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Deleta uma vaga
  Future<bool> deletarVaga(String id) async {
    try {
      await _repository.deletarVaga(id);
      _minhasVagas.removeWhere((vaga) => vaga.id == id);
      _candidatosPorVaga.remove(id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Carrega candidatos de uma vaga
  Future<void> loadCandidatos(String vagaId) async {
    try {
      final candidatos = await _repository.getCandidatos(vagaId);
      _candidatosPorVaga[vagaId] = candidatos;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Aceita um candidato
  Future<bool> aceitarCandidato({
    required String vagaId,
    required String usuarioId,
  }) async {
    try {
      await _repository.aceitarCandidato(
        vagaId: vagaId,
        usuarioId: usuarioId,
      );
      
      // Atualiza a lista de candidatos
      await loadCandidatos(vagaId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Rejeita um candidato
  Future<bool> rejeitarCandidato({
    required String vagaId,
    required String usuarioId,
  }) async {
    try {
      await _repository.rejeitarCandidato(
        vagaId: vagaId,
        usuarioId: usuarioId,
      );
      
      // Atualiza a lista de candidatos
      await loadCandidatos(vagaId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Obtém estatísticas de uma vaga
  Map<String, int> getVagaStats(String vagaId) {
    final candidatos = getCandidatos(vagaId);
    
    int pendentes = 0;
    int aceitos = 0;
    int rejeitados = 0;

    for (final candidato in candidatos) {
      final status = candidato['status']?.toString().toLowerCase();
      if (status == 'pendente') pendentes++;
      if (status == 'aceito') aceitos++;
      if (status == 'rejeitado') rejeitados++;
    }

    return {
      'total': candidatos.length,
      'pendentes': pendentes,
      'aceitos': aceitos,
      'rejeitados': rejeitados,
    };
  }

  /// Limpa o estado
  void clear() {
    _minhasVagas = [];
    _candidatosPorVaga = {};
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}

