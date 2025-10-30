import 'package:flutter/foundation.dart';
import '../data/services/notifications_service.dart';

class NotificationsProvider with ChangeNotifier {
  final NotificationsService _notificationsService;

  NotificationsProvider({NotificationsService? notificationsService})
      : _notificationsService =
            notificationsService ?? NotificationsService();

  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = false;
  String? _error;
  int _unreadCount = 0;
  bool _permissionGranted = false;

  List<Map<String, dynamic>> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount => _unreadCount;
  bool get permissionGranted => _permissionGranted;

  /// Solicita permissão para notificações
  Future<void> requestPermission() async {
    _permissionGranted = await _notificationsService.requestPermission();
    notifyListeners();
  }

  /// Registra token FCM
  Future<void> registerToken(String token) async {
    try {
      await _notificationsService.registerFCMToken(token);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Remove token FCM
  Future<void> unregisterToken() async {
    try {
      await _notificationsService.unregisterFCMToken();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Carrega notificações
  Future<void> loadNotifications({int page = 1}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final notifications =
          await _notificationsService.getNotifications(page: page);
      
      if (page == 1) {
        _notifications = notifications;
      } else {
        _notifications.addAll(notifications);
      }

      // Conta não lidas
      _unreadCount =
          _notifications.where((n) => n['lida'] == false).length;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Marca notificação como lida
  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationsService.markAsRead(notificationId);

      // Atualiza localmente
      final index =
          _notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        _notifications[index]['lida'] = true;
        _unreadCount = _notifications.where((n) => n['lida'] == false).length;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Marca todas como lidas
  Future<void> markAllAsRead() async {
    try {
      await _notificationsService.markAllAsRead();

      // Atualiza localmente
      for (var notification in _notifications) {
        notification['lida'] = true;
      }
      _unreadCount = 0;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Deleta notificação
  Future<bool> deleteNotification(String notificationId) async {
    try {
      await _notificationsService.deleteNotification(notificationId);

      _notifications.removeWhere((n) => n['id'] == notificationId);
      _unreadCount = _notifications.where((n) => n['lida'] == false).length;
      notifyListeners();

      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Mostra notificação local
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _notificationsService.showLocalNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
    );
  }

  /// Adiciona notificação recebida (para uso com FCM)
  void adicionarNotificacaoRecebida(Map<String, dynamic> notification) {
    _notifications.insert(0, notification);
    if (notification['lida'] == false) {
      _unreadCount++;
    }
    notifyListeners();
  }

  /// Atualiza preferências
  Future<bool> updatePreferences({
    required bool candidaturasAceitas,
    required bool candidaturasRejeitadas,
    required bool novasVagas,
    required bool mensagens,
    required bool avaliacoes,
  }) async {
    try {
      await _notificationsService.updatePreferences(
        candidaturasAceitas: candidaturasAceitas,
        candidaturasRejeitadas: candidaturasRejeitadas,
        novasVagas: novasVagas,
        mensagens: mensagens,
        avaliacoes: avaliacoes,
      );
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Busca preferências
  Future<Map<String, dynamic>?> getPreferences() async {
    try {
      return await _notificationsService.getPreferences();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Limpa estado
  void clear() {
    _notifications = [];
    _unreadCount = 0;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}

