import 'package:flutter/material.dart';
import '../data/models/usuario_model.dart';
import '../data/local/shared_prefs_helper.dart';

class AuthProvider extends ChangeNotifier {
  UsuarioModel? _usuario;
  bool _isLoading = false;
  String? _erro;
  bool _isLoggedIn = false;

  UsuarioModel? get usuario => _usuario;
  bool get isLoading => _isLoading;
  String? get erro => _erro;
  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _checkLoginStatus();
  }

  // Verificar se já está logado
  Future<void> _checkLoginStatus() async {
    _isLoggedIn = SharedPrefsHelper.isLoggedIn();
    if (_isLoggedIn) {
      // Carregar dados do usuário do SharedPrefs
      final userId = SharedPrefsHelper.getUserId();
      final userName = SharedPrefsHelper.getUserName();
      final userType = SharedPrefsHelper.getUserType();

      if (userId != null && userName != null) {
        _usuario = UsuarioModel(
          id: userId,
          nome: userName,
          email: 'usuario@email.com', // Mock
          tipo: userType ?? 'freelancer',
          score: 4.5,
          criadoEm: DateTime.now(),
        );
      }
    }
    notifyListeners();
  }

  // Login (Mock - sem API por enquanto)
  Future<bool> login(String email, String senha) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();

    try {
      // Simular delay de rede
      await Future.delayed(const Duration(seconds: 1));

      // Mock: Aceitar qualquer email/senha
      if (email.isNotEmpty && senha.length >= 6) {
        _usuario = UsuarioModel(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          nome: 'Usuário Teste',
          email: email,
          tipo: 'freelancer',
          telefone: '(11) 99999-9999',
          score: 4.5,
          criadoEm: DateTime.now(),
        );

        // Salvar localmente
        await SharedPrefsHelper.saveToken('mock_token_123');
        await SharedPrefsHelper.saveUserId(_usuario!.id);
        await SharedPrefsHelper.saveUserName(_usuario!.nome);
        await SharedPrefsHelper.saveUserType(_usuario!.tipo);
        await SharedPrefsHelper.setLoggedIn(true);

        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _erro = 'Email ou senha inválidos';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _erro = 'Erro ao fazer login: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Registro (Mock)
  Future<bool> register({
    required String nome,
    required String email,
    required String senha,
    required String tipo,
  }) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();

    try {
      // Simular delay de rede
      await Future.delayed(const Duration(seconds: 1));

      _usuario = UsuarioModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        nome: nome,
        email: email,
        tipo: tipo,
        score: 5.0, // Novo usuário começa com 5
        criadoEm: DateTime.now(),
      );

      // Salvar localmente
      await SharedPrefsHelper.saveToken('mock_token_123');
      await SharedPrefsHelper.saveUserId(_usuario!.id);
      await SharedPrefsHelper.saveUserName(_usuario!.nome);
      await SharedPrefsHelper.saveUserType(_usuario!.tipo);
      await SharedPrefsHelper.setLoggedIn(true);

      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _erro = 'Erro ao registrar: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await SharedPrefsHelper.clearAll();
    _usuario = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  // Limpar erro
  void clearError() {
    _erro = null;
    notifyListeners();
  }
}

