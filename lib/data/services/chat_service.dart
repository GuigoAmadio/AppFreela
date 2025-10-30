import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/mensagem_model.dart';
import 'api_client.dart';

class ChatService {
  final ApiClient _apiClient;

  ChatService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Busca conversas do usuário
  Future<List<Map<String, dynamic>>> getConversas() async {
    try {
      final response = await _apiClient.get('/chat/conversas');

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
          response.data['conversas'] ?? response.data,
        );
      }
      throw Exception('Falha ao buscar conversas');
    } on DioException catch (e) {
      throw Exception('Erro ao buscar conversas: ${e.message}');
    }
  }

  /// Busca mensagens de uma conversa
  Future<List<MensagemModel>> getMensagens({
    required String conversaId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _apiClient.get(
        '/chat/conversas/$conversaId/mensagens',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data['mensagens'] ?? response.data;
        return data.map((json) => MensagemModel.fromJson(json)).toList();
      }
      throw Exception('Falha ao buscar mensagens');
    } on DioException catch (e) {
      throw Exception('Erro ao buscar mensagens: ${e.message}');
    }
  }

  /// Envia mensagem
  Future<MensagemModel> enviarMensagem({
    required String conversaId,
    required String texto,
    String? anexoUrl,
  }) async {
    try {
      final response = await _apiClient.post(
        '/chat/conversas/$conversaId/mensagens',
        data: {
          'texto': texto,
          if (anexoUrl != null) 'anexo_url': anexoUrl,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return MensagemModel.fromJson(response.data);
      }
      throw Exception('Falha ao enviar mensagem');
    } on DioException catch (e) {
      throw Exception('Erro ao enviar mensagem: ${e.message}');
    }
  }

  /// Cria nova conversa
  Future<Map<String, dynamic>> criarConversa({
    required String destinatarioId,
    String? vagaId,
  }) async {
    try {
      final response = await _apiClient.post(
        '/chat/conversas',
        data: {
          'destinatario_id': destinatarioId,
          if (vagaId != null) 'vaga_id': vagaId,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Falha ao criar conversa');
    } on DioException catch (e) {
      throw Exception('Erro ao criar conversa: ${e.message}');
    }
  }

  /// Marca mensagens como lidas
  Future<void> marcarComoLida(String conversaId) async {
    try {
      await _apiClient.put('/chat/conversas/$conversaId/ler');
    } on DioException catch (e) {
      throw Exception('Erro ao marcar como lida: ${e.message}');
    }
  }

  /// Deleta mensagem
  Future<void> deletarMensagem(String mensagemId) async {
    try {
      await _apiClient.delete('/chat/mensagens/$mensagemId');
    } on DioException catch (e) {
      throw Exception('Erro ao deletar mensagem: ${e.message}');
    }
  }

  /// Upload de anexo
  Future<String> uploadAnexo(String filePath) async {
    try {
      FormData formData = FormData.fromMap({
        'arquivo': await MultipartFile.fromFile(filePath),
      });

      final response = await _apiClient.post(
        '/chat/upload-anexo',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['url'];
      }
      throw Exception('Falha ao fazer upload');
    } on DioException catch (e) {
      throw Exception('Erro ao fazer upload: ${e.message}');
    }
  }

  /// Busca mensagens não lidas
  Future<int> getUnreadCount() async {
    try {
      final response = await _apiClient.get('/chat/unread-count');
      return response.data['count'] ?? 0;
    } on DioException catch (e) {
      throw Exception('Erro ao buscar contagem: ${e.message}');
    }
  }

  /// Busca ou cria conversa com usuário
  Future<Map<String, dynamic>> getOrCreateConversa({
    required String usuarioId,
    String? vagaId,
  }) async {
    try {
      final response = await _apiClient.post(
        '/chat/get-or-create',
        data: {
          'usuario_id': usuarioId,
          if (vagaId != null) 'vaga_id': vagaId,
        },
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception('Erro ao buscar/criar conversa: ${e.message}');
    }
  }

  /// Bloqueia usuário
  Future<void> bloquearUsuario(String usuarioId) async {
    try {
      await _apiClient.post('/chat/bloquear/$usuarioId');
    } on DioException catch (e) {
      throw Exception('Erro ao bloquear usuário: ${e.message}');
    }
  }

  /// Desbloqueia usuário
  Future<void> desbloquearUsuario(String usuarioId) async {
    try {
      await _apiClient.delete('/chat/bloquear/$usuarioId');
    } on DioException catch (e) {
      throw Exception('Erro ao desbloquear usuário: ${e.message}');
    }
  }

  /// Reporta conversa/mensagem
  Future<void> reportar({
    required String conversaId,
    required String motivo,
    String? mensagemId,
  }) async {
    try {
      await _apiClient.post(
        '/chat/reportar',
        data: {
          'conversa_id': conversaId,
          'motivo': motivo,
          if (mensagemId != null) 'mensagem_id': mensagemId,
        },
      );
    } on DioException catch (e) {
      throw Exception('Erro ao reportar: ${e.message}');
    }
  }
}

