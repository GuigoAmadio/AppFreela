import 'package:flutter/foundation.dart';
import '../data/models/vaga_model.dart';
import '../data/mock/mock_data.dart';

/// Provider de vagas com dados mockup para testes
class MockVagasProvider with ChangeNotifier {
  List<VagaModel> _vagas = [];
  bool _isLoading = false;
  String? _error;

  List<VagaModel> get vagas => _vagas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Carrega vagas mockup
  Future<void> loadVagas({
    String? cargo,
    double? latitude,
    double? longitude,
    double? raioKm,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Simula delay de rede
    await Future.delayed(const Duration(seconds: 1));

    // Carrega dados mockup
    _vagas = List.from(MockData.vagas);

    // Aplica filtros se fornecidos
    if (cargo != null && cargo.isNotEmpty) {
      _vagas = _vagas.where((v) => 
        v.cargo.toLowerCase().contains(cargo.toLowerCase())
      ).toList();
    }

    if (raioKm != null && latitude != null && longitude != null) {
      _vagas = _vagas.where((v) {
        final distancia = v.distanciaKm ?? 0;
        return distancia <= raioKm;
      }).toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Busca vaga por ID
  Future<VagaModel?> getVagaById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      return _vagas.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Candidata-se a vaga
  Future<bool> candidatarVaga(String vagaId) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simula sucesso
    return true;
  }

  /// Remove candidatura
  Future<bool> removerCandidatura(String vagaId) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simula sucesso
    return true;
  }

  /// Cria nova vaga
  Future<bool> criarVaga(VagaModel vaga) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _vagas.insert(0, vaga);
    _isLoading = false;
    notifyListeners();

    return true;
  }

  /// Atualiza vaga
  Future<bool> atualizarVaga(String id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final index = _vagas.indexWhere((v) => v.id == id);
    if (index != -1) {
      // Atualiza a vaga
      final vagaAtual = _vagas[index];
      _vagas[index] = VagaModel(
        id: vagaAtual.id,
        cargo: data['cargo'] ?? vagaAtual.cargo,
        descricao: data['descricao'] ?? vagaAtual.descricao,
        valorHora: data['valor_hora'] ?? vagaAtual.valorHora,
        dataInicio: data['data_inicio'] ?? vagaAtual.dataInicio,
        dataFim: data['data_fim'] ?? vagaAtual.dataFim,
        numeroVagas: data['numero_vagas'] ?? vagaAtual.numeroVagas,
        endereco: data['endereco'] ?? vagaAtual.endereco,
        latitude: data['latitude'] ?? vagaAtual.latitude,
        longitude: data['longitude'] ?? vagaAtual.longitude,
        empresaId: vagaAtual.empresaId,
        empresaNome: vagaAtual.empresaNome,
        empresaFoto: vagaAtual.empresaFoto,
        status: vagaAtual.status,
        criadoEm: vagaAtual.criadoEm,
      );
    }

    _isLoading = false;
    notifyListeners();

    return true;
  }

  /// Deleta vaga
  Future<bool> deletarVaga(String id) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _vagas.removeWhere((v) => v.id == id);

    _isLoading = false;
    notifyListeners();

    return true;
  }
}

