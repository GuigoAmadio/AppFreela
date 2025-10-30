import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // Base URL da API (vem do .env)
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'https://sua-api-backend.com';
  
  // Endpoints de autenticação
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshTokenEndpoint = '/auth/refresh';
  
  // Endpoints de vagas
  static const String vagasEndpoint = '/vagas';
  static String vagaByIdEndpoint(String id) => '/vagas/$id';
  static String candidatarVagaEndpoint(String id) => '/vagas/$id/candidatar';
  
  // Endpoints de empresas
  static const String empresasEndpoint = '/empresas';
  static String empresaByIdEndpoint(String id) => '/empresas/$id';
  
  // Endpoints de perfil
  static const String perfilEndpoint = '/perfil';
  static const String perfilFotoEndpoint = '/perfil/foto';
  
  // Endpoints de avaliações
  static String avaliacoesEndpoint(String userId) => '/avaliacoes/$userId';
  static const String criarAvaliacaoEndpoint = '/avaliacoes';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  static Map<String, String> headersWithToken(String token) => {
    ...headers,
    'Authorization': 'Bearer $token',
  };
}

