import 'package:flutter/foundation.dart';
import '../data/models/avaliacao_model.dart';
import '../data/repositories/avaliacoes_repository.dart';

class AvaliacoesProvider with ChangeNotifier {
  final AvaliacoesRepository _repository;

  AvaliacoesProvider({AvaliacoesRepository? repository})
      : _repository = repository ?? AvaliacoesRepository();

  List<AvaliacaoModel> _avaliacoes = [];
  bool _isLoading = false;
  String? _error;
  double _mediaAvaliacoes = 0.0;

  List<AvaliacaoModel> get avaliacoes => _avaliacoes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get mediaAvaliacoes => _mediaAvaliacoes;

  /// Carrega avaliações de um usuário
  Future<void> loadAvaliacoes(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _avaliacoes = await _repository.getAvaliacoes(userId);
      _mediaAvaliacoes = await _repository.getMediaAvaliacoes(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _avaliacoes = [];
      _mediaAvaliacoes = 0.0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cria uma nova avaliação
  Future<bool> criarAvaliacao({
    required String usuarioAvaliadoId,
    required int nota,
    required String comentario,
    String? vagaId,
  }) async {
    try {
      final novaAvaliacao = await _repository.criarAvaliacao(
        usuarioAvaliadoId: usuarioAvaliadoId,
        nota: nota,
        comentario: comentario,
        vagaId: vagaId,
      );

      _avaliacoes.insert(0, novaAvaliacao);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Deleta uma avaliação
  Future<bool> deletarAvaliacao(String avaliacaoId) async {
    try {
      await _repository.deletarAvaliacao(avaliacaoId);
      _avaliacoes.removeWhere((avaliacao) => avaliacao.id == avaliacaoId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Reporta uma avaliação
  Future<bool> reportarAvaliacao({
    required String avaliacaoId,
    required String motivo,
  }) async {
    try {
      await _repository.reportarAvaliacao(
        avaliacaoId: avaliacaoId,
        motivo: motivo,
      );
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Limpa o estado
  void clear() {
    _avaliacoes = [];
    _mediaAvaliacoes = 0.0;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}

