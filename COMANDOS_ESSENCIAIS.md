# 🎯 Comandos Essenciais - Cola Rápida

## 🚀 Rodar o Projeto

### Comando Principal (equivalente a `npm run dev`)

```bash
flutter run
```

### Escolher Dispositivo Específico

```bash
# Web (Chrome) - MAIS RÁPIDO PARA TESTAR
flutter run -d chrome

# Windows Desktop
flutter run -d windows

# Android
flutter run -d android

# Ver dispositivos disponíveis
flutter devices
```

### Com Porta Específica (Web)

```bash
flutter run -d chrome --web-port=8080
```

---

## 📦 Gerenciar Dependências

```bash
# Instalar dependências (= npm install)
flutter pub get

# Adicionar nova dependência
flutter pub add nome_do_pacote

# Remover dependência
flutter pub remove nome_do_pacote

# Ver dependências desatualizadas
flutter pub outdated

# Atualizar dependências
flutter pub upgrade
```

---

## 🔧 Build e Compilação

```bash
# Android APK (para testar)
flutter build apk

# Android App Bundle (para Play Store)
flutter build appbundle

# iOS (no MacBook)
flutter build ios
flutter build ipa

# Web
flutter build web

# Windows
flutter build windows
```

---

## 🧪 Testes

```bash
# Rodar todos os testes
flutter test

# Rodar teste específico
flutter test test/widget_test.dart

# Com cobertura de código
flutter test --coverage
```

---

## 🔍 Debug e Análise

```bash
# Analisar código (verificar erros)
flutter analyze

# Formatar código
flutter format .

# Limpar cache (resolver bugs estranhos)
flutter clean
flutter pub get

# Verificar instalação Flutter
flutter doctor
flutter doctor -v

# Ver logs detalhados
flutter run -v
```

---

## ⌨️ Atalhos Durante `flutter run`

Quando o app está rodando, você pode pressionar:

- **`r`** - Hot reload (recarrega código instantaneamente)
- **`R`** - Hot restart (reinicia app completamente)
- **`q`** - Sair e parar app
- **`h`** - Ver todos os atalhos
- **`c`** - Limpar console
- **`o`** - Alternar plataforma (Android/iOS)
- **`p`** - Debug de performance
- **`w`** - Widget Inspector

---

## 🌐 URLs Locais

Quando rodar no Chrome:

- **App:** http://localhost:8080
- **DevTools:** URL exibida no terminal após `flutter run`

---

## 🛠️ Resolver Problemas Comuns

### "No devices found"

```bash
# Use Chrome (sempre disponível)
flutter run -d chrome
```

### Erro de dependências

```bash
flutter clean
flutter pub get
flutter run
```

### Erro no Android

```bash
cd android
gradlew clean
cd ..
flutter clean
flutter pub get
```

### Build lento

```bash
# Usar modo release (muito mais rápido)
flutter run --release
```

### App não atualiza

```bash
# No terminal durante execução, pressione:
R  # Hot restart completo
```

---

## 📱 Emuladores

### Android

```bash
# Listar emuladores
flutter emulators

# Iniciar emulador
flutter emulators --launch <id>

# Ou usar Android Studio → AVD Manager
```

### iOS (MacBook)

```bash
# Abrir simulador
open -a Simulator

# Listar simuladores
xcrun simctl list devices
```

---

## 🎨 Assets e Recursos

### Adicionar Imagens

1. Colocar imagem em `assets/images/`
2. Adicionar no `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - assets/images/logo.png
   ```
3. Usar no código:
   ```dart
   Image.asset('assets/images/logo.png')
   ```

### Gerar Ícones do App

```bash
flutter pub add flutter_launcher_icons --dev
flutter pub run flutter_launcher_icons
```

---

## 🔐 Variáveis de Ambiente

### Editar

```bash
# Abrir arquivo .env
notepad .env
```

### Conteúdo necessário

```env
MAPBOX_ACCESS_TOKEN=pk.seu_token_aqui
API_BASE_URL=https://sua-api.com
```

### Recarregar após editar

```bash
# Parar app (q) e rodar novamente
flutter run
```

---

## 📊 Performance

### Analisar Performance

```bash
flutter run --profile
# Depois pressionar 'p' para performance overlay
```

### DevTools (Visual)

```bash
flutter pub global activate devtools
devtools
```

---

## 🚀 Workflow Diário Recomendado

```bash
# 1. Abrir projeto
cd app_freelancer

# 2. Atualizar dependências (se necessário)
flutter pub get

# 3. Iniciar app
flutter run -d chrome

# 4. Desenvolver no Cursor
# Salvar arquivo (Ctrl+S) → App atualiza automaticamente!

# 5. Se der erro
# No terminal: pressione 'R' para restart

# 6. Quando terminar
# Pressione 'q' para sair
```

---

## 🎯 Comandos Mais Usados (Top 5)

```bash
# 1. Rodar app
flutter run -d chrome

# 2. Instalar dependências
flutter pub get

# 3. Limpar cache
flutter clean

# 4. Analisar código
flutter analyze

# 5. Formatar código
flutter format .
```

---

## 💡 Dicas Pro

### 1. Multiple Devices

```bash
# Rodar em Chrome e Android ao mesmo tempo
flutter run -d chrome
# Em outro terminal:
flutter run -d android
```

### 2. Logs Filtrados

```bash
flutter logs | grep "ERROR"
```

### 3. Build Info

```bash
flutter --version
flutter doctor --verbose
```

### 4. Cache Size

```bash
# Ver tamanho do cache
du -sh ~/.pub-cache

# Limpar completamente
flutter clean
rm -rf ~/.pub-cache
flutter pub get
```

---

## ⚡ Atalhos do Cursor/VS Code

- **Ctrl+Shift+P** - Command Palette
- **Ctrl+Space** - Autocomplete
- **F5** - Start Debugging
- **Ctrl+F5** - Run Without Debugging
- **Ctrl+`** - Toggle Terminal

---

## 📞 Quando Precisar de Ajuda

1. **Erro desconhecido:** `flutter clean && flutter pub get`
2. **Build falhou:** Verificar `flutter doctor`
3. **App não abre:** Tentar `flutter run -d chrome`
4. **Código não atualiza:** Pressionar `R` no terminal
5. **Tudo travou:** Fechar terminal e rodar `flutter clean`

---

## 🎉 Pronto!

Cole este arquivo na sua área de trabalho e use como referência rápida enquanto desenvolve!
