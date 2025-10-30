import 'package:flutter_test/flutter_test.dart';

import 'package:app_freelancer/app.dart';

void main() {
  testWidgets('App carrega corretamente', (WidgetTester tester) async {
    // Build do app
    await tester.pumpWidget(const MyApp());

    // Verificar se o título aparece
    expect(find.text('App Freelancer'), findsOneWidget);
    
    // Verificar se a mensagem de sucesso aparece
    expect(find.text('Projeto Flutter configurado!'), findsOneWidget);
    
    // Verificar se o botão de teste existe
    expect(find.text('Testar'), findsOneWidget);
  });

  testWidgets('Botão de teste funciona', (WidgetTester tester) async {
    // Build do app
    await tester.pumpWidget(const MyApp());

    // Tap no botão
    await tester.tap(find.text('Testar'));
    await tester.pump();

    // Verificar se a snackbar aparece
    expect(find.text('Tudo funcionando perfeitamente!'), findsOneWidget);
  });
}
