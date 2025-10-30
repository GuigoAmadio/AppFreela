# 🔧 Troubleshooting - Problemas Comuns

## ❌ Erro: "No pubspec.yaml file found"

**Sintoma:**

```
Error: No pubspec.yaml file found.
This command should be run from the root of your Flutter project.
```

**Causa:** Você está rodando o comando Flutter fora da pasta do projeto.

**Solução:**

```bash
# Navegue para a pasta do projeto ANTES de rodar
cd C:\Users\Guillermo\Desktop\AppFreela\app_freelancer
flutter run -d chrome
```

---

## ❌ Erro: "children.isNotEmpty is not true" (Tela Vermelha)

**Sintoma:**
Tela vermelha no navegador com erro sobre `nested.dart` e `children.isNotEmpty`.

**Causa:** `MultiProvider` com lista vazia de providers.

**Solução:** ✅ **JÁ CORRIGIDO!**
Removi o `MultiProvider` vazio. Quando criarmos providers reais, adicionaremos novamente.

---

## ❌ Erro: "Building with plugins requires symlink support"

**Sintoma:**

```
Building with plugins requires symlink support.
Please enable Developer Mode in your system settings.
```

**Causa:** Windows precisa do Modo Desenvolvedor ativado.

**Solução:**

1. Pressionar `Win + I` (Configurações)
2. Ir em "Privacidade e segurança"
3. Clicar em "Para desenvolvedores"
4. Ativar "Modo de desenvolvedor"
5. Reiniciar o terminal
6. Rodar `flutter run` novamente

**Alternativa rápida:**

```bash
# Rodar este comando para abrir configurações
start ms-settings:developers
```

---

## ❌ Erro: "Waiting for connection from debug service"

**Sintoma:**
App não abre, fica travado em "Waiting for connection".

**Solução:**

```bash
# Parar processo (Ctrl+C)
# Limpar cache
flutter clean
flutter pub get
# Rodar novamente
flutter run -d chrome
```

---

## ❌ Chrome não abre automaticamente

**Sintoma:**
Comando executa mas navegador não abre.

**Solução:**

1. Verificar a URL no terminal (ex: `localhost:8080`)
2. Abrir Chrome manualmente
3. Colar a URL

Ou especificar porta:

```bash
flutter run -d chrome --web-port=8080
```

---

## ❌ "No devices found"

**Sintoma:**

```
No supported devices found with name or id matching 'chrome'.
```

**Causa:** Flutter não encontrou o dispositivo.

**Solução:**

```bash
# Ver dispositivos disponíveis
flutter devices

# Se Chrome não aparecer, instalar suporte web
flutter config --enable-web

# Rodar novamente
flutter run -d chrome
```

---

## ❌ Hot Reload não funciona

**Sintoma:**
Salva arquivo mas app não atualiza.

**Solução:**

1. No terminal onde está rodando, pressionar:
   - `r` - Hot reload
   - `R` - Hot restart (completo)
2. Se não funcionar:
   ```bash
   # Parar app (q)
   flutter clean
   flutter pub get
   flutter run
   ```

---

## ❌ Erro ao instalar dependências

**Sintoma:**

```
version solving failed
```

**Solução:**

```bash
# Limpar cache de dependências
flutter clean
flutter pub cache repair
flutter pub get
```

---

## ❌ Erro de permissões (Android)

**Sintoma:**
App não pede permissões de localização.

**Solução:**
Verificar `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

---

## ❌ Build muito lento

**Sintoma:**
Compilação demora muito.

**Solução:**

**Opção 1 - Usar Web (mais rápido):**

```bash
flutter run -d chrome
```

**Opção 2 - Build Release (mais rápido):**

```bash
flutter run --release
```

**Opção 3 - Limpar cache:**

```bash
flutter clean
flutter pub get
```

---

## ❌ Erro com .env

**Sintoma:**

```
Error loading .env file
```

**Solução:**

**Opção 1 - Criar arquivo .env:**

```bash
# Criar arquivo
echo "" > .env
```

**Opção 2 - Copiar do exemplo:**

```bash
copy .env.example .env
```

**Opção 3 - Editar manualmente:**
Criar arquivo `.env` na raiz do projeto com:

```env
MAPBOX_ACCESS_TOKEN=
API_BASE_URL=
```

---

## ❌ "Failed to load .env"

**Sintoma:**
App tenta carregar .env mas não encontra.

**Solução:**
Adicionar no `pubspec.yaml`:

```yaml
flutter:
  assets:
    - .env
```

Depois:

```bash
flutter pub get
flutter run
```

---

## 🆘 Comando de Emergência

**Quando NADA funciona:**

```bash
# 1. Parar tudo (Ctrl+C em todos os terminais)

# 2. Limpar completamente
flutter clean

# 3. Deletar pasta de build
Remove-Item -Recurse -Force build

# 4. Reinstalar dependências
flutter pub get

# 5. Rodar novamente
flutter run -d chrome
```

---

## 📋 Checklist de Verificação

Antes de rodar `flutter run`, certifique-se:

- [ ] Está na pasta correta: `cd app_freelancer`
- [ ] Dependências instaladas: `flutter pub get`
- [ ] Nenhum erro no código: `flutter analyze`
- [ ] Dispositivo disponível: `flutter devices`

---

## 🎯 Comando Seguro (Sempre Funciona)

Se estiver com dúvida, use este comando completo:

```bash
cd C:\Users\Guillermo\Desktop\AppFreela\app_freelancer
flutter clean
flutter pub get
flutter run -d chrome --web-port=8080
```

---

## 💡 Dicas de Prevenção

### 1. Sempre trabalhe na pasta correta

```bash
# Adicione isso ao início dos seus comandos
cd C:\Users\Guillermo\Desktop\AppFreela\app_freelancer
```

### 2. Verifique antes de rodar

```bash
# Ver onde você está
pwd
# ou no PowerShell:
Get-Location
```

### 3. Use um terminal por vez

- NÃO rode múltiplos `flutter run` simultaneamente
- Sempre pare o anterior (pressione `q`) antes de rodar novamente

### 4. Git ignore correto

Nunca commite:

- `/build/`
- `.env`
- `pubspec.lock` (opcional)

---

## 📞 Ainda com Problemas?

### Logs detalhados:

```bash
flutter run -v  # Verbose
```

### Informações do sistema:

```bash
flutter doctor -v
```

### Reiniciar completamente:

1. Fechar todos os terminais
2. Fechar Chrome
3. Abrir novo terminal
4. Rodar comandos novamente

---

## ✅ App Funcionando?

Se o app abriu com a tela verde "Projeto Flutter configurado!" - **SUCESSO!** 🎉

Agora pode começar a desenvolver:

1. Edite arquivos no Cursor
2. Salve (Ctrl+S)
3. App atualiza automaticamente
4. Continue codando!
