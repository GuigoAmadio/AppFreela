import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'data/local/shared_prefs_helper.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carregar variáveis de ambiente
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Erro ao carregar .env: $e');
    debugPrint('Continuando sem variáveis de ambiente...');
  }
  
  // Inicializar SharedPreferences
  await SharedPrefsHelper.init();
  
  runApp(const MyApp());
}
