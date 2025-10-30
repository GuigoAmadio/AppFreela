# 📱 Guia Rápido - Como Rodar o App

## 🚀 Equivalente ao "npm run dev"

No Flutter, o equivalente ao `npm run dev` é:

```bash
flutter run
```

Este comando irá:

- ✅ Compilar o projeto
- ✅ Iniciar o app no dispositivo/emulador conectado
- ✅ Ativar **Hot Reload** automático (mudanças no código aparecem instantaneamente!)

## 📋 Passo a Passo

### 1. Verificar se Flutter está instalado

```bash
flutter doctor
```

### 2. Navegar até a pasta do projeto

```bash
cd app_freelancer
```

### 3. Instalar dependências (equivalente a `npm install`)

```bash
flutter pub get
```

### 4. Ver dispositivos disponíveis

```bash
flutter devices
```

Você verá algo como:

```
Windows (desktop) • windows • windows-x64
Chrome (web)      • chrome  • web-javascript
```

### 5. Rodar o app

**Opção 1: Deixar Flutter escolher automaticamente**

```bash
flutter run
```

**Opção 2: Escolher dispositivo específico**

```bash
flutter run -d chrome          # Rodar no Chrome (Web)
flutter run -d windows         # Rodar no Windows Desktop
flutter run -d <device-id>     # Rodar em dispositivo Android/iOS
```

## ⌨️ Atalhos Durante Execução

Quando o app está rodando, você pode usar:

- **`r`** - Hot reload (recarrega o código sem perder estado)
- **`R`** - Hot restart (reinicia o app completamente)
- **`q`** - Sair
- **`h`** - Ver todos os atalhos disponíveis
- **`c`** - Limpar console
- **`o`** - Alternar entre iOS e Android

## 🌐 Rodar no Chrome (Web)

A forma mais rápida de testar:

```bash
flutter run -d chrome
```

Ou para abrir automaticamente:

```bash
flutter run -d web-server
```

## 🤖 Rodar no Android

1. Abrir Android Studio
2. Abrir AVD Manager (Android Virtual Device)
3. Iniciar um emulador
4. Rodar:

```bash
flutter run
```

Ou criar um emulador via linha de comando:

```bash
flutter emulators
flutter emulators --launch <emulator-id>
```

## 🍎 Rodar no iOS (apenas MacBook)

```bash
# Abrir simulador iOS
open -a Simulator

# Rodar app
flutter run
```

## 🐛 Comandos de Debug

```bash
# Rodar em modo release (mais rápido, sem debug)
flutter run --release

# Rodar em modo profile (para análise de performance)
flutter run --profile

# Ver logs detalhados
flutter run -v

# Limpar cache e build
flutter clean
flutter pub get
```

## 🔧 Resolver Problemas Comuns

### "No devices found"

```bash
# Para testar rápido, use Chrome:
flutter run -d chrome

# Ou Windows Desktop:
flutter run -d windows
```

### Erro de dependências

```bash
flutter clean
flutter pub get
flutter run
```

### Erro de build Android

```bash
cd android
gradlew clean
cd ..
flutter run
```

### Atualizar Flutter

```bash
flutter upgrade
```

## 📝 Comandos Úteis Extras

```bash
# Ver informações do projeto
flutter analyze

# Formatar código
flutter format .

# Rodar testes
flutter test

# Ver pacotes desatualizados
flutter pub outdated

# Atualizar pacotes
flutter pub upgrade

# Gerar ícones do app
flutter pub run flutter_launcher_icons:main
```

## 💡 Dicas

1. **Hot Reload é seu amigo**: Faça mudanças no código e pressione `r` - a mudança aparece em menos de 1 segundo!

2. **Chrome é mais rápido para testar**: Use `flutter run -d chrome` para desenvolvimento inicial

3. **DevTools**: Para debugging avançado

   ```bash
   flutter pub global activate devtools
   devtools
   ```

4. **VS Code**: Instale as extensões "Flutter" e "Dart" para melhor experiência

5. **Live coding**: Deixe `flutter run` executando e apenas salve os arquivos - o app atualiza automaticamente!

## 🎯 Fluxo de Trabalho Recomendado

```bash
# 1. Uma vez por dia/sessão
flutter pub get

# 2. Iniciar desenvolvimento
flutter run -d chrome

# 3. Editar código no Cursor/VS Code

# 4. Salvar arquivo (Ctrl+S)
# → App atualiza automaticamente! ✨

# 5. Se der erro, no terminal:
# Pressionar 'R' para hot restart

# 6. Quando terminar:
# Pressionar 'q' para sair
```

## ✅ Status Atual do Projeto

O projeto está configurado com:

- ✅ Estrutura de diretórios completa
- ✅ Dependências instaladas
- ✅ Tema customizado
- ✅ Constantes configuradas
- ✅ Template inicial funcional

**Próximo passo**: Rodar `flutter run -d chrome` e ver a tela de sucesso!
