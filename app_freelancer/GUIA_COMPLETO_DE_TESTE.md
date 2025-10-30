# 🧪 GUIA COMPLETO DE TESTE - APP FREELANCER

## 📱 Como Testar o App (Passo a Passo)

---

## 1️⃣ VERIFICAR SE TEM FLUTTER INSTALADO

### Windows (Você):

```powershell
# Verificar se Flutter está instalado
flutter --version

# Verificar tudo que precisa
flutter doctor -v
```

### Se não tiver instalado:

1. Baixe Flutter: https://docs.flutter.dev/get-started/install/windows
2. Extraia para `C:\src\flutter`
3. Adicione ao PATH: `C:\src\flutter\bin`
4. Reinicie o terminal

---

## 2️⃣ CONFIGURAR EMULADOR ANDROID

### Opção A: Android Studio (Recomendado)

1. **Instalar Android Studio:**

   - Download: https://developer.android.com/studio
   - Instale com as configurações padrão

2. **Criar Emulador:**

```powershell
# Listar emuladores
flutter emulators

# Criar através do Android Studio:
# Tools > Device Manager > Create Device
# Recomendo: Pixel 6 com Android 13
```

3. **Iniciar emulador:**

```powershell
# Listar emuladores disponíveis
flutter emulators

# Iniciar um emulador específico
flutter emulators --launch <emulator-id>
```

### Opção B: Usar seu celular Android físico

1. Ative modo desenvolvedor no celular:
   - Configurações > Sobre o telefone
   - Toque 7x em "Número da compilação"
2. Ative depuração USB:

   - Configurações > Opções do desenvolvedor
   - Ative "Depuração USB"

3. Conecte o celular no PC via USB

4. Verifique:

```powershell
flutter devices
```

### Opção C: Rodar no Chrome (Web)

```powershell
# Não precisa de emulador, roda direto no navegador!
flutter run -d chrome
```

---

## 3️⃣ INSTALAR DEPENDÊNCIAS DO PROJETO

```powershell
# Navegar até o projeto
cd C:\Users\Guillermo\Desktop\AppFreela\app_freelancer

# Instalar todas as dependências
flutter pub get

# Se der erro, limpar cache primeiro:
flutter clean
flutter pub get
```

---

## 4️⃣ CONFIGURAR .ENV (OPCIONAL)

Se quiser testar com backend real, crie o arquivo `.env`:

```env
API_BASE_URL=http://localhost:8080/api
MAPBOX_ACCESS_TOKEN=pk.seu_token_aqui
APP_ENV=development
```

**Para testar sem backend:** Pule esta etapa! Criei providers mockup.

---

## 5️⃣ RODAR O APP COM DADOS MOCKUP

### ⚠️ IMPORTANTE: Como não temos backend ainda, use os dados mockup!

Já criei 3 arquivos para você testar:

- ✅ `lib/data/mock/mock_data.dart` - Dados mockup
- ✅ `lib/providers/mock_auth_provider.dart` - Autenticação fake
- ✅ `lib/providers/mock_vagas_provider.dart` - Vagas fake

### Listar dispositivos disponíveis:

```powershell
flutter devices
```

### Rodar no dispositivo:

```powershell
# Rodar no primeiro dispositivo disponível
flutter run

# Ou especificar o dispositivo
flutter run -d chrome          # Web (mais fácil para testar)
flutter run -d windows         # Windows desktop
flutter run -d emulator-5554   # Android emulador
```

### Durante a execução:

- **`r`** - Hot reload (atualiza sem reiniciar)
- **`R`** - Hot restart (reinicia o app)
- **`q`** - Sair
- **`o`** - Alternar entre Android/iOS
- **`p`** - Mostrar grid de performance

---

## 6️⃣ TESTANDO O APP

### 🔐 Tela de Login (Com dados mockup):

```
Email freelancer: joao@email.com
Senha: qualquer coisa (aceita qualquer senha no mock)

OU

Email empresa: restaurante@email.com
Senha: qualquer coisa
```

### 📱 Fluxo de Teste Recomendado:

1. **Login**

   - Teste com email de freelancer
   - Veja a tela de home

2. **Ver Vagas**

   - Navegue para "Vagas"
   - Veja as 5 vagas mockup
   - Clique em uma vaga para ver detalhes
   - Teste o botão "Candidatar"

3. **Mapa**

   - Navegue para "Mapa"
   - Veja as vagas no mapa (placeholder)
   - Teste botão de localização

4. **Perfil**

   - Navegue para "Perfil"
   - Veja suas informações
   - Teste "Editar Perfil"
   - Veja "Minhas Avaliações" (3 avaliações mockup)

5. **Configurações**

   - Abra configurações do perfil
   - Teste as preferências
   - Veja opção de excluir conta

6. **Chat**

   - Navegue para mensagens
   - Veja 2 conversas mockup
   - Abra uma conversa
   - Teste enviar mensagem

