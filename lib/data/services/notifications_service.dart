import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../core/constants/api_constants.dart';
import 'api_client.dart';

class NotificationsService {
  final ApiClient _apiClient;
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  NotificationsService({
    ApiClient? apiClient,
    FlutterLocalNotificationsPlugin? notificationsPlugin,
  })  : _apiClient = apiClient ?? ApiClient(),
        _notificationsPlugin =
            notificationsPlugin ?? FlutterLocalNotificationsPlugin() {
    _initializeNotifications();
  }

  /// Inicializa o sistema de notificações
  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Callback quando notificação é tocada
  void _onNotificationTapped(NotificationResponse response) {
    // Implementar navegação baseada no payload
    print('Notification tapped: ${response.payload}');
  }

  /// Solicita permissão para notificações
  Future<bool> requestPermission() async {
    final androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }

    final iosPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    if (iosPlugin != null) {
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  /// Mostra notificação local
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'app_freelancer_channel',
      'FreeLancer Notifications',
      channelDescription: 'Notificações do app FreeLancer',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Registra token FCM no backend
  Future<void> registerFCMToken(String token) async {
    try {
      await _apiClient.post(
        '/notifications/register-token',
        data: {'fcm_token': token},
      );
    } on DioException catch (e) {
      throw Exception('Erro ao registrar token: ${e.message}');
    }
  }

  /// Remove token FCM do backend
  Future<void> unregisterFCMToken() async {
    try {
      await _apiClient.delete('/notifications/unregister-token');
    } on DioException catch (e) {
      throw Exception('Erro ao remover token: ${e.message}');
    }
  }

  /// Busca notificações do usuário
  Future<List<Map<String, dynamic>>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        '/notifications',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(
          response.data['notifications'] ?? response.data,
        );
      }
      throw Exception('Falha ao buscar notificações');
    } on DioException catch (e) {
      throw Exception('Erro ao buscar notificações: ${e.message}');
    }
  }

  /// Marca notificação como lida
  Future<void> markAsRead(String notificationId) async {
    try {
      await _apiClient.put('/notifications/$notificationId/read');
    } on DioException catch (e) {
      throw Exception('Erro ao marcar como lida: ${e.message}');
    }
  }

  /// Marca todas notificações como lidas
  Future<void> markAllAsRead() async {
    try {
      await _apiClient.put('/notifications/read-all');
    } on DioException catch (e) {
      throw Exception('Erro ao marcar todas como lidas: ${e.message}');
    }
  }

  /// Deleta notificação
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _apiClient.delete('/notifications/$notificationId');
    } on DioException catch (e) {
      throw Exception('Erro ao deletar notificação: ${e.message}');
    }
  }

  /// Atualiza preferências de notificações
  Future<void> updatePreferences({
    required bool candidaturasAceitas,
    required bool candidaturasRejeitadas,
    required bool novasVagas,
    required bool mensagens,
    required bool avaliacoes,
  }) async {
    try {
      await _apiClient.put(
        '/notifications/preferences',
        data: {
          'candidaturas_aceitas': candidaturasAceitas,
          'candidaturas_rejeitadas': candidaturasRejeitadas,
          'novas_vagas': novasVagas,
          'mensagens': mensagens,
          'avaliacoes': avaliacoes,
        },
      );
    } on DioException catch (e) {
      throw Exception('Erro ao atualizar preferências: ${e.message}');
    }
  }

  /// Busca preferências de notificações
  Future<Map<String, dynamic>> getPreferences() async {
    try {
      final response = await _apiClient.get('/notifications/preferences');
      return response.data;
    } on DioException catch (e) {
      throw Exception('Erro ao buscar preferências: ${e.message}');
    }
  }

  /// Cancela todas notificações locais
  Future<void> cancelAllLocalNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Cancela notificação local específica
  Future<void> cancelLocalNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}

