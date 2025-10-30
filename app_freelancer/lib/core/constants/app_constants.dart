class AppConstants {
  // Nome do app
  static const String appName = 'Freelancer App';
  
  // Versão
  static const String appVersion = '1.0.0';
  
  // Shared Preferences keys
  static const String keyToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserType = 'user_type';
  static const String keyUserName = 'user_name';
  static const String keyIsLoggedIn = 'is_logged_in';
  
  // Tipos de usuário
  static const String tipoFreelancer = 'freelancer';
  static const String tipoEmpresa = 'empresa';
  
  // Configurações de paginação
  static const int itemsPerPage = 20;
  
  // Limites
  static const int maxImageSizeMB = 5;
  static const int minPreco = 0;
  static const int maxPreco = 10000;
  
  // Formato de datas
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  
  // Validações
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  
  // Mensagens padrão
  static const String msgErroGenerico = 'Ocorreu um erro. Tente novamente.';
  static const String msgSemInternet = 'Sem conexão com a internet.';
  static const String msgSucessoGenerico = 'Operação realizada com sucesso!';
}

