import 'package:flutter/foundation.dart';
import '../data/models/vaga_model.dart';
import '../data/services/favoritos_service.dart';

class FavoritosProvider with ChangeNotifier {
  final FavoritosService _favoritosService;

  FavoritosProvider({FavoritosService? favoritosService})
      : _favoritosService = favoritosService ?? FavoritosService();

  List<VagaModel> _favoritos = [];
  Set<String> _favoritosIds = {};
  bool _isLoading = false;
  String? _error;

  List<VagaModel> get favoritos => _favoritos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Verifica se vaga está nos favoritos
  bool isFavorito(String vagaId) {
    return _favoritosIds.contains(vagaId);
  }

  /// Carrega favoritos
  Future<void> loadFavoritos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _favoritos = await _favoritosService.getFavoritos();
      _favoritosIds = _favoritos.map((v) => v.id).toSet();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _favoritos = [];
      _favoritosIds = {};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adiciona favorito
  Future<bool> addFavorito(String vagaId) async {
    try {
      await _favoritosService.addFavorito(vagaId);
      _favoritosIds.add(vagaId);
      notifyListeners();
      
      // Recarrega lista completa
      await loadFavoritos();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Remove favorito
  Future<bool> removeFavorito(String vagaId) async {
    try {
      await _favoritosService.removeFavorito(vagaId);
      _favoritos.removeWhere((v) => v.id == vagaId);
      _favoritosIds.remove(vagaId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Toggle favorito
  Future<bool> toggleFavorito(String vagaId) async {
    if (isFavorito(vagaId)) {
      return await removeFavorito(vagaId);
    } else {
      return await addFavorito(vagaId);
    }
  }

  /// Limpa estado
  void clear() {
    _favoritos = [];
    _favoritosIds = {};
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}

