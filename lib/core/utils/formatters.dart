import 'package:intl/intl.dart';

class Formatters {
  // Formata valor monetário
  static String formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  // Formata data
  static String formatDate(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  // Formata data e hora
  static String formatDateTime(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(date);
  }

  // Formata hora
  static String formatTime(DateTime date) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(date);
  }

  // Formata data por extenso
  static String formatDateExtensive(DateTime date) {
    final formatter = DateFormat("d 'de' MMMM 'de' yyyy", 'pt_BR');
    return formatter.format(date);
  }

  // Formata telefone brasileiro
  static String formatPhone(String phone) {
    // Remove caracteres não numéricos
    final numbers = phone.replaceAll(RegExp(r'\D'), '');
    
    if (numbers.length == 11) {
      // (XX) XXXXX-XXXX
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 7)}-${numbers.substring(7)}';
    } else if (numbers.length == 10) {
      // (XX) XXXX-XXXX
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 6)}-${numbers.substring(6)}';
    }
    
    return phone;
  }

  // Formata CPF
  static String formatCPF(String cpf) {
    final numbers = cpf.replaceAll(RegExp(r'\D'), '');
    
    if (numbers.length == 11) {
      // XXX.XXX.XXX-XX
      return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6, 9)}-${numbers.substring(9)}';
    }
    
    return cpf;
  }

  // Formata CNPJ
  static String formatCNPJ(String cnpj) {
    final numbers = cnpj.replaceAll(RegExp(r'\D'), '');
    
    if (numbers.length == 14) {
      // XX.XXX.XXX/XXXX-XX
      return '${numbers.substring(0, 2)}.${numbers.substring(2, 5)}.${numbers.substring(5, 8)}/${numbers.substring(8, 12)}-${numbers.substring(12)}';
    }
    
    return cnpj;
  }

  // Formata distância
  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      final km = distanceInMeters / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
  }

  // Formata tempo relativo (ex: "há 2 horas")
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'há ${years} ${years == 1 ? 'ano' : 'anos'}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'há ${months} ${months == 1 ? 'mês' : 'meses'}';
    } else if (difference.inDays > 0) {
      return 'há ${difference.inDays} ${difference.inDays == 1 ? 'dia' : 'dias'}';
    } else if (difference.inHours > 0) {
      return 'há ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
    } else if (difference.inMinutes > 0) {
      return 'há ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
    } else {
      return 'agora';
    }
  }

  // Formata duração em horas e minutos
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      if (minutes > 0) {
        return '${hours}h ${minutes}min';
      }
      return '${hours}h';
    }
    return '${minutes}min';
  }

  // Trunca texto com ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Capitaliza primeira letra
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Capitaliza todas as palavras
  static String capitalizeWords(String text) {
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  // Formata número com separador de milhares
  static String formatNumber(int number) {
    final formatter = NumberFormat('#,###', 'pt_BR');
    return formatter.format(number);
  }

  // Formata porcentagem
  static String formatPercentage(double value, {int decimals = 0}) {
    return '${value.toStringAsFixed(decimals)}%';
  }
}

