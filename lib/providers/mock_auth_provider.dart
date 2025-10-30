import 'package:flutter/foundation.dart';
import '../data/models/usuario_model.dart';
import '../data/mock/mock_data.dart';

/// Provider de autenticação com dados mockup para testes
class MockAuthProvider with ChangeNotifier {
  UsuarioModel? _usuario;
  bool _isLoading = false;
  String? _error;

  UsuarioModel? get usuario => _usuario;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _usuario != null;

  /// Login mockup
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Simula delay de rede
    await Future.delayed(const Duration(seconds: 1));

    // Simula validação
    if (email.isEmpty || password.isEmpty) {
      _error = 'Email e senha são obrigatórios';
      _isLoading = false;
      notifyListeners();
      return;
    }

    // Login bem-sucedido com dados mockup
    if (email.contains('empresa') || email.contains('restaurante')) {
      _usuario = MockData.usuarioEmpresa;
    } else {
      _usuario = MockData.usuarioFreelancer;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Registro mockup
  Future<void> register({
    required String nome,
    required String email,
    required String password,
    required String telefone,
    required String tipo,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Simula delay de rede
    await Future.delayed(const Duration(seconds: 1));

    // Cria novo usuário com dados fornecidos
    _usuario = UsuarioModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: nome,
      email: email,
      telefone: telefone,
      tipo: tipo,
      fotoUrl: null,
      score: 0.0,
      criadoEm: DateTime.now(),
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Logout
  Future<void> logout() async {
    _usuario = null;
    notifyListeners();
  }

  /// Verifica se está autenticado
  Future<bool> checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 1));
    // Por padrão, não está autenticado (para testar tela de login)
    return false;
  }

  /// Atualiza perfil
  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (_usuario == null) return;

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _usuario = UsuarioModel(
      id: _usuario!.id,
      nome: data['nome'] ?? _usuario!.nome,
      email: _usuario!.email,
      telefone: data['telefone'] ?? _usuario!.telefone,
      tipo: _usuario!.tipo,
      fotoUrl: _usuario!.fotoUrl,
      score: _usuario!.score,
      criadoEm: _usuario!.criadoEm,
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Atualiza foto do perfil
  Future<void> updateProfilePhoto(String filePath) async {
    if (_usuario == null) return;

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Simula URL da foto
    final fotoUrl = 'https://via.placeholder.com/150';

    _usuario = UsuarioModel(
      id: _usuario!.id,
      nome: _usuario!.nome,
      email: _usuario!.email,
      telefone: _usuario!.telefone,
      tipo: _usuario!.tipo,
      fotoUrl: fotoUrl,
      score: _usuario!.score,
      criadoEm: _usuario!.criadoEm,
    );

    _isLoading = false;
    notifyListeners();
  }
}

