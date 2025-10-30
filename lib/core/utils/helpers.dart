import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Helpers {
  // Mostra SnackBar de sucesso
  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Mostra SnackBar de erro
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Mostra SnackBar de aviso
  static void showWarningSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Mostra dialog de confirmação
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  // Mostra loading dialog
  static void showLoadingDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(message),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Esconde loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  // Mostra dialog de informação
  static Future<void> showInfoDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  // Copia texto para clipboard
  static Future<void> copyToClipboard(
    BuildContext context,
    String text, {
    String? successMessage,
  }) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      showSuccessSnackBar(
        context,
        successMessage ?? 'Copiado para área de transferência',
      );
    }
  }

  // Esconde teclado
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  // Abre URL externa
  static Future<void> launchURL(String url) async {
    // Implementar com url_launcher package
    // await launchUrl(Uri.parse(url));
  }

  // Retorna cor baseada no status
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ativo':
      case 'aprovado':
      case 'aceito':
      case 'completo':
        return Colors.green;
      case 'pendente':
      case 'em_analise':
        return Colors.orange;
      case 'rejeitado':
      case 'cancelado':
      case 'inativo':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Retorna ícone baseado no status
  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'ativo':
      case 'aprovado':
      case 'aceito':
      case 'completo':
        return Icons.check_circle;
      case 'pendente':
      case 'em_analise':
        return Icons.schedule;
      case 'rejeitado':
      case 'cancelado':
      case 'inativo':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  // Debounce para pesquisas
  static void debounce(
    Function() action, {
    Duration delay = const Duration(milliseconds: 500),
  }) {
    Future.delayed(delay, action);
  }

  // Calcula idade a partir da data de nascimento
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    
    return age;
  }

  // Verifica se é email válido
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Gera cor a partir de string (útil para avatares)
  static Color colorFromString(String text) {
    int hash = 0;
    for (int i = 0; i < text.length; i++) {
      hash = text.codeUnitAt(i) + ((hash << 5) - hash);
    }
    
    final hue = (hash % 360).toDouble();
    return HSLColor.fromAHSL(1.0, hue, 0.6, 0.5).toColor();
  }

  // Obtém iniciais do nome
  static String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  // Formata texto de erro da API
  static String formatApiError(dynamic error) {
    if (error is String) return error;
    if (error is Map) {
      final message = error['message'] ?? error['error'];
      if (message is String) return message;
    }
    return 'Ocorreu um erro inesperado';
  }

  // Verifica se está em modo escuro
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  // Retorna saudação baseada na hora
  static String getGreeting() {
    final hour = DateTime.now().hour;
    
    if (hour < 12) {
      return 'Bom dia';
    } else if (hour < 18) {
      return 'Boa tarde';
    } else {
      return 'Boa noite';
    }
  }
}

