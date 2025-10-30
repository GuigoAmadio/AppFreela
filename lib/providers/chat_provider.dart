import 'package:flutter/foundation.dart';
import '../data/models/mensagem_model.dart';
import '../data/services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService;

  ChatProvider({ChatService? chatService})
      : _chatService = chatService ?? ChatService();

  List<ConversaModel> _conversas = [];
  Map<String, List<MensagemModel>> _mensagensPorConversa = {};
  bool _isLoading = false;
  String? _error;
  int _unreadCount = 0;

  List<ConversaModel> get conversas => _conversas;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount => _unreadCount;

  /// Obtém mensagens de uma conversa
  List<MensagemModel> getMensagens(String conversaId) {
    return _mensagensPorConversa[conversaId] ?? [];
  }

  /// Carrega conversas
  Future<void> loadConversas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final conversasData = await _chatService.getConversas();
      _conversas = conversasData
          .map((json) => ConversaModel.fromJson(json))
          .toList();
      _error = null;
      
      // Atualiza contagem de não lidas
      await loadUnreadCount();
    } catch (e) {
      _error = e.toString();
      _conversas = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Carrega mensagens de uma conversa
  Future<void> loadMensagens(String conversaId) async {
    try {
      final mensagens = await _chatService.getMensagens(
        conversaId: conversaId,
      );
      _mensagensPorConversa[conversaId] = mensagens;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Envia mensagem
  Future<bool> enviarMensagem({
    required String conversaId,
    required String texto,
    String? anexoUrl,
  }) async {
    try {
      final mensagem = await _chatService.enviarMensagem(
        conversaId: conversaId,
        texto: texto,
        anexoUrl: anexoUrl,
      );

      // Adiciona mensagem à lista
      if (_mensagensPorConversa[conversaId] == null) {
        _mensagensPorConversa[conversaId] = [];
      }
      _mensagensPorConversa[conversaId]!.add(mensagem);

      // Atualiza última mensagem da conversa
      final conversaIndex =
          _conversas.indexWhere((c) => c.id == conversaId);
      if (conversaIndex != -1) {
        // Move conversa para o topo
        final conversa = _conversas.removeAt(conversaIndex);
        _conversas.insert(0, conversa);
      }

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Cria nova conversa
  Future<String?> criarConversa({
    required String destinatarioId,
    String? vagaId,
  }) async {
    try {
      final conversaData = await _chatService.criarConversa(
        destinatarioId: destinatarioId,
        vagaId: vagaId,
      );

      final conversa = ConversaModel.fromJson(conversaData);
      _conversas.insert(0, conversa);
      notifyListeners();

      return conversa.id;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Marca conversa como lida
  Future<void> marcarComoLida(String conversaId) async {
    try {
      await _chatService.marcarComoLida(conversaId);

      // Atualiza localmente
      final index = _conversas.indexWhere((c) => c.id == conversaId);
      if (index != -1) {
        final mensagens = _mensagensPorConversa[conversaId];
        if (mensagens != null) {
          _mensagensPorConversa[conversaId] = mensagens
              .map((m) => m.copyWith(lida: true))
              .toList();
        }
      }

      await loadUnreadCount();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Deleta mensagem
  Future<bool> deletarMensagem({
    required String conversaId,
    required String mensagemId,
  }) async {
    try {
      await _chatService.deletarMensagem(mensagemId);

      // Remove localmente
      _mensagensPorConversa[conversaId]
          ?.removeWhere((m) => m.id == mensagemId);
      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Upload de anexo
  Future<String?> uploadAnexo(String filePath) async {
    try {
      final url = await _chatService.uploadAnexo(filePath);
      return url;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Carrega contagem de mensagens não lidas
  Future<void> loadUnreadCount() async {
    try {
      _unreadCount = await _chatService.getUnreadCount();
      notifyListeners();
    } catch (e) {
      // Silencioso
    }
  }

  /// Busca ou cria conversa
  Future<String?> getOrCreateConversa({
    required String usuarioId,
    String? vagaId,
  }) async {
    try {
      final conversaData = await _chatService.getOrCreateConversa(
        usuarioId: usuarioId,
        vagaId: vagaId,
      );

      final conversa = ConversaModel.fromJson(conversaData);
      
      // Verifica se já existe
      final exists = _conversas.any((c) => c.id == conversa.id);
      if (!exists) {
        _conversas.insert(0, conversa);
        notifyListeners();
      }

      return conversa.id;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Adiciona mensagem recebida (para uso com WebSocket/FCM)
  void adicionarMensagemRecebida(MensagemModel mensagem) {
    final conversaId = mensagem.conversaId;
    
    if (_mensagensPorConversa[conversaId] == null) {
      _mensagensPorConversa[conversaId] = [];
    }
    _mensagensPorConversa[conversaId]!.add(mensagem);

    // Atualiza conversa
    final conversaIndex =
        _conversas.indexWhere((c) => c.id == conversaId);
    if (conversaIndex != -1) {
      final conversa = _conversas.removeAt(conversaIndex);
      _conversas.insert(0, conversa);
    }

    _unreadCount++;
    notifyListeners();
  }

  /// Limpa estado
  void clear() {
    _conversas = [];
    _mensagensPorConversa = {};
    _unreadCount = 0;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}

