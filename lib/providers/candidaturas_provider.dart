import 'package:flutter/foundation.dart';
import '../data/models/vaga_model.dart';
import '../data/repositories/vagas_repository.dart';

class CandidaturasProvider with ChangeNotifier {
  final VagasRepository _repository;

  CandidaturasProvider({VagasRepository? repository})
      : _repository = repository ?? VagasRepository();

  List<VagaModel> _candidaturas = [];
  bool _isLoading = false;
  String? _error;

  List<VagaModel> get candidaturas => _candidaturas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Filtros por status
  List<VagaModel> get pendentes =>
      _candidaturas.where((v) => v.statusCandidatura == 'pendente').toList();
  List<VagaModel> get aceitas =>
      _candidaturas.where((v) => v.statusCandidatura == 'aceito').toList();
  List<VagaModel> get rejeitadas =>
      _candidaturas.where((v) => v.statusCandidatura == 'rejeitado').toList();

  /// Carrega candidaturas do usuário
  Future<void> loadCandidaturas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _candidaturas = await _repository.getMinhasCandidaturas();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _candidaturas = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Candidata-se a uma vaga
  Future<bool> candidatar(String vagaId) async {
    try {
      await _repository.candidatarVaga(vagaId);
      // Recarrega as candidaturas
      await loadCandidaturas();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Remove candidatura
  Future<bool> removerCandidatura(String vagaId) async {
    try {
      await _repository.removerCandidatura(vagaId);
      _candidaturas.removeWhere((vaga) => vaga.id == vagaId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Verifica se usuário já se candidatou a uma vaga
  bool isCandidatado(String vagaId) {
    return _candidaturas.any((vaga) => vaga.id == vagaId);
  }

  /// Obtém status da candidatura para uma vaga
  String? getStatusCandidatura(String vagaId) {
    final vaga = _candidaturas.firstWhere(
      (v) => v.id == vagaId,
      orElse: () => VagaModel(
        id: '',
        cargo: '',
        descricao: '',
        valorHora: 0,
        dataInicio: DateTime.now(),
        dataFim: DateTime.now(),
        numeroVagas: 0,
        endereco: '',
        latitude: 0,
        longitude: 0,
        empresaId: '',
        empresaNome: '',
        status: '',
        criadoEm: DateTime.now(),
      ),
    );
    return vaga.id.isEmpty ? null : vaga.statusCandidatura;
  }

  /// Limpa o estado
  void clear() {
    _candidaturas = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}

