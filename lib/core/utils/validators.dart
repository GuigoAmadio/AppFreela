class Validators {
  // Valida email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }

    return null;
  }

  // Valida senha
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < minLength) {
      return 'Senha deve ter no mínimo $minLength caracteres';
    }

    return null;
  }

  // Valida confirmação de senha
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }

    if (value != password) {
      return 'As senhas não coincidem';
    }

    return null;
  }

  // Valida nome
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }

    if (value.length < 3) {
      return 'Nome deve ter no mínimo 3 caracteres';
    }

    return null;
  }

  // Valida telefone brasileiro
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefone é obrigatório';
    }

    final numbers = value.replaceAll(RegExp(r'\D'), '');

    if (numbers.length != 10 && numbers.length != 11) {
      return 'Telefone inválido';
    }

    return null;
  }

  // Valida CPF
  static String? validateCPF(String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }

    final numbers = value.replaceAll(RegExp(r'\D'), '');

    if (numbers.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) {
      return 'CPF inválido';
    }

    // Validação dos dígitos verificadores
    List<int> digits = numbers.split('').map((e) => int.parse(e)).toList();

    // Primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += digits[i] * (10 - i);
    }
    int firstDigit = 11 - (sum % 11);
    if (firstDigit >= 10) firstDigit = 0;

    if (digits[9] != firstDigit) {
      return 'CPF inválido';
    }

    // Segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += digits[i] * (11 - i);
    }
    int secondDigit = 11 - (sum % 11);
    if (secondDigit >= 10) secondDigit = 0;

    if (digits[10] != secondDigit) {
      return 'CPF inválido';
    }

    return null;
  }

  // Valida CNPJ
  static String? validateCNPJ(String? value) {
    if (value == null || value.isEmpty) {
      return 'CNPJ é obrigatório';
    }

    final numbers = value.replaceAll(RegExp(r'\D'), '');

    if (numbers.length != 14) {
      return 'CNPJ deve ter 14 dígitos';
    }

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) {
      return 'CNPJ inválido';
    }

    List<int> digits = numbers.split('').map((e) => int.parse(e)).toList();

    // Primeiro dígito verificador
    List<int> weights1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      sum += digits[i] * weights1[i];
    }
    int firstDigit = sum % 11 < 2 ? 0 : 11 - (sum % 11);

    if (digits[12] != firstDigit) {
      return 'CNPJ inválido';
    }

    // Segundo dígito verificador
    List<int> weights2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    sum = 0;
    for (int i = 0; i < 13; i++) {
      sum += digits[i] * weights2[i];
    }
    int secondDigit = sum % 11 < 2 ? 0 : 11 - (sum % 11);

    if (digits[13] != secondDigit) {
      return 'CNPJ inválido';
    }

    return null;
  }

  // Valida campo obrigatório
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Campo'} é obrigatório';
    }
    return null;
  }

  // Valida valor monetário
  static String? validateCurrency(String? value, {double? minValue}) {
    if (value == null || value.isEmpty) {
      return 'Valor é obrigatório';
    }

    final numberValue = double.tryParse(value.replaceAll(',', '.'));

    if (numberValue == null) {
      return 'Valor inválido';
    }

    if (minValue != null && numberValue < minValue) {
      return 'Valor deve ser no mínimo R\$ ${minValue.toStringAsFixed(2)}';
    }

    return null;
  }

  // Valida número
  static String? validateNumber(String? value, {int? min, int? max}) {
    if (value == null || value.isEmpty) {
      return 'Número é obrigatório';
    }

    final number = int.tryParse(value);

    if (number == null) {
      return 'Número inválido';
    }

    if (min != null && number < min) {
      return 'Valor mínimo é $min';
    }

    if (max != null && number > max) {
      return 'Valor máximo é $max';
    }

    return null;
  }

  // Valida URL
  static String? validateURL(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL é obrigatória';
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'URL inválida';
    }

    return null;
  }

  // Valida data no formato dd/MM/yyyy
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Data é obrigatória';
    }

    final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');

    if (!dateRegex.hasMatch(value)) {
      return 'Data inválida (use dd/MM/yyyy)';
    }

    final parts = value.split('/');
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return 'Data inválida';
    }

    if (day < 1 || day > 31 || month < 1 || month > 12 || year < 1900) {
      return 'Data inválida';
    }

    return null;
  }

  // Valida tamanho mínimo
  static String? validateMinLength(String? value, int minLength) {
    if (value == null || value.isEmpty) {
      return 'Campo é obrigatório';
    }

    if (value.length < minLength) {
      return 'Mínimo de $minLength caracteres';
    }

    return null;
  }

  // Valida tamanho máximo
  static String? validateMaxLength(String? value, int maxLength) {
    if (value == null) return null;

    if (value.length > maxLength) {
      return 'Máximo de $maxLength caracteres';
    }

    return null;
  }
}