7. **Filtros**
   - Vá em vagas
   - Clique no ícone de filtro
   - Teste os filtros
   - Aplique e veja resultados

---

## 7️⃣ DADOS MOCKUP DISPONÍVEIS

### 👤 Usuários:

- João Silva (Freelancer) - Score: 4.8⭐
- Restaurante Bom Sabor (Empresa) - Score: 4.5⭐

### 💼 Vagas (5 vagas):

1. Garçom - R$ 25/hora
2. Cozinheiro - R$ 35/hora
3. Bartender - R$ 30/hora
4. Auxiliar de Cozinha - R$ 18/hora
5. Gerente de Salão - R$ 45/hora

### ⭐ Avaliações (4 avaliações):

- 3 avaliações positivas para João
- 1 avaliação positiva para o restaurante

### 💬 Conversas (2 conversas):

- Com Restaurante Bom Sabor
- Com Pizzaria Bella Napoli (2 não lidas)

### 🔔 Notificações (4 notificações):

- Nova vaga disponível
- Candidatura aceita
- Nova mensagem
- Nova avaliação

---

## 8️⃣ COMANDOS ÚTEIS

```powershell
# Ver logs em tempo real
flutter logs

# Ver performance
flutter run --profile

# Build de produção
flutter build apk --release

# Analisar código
flutter analyze

# Formatar código
flutter format lib/

# Limpar tudo e reinstalar
flutter clean
flutter pub get
flutter run
```

---

## 9️⃣ SOLUÇÃO DE PROBLEMAS

### ❌ Erro: "flutter: command not found"

```powershell
# Adicione Flutter ao PATH
# Windows: Editar variáveis de ambiente do sistema
# Adicionar: C:\src\flutter\bin
```

### ❌ Erro: "No devices found"

```powershell
# Inicie o emulador primeiro
flutter emulators
flutter emulators --launch <nome-do-emulador>

# Ou use web
flutter run -d chrome
```

### ❌ Erro: "Packages get failed"

```powershell
# Limpe e reinstale
flutter clean
flutter pub cache repair
flutter pub get
```

### ❌ Erro: "Gradle build failed"

```powershell
# Atualize Gradle
cd android
./gradlew clean

# Volte para raiz
cd ..
flutter clean
flutter pub get
flutter run
```

---

## 🎯 CHECKLIST DE TESTE

Use este checklist para testar todas as funcionalidades:

### Autenticação

- [ ] Login com freelancer
- [ ] Login com empresa
- [ ] Registro de novo usuário
- [ ] Logout

### Vagas

- [ ] Ver lista de vagas
- [ ] Filtrar vagas
- [ ] Ver detalhes da vaga
- [ ] Candidatar-se a vaga
- [ ] Ver minhas candidaturas
- [ ] Criar nova vaga (empresa)
- [ ] Editar vaga (empresa)

### Perfil

- [ ] Ver perfil
- [ ] Editar perfil
- [ ] Ver avaliações
- [ ] Ver histórico

### Chat

- [ ] Ver conversas
- [ ] Abrir conversa
- [ ] Enviar mensagem
- [ ] Ver mensagens não lidas

### Mapa

- [ ] Ver vagas no mapa
- [ ] Obter localização atual
- [ ] Filtrar vagas no mapa

### Outros

- [ ] Configurações
- [ ] Notificações
- [ ] Favoritos
- [ ] Busca avançada
- [ ] Selecionar localização

---

## 🚀 DICA PRO

**Para melhor experiência de teste:**

1. **Use Chrome primeiro** (mais fácil de debugar):

```powershell
flutter run -d chrome
```

2. **Abra DevTools** para ver logs e performance:

```powershell
# Após rodar o app, pressione 'v' para abrir DevTools
```

3. **Hot Reload** é seu amigo:
   - Faça mudanças no código
   - Pressione `r`
   - Veja as mudanças instantaneamente!

---

## 📸 SCREENSHOTS

Tire screenshots durante os testes para documentar:

- Tela de login
- Lista de vagas
- Detalhes da vaga
- Chat
- Perfil
- Mapa

---

## 🎉 PRONTO PARA TESTAR!

Agora você tem:

- ✅ Guia completo de instalação
- ✅ Dados mockup para testar
- ✅ Comandos para rodar
- ✅ Checklist de testes
- ✅ Solução de problemas

**Execute:**

```powershell
cd C:\Users\Guillermo\Desktop\AppFreela\app_freelancer
flutter pub get
flutter run -d chrome
```

**Login de teste:**

- Email: `joao@email.com`
- Senha: `123456` (qualquer senha funciona no mock!)

**Divirta-se testando! 🚀**

---

**Dúvidas?** Veja a documentação:

- Flutter: https://docs.flutter.dev
- Dart: https://dart.dev/guides
