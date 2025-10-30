import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/api_constants.dart';
import '../models/usuario_model.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage;

  AuthService({
    ApiClient? apiClient,
    FlutterSecureStorage? storage,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storage = storage ?? const FlutterSecureStorage();

  /// Faz login com email e senha
  Future<UsuarioModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Salvar tokens
        await _storage.write(key: 'auth_token', value: data['access_token']);
        await _storage.write(key: 'refresh_token', value: data['refresh_token']);
        
        // Retornar usuário
        return UsuarioModel.fromJson(data['user']);
      } else {
        throw Exception('Falha no login');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Email ou senha inválidos');
      } else if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data['message'] ?? 'Dados inválidos');
      }
      throw Exception('Erro ao fazer login: ${e.message}');
    }
  }

  /// Registra um novo usuário
  Future<UsuarioModel> register({
    required String nome,
    required String email,
    required String password,
    required String telefone,
    required String tipo, // 'freelancer' ou 'empresa'
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.registerEndpoint,
        data: {
          'nome': nome,
          'email': email,
          'password': password,
          'telefone': telefone,
          'tipo': tipo,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        
        // Salvar tokens
        await _storage.write(key: 'auth_token', value: data['access_token']);
        await _storage.write(key: 'refresh_token', value: data['refresh_token']);
        
        // Retornar usuário
        return UsuarioModel.fromJson(data['user']);
      } else {
        throw Exception('Falha no registro');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception('Este email já está cadastrado');
      } else if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data['message'] ?? 'Dados inválidos');
      }
      throw Exception('Erro ao registrar: ${e.message}');
    }
  }

  /// Faz logout
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiConstants.logoutEndpoint);
    } catch (e) {
      // Continua mesmo se a requisição falhar
    } finally {
      // Limpar tokens locais
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'refresh_token');
      await _storage.delete(key: 'user_data');
    }
  }

  /// Verifica se o usuário está autenticado
  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'auth_token');
    return token != null;
  }

  /// Obtém o token atual
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  /// Busca dados do perfil do usuário atual
  Future<UsuarioModel> getProfile() async {
    try {
      final response = await _apiClient.get(ApiConstants.perfilEndpoint);

      if (response.statusCode == 200) {
        return UsuarioModel.fromJson(response.data);
      } else {
        throw Exception('Falha ao buscar perfil');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao buscar perfil: ${e.message}');
    }
  }

  /// Atualiza dados do perfil
  Future<UsuarioModel> updateProfile({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _apiClient.put(
        ApiConstants.perfilEndpoint,
        data: data,
      );

      if (response.statusCode == 200) {
        return UsuarioModel.fromJson(response.data);
      } else {
        throw Exception('Falha ao atualizar perfil');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao atualizar perfil: ${e.message}');
    }
  }

  /// Atualiza foto do perfil
  Future<String> updateProfilePhoto(String filePath) async {
    try {
      FormData formData = FormData.fromMap({
        'foto': await MultipartFile.fromFile(filePath),
      });

      final response = await _apiClient.post(
        ApiConstants.perfilFotoEndpoint,
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['foto_url'];
      } else {
        throw Exception('Falha ao atualizar foto');
      }
    } on DioException catch (e) {
      throw Exception('Erro ao atualizar foto: ${e.message}');
    }
  }

  /// Solicita reset de senha
  Future<void> requestPasswordReset(String email) async {
    try {
      await _apiClient.post(
        '/auth/forgot-password',
        data: {'email': email},
      );
    } on DioException catch (e) {
      throw Exception('Erro ao solicitar reset de senha: ${e.message}');
    }
  }

  /// Reset de senha com token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _apiClient.post(
        '/auth/reset-password',
        data: {
          'token': token,
          'password': newPassword,
        },
      );
    } on DioException catch (e) {
      throw Exception('Erro ao resetar senha: ${e.message}');
    }
  }
}

