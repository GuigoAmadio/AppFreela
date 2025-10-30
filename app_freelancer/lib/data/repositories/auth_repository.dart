import '../models/usuario_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  /// Realiza login
  Future<UsuarioModel> login({
    required String email,
    required String password,
  }) async {
    return await _authService.login(email: email, password: password);
  }

  /// Realiza cadastro
  Future<UsuarioModel> register({
    required String nome,
    required String email,
    required String password,
    required String telefone,
    required String tipo,
  }) async {
    return await _authService.register(
      nome: nome,
      email: email,
      password: password,
      telefone: telefone,
      tipo: tipo,
    );
  }

  /// Realiza logout
  Future<void> logout() async {
    await _authService.logout();
  }

  /// Verifica se usuário está autenticado
  Future<bool> isAuthenticated() async {
    return await _authService.isAuthenticated();
  }

  /// Obtém token de autenticação
  Future<String?> getToken() async {
    return await _authService.getToken();
  }

  /// Busca perfil do usuário
  Future<UsuarioModel> getProfile() async {
    return await _authService.getProfile();
  }

  /// Atualiza perfil do usuário
  Future<UsuarioModel> updateProfile(Map<String, dynamic> data) async {
    return await _authService.updateProfile(data: data);
  }

  /// Atualiza foto do perfil
  Future<String> updateProfilePhoto(String filePath) async {
    return await _authService.updateProfilePhoto(filePath);
  }

  /// Solicita reset de senha
  Future<void> requestPasswordReset(String email) async {
    await _authService.requestPasswordReset(email);
  }

  /// Reseta senha com token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await _authService.resetPassword(
      token: token,
      newPassword: newPassword,
    );
  }
}

