import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'providers/auth_provider.dart';
import 'providers/vagas_provider.dart';
import 'ui/screens/auth/login_screen.dart';
import 'ui/screens/auth/register_screen.dart';
import 'ui/screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => VagasProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'Freelancer App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            initialRoute: auth.isLoggedIn ? AppRoutes.mapa : AppRoutes.login,
            routes: {
              AppRoutes.login: (context) => const LoginScreen(),
              AppRoutes.register: (context) => const RegisterScreen(),
              AppRoutes.mapa: (context) => const HomeScreen(),
            },
          );
        },
      ),
    );
  }
}

