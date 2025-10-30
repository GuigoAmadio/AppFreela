# App Freelancer

App de intermediação entre restaurantes e freelancers desenvolvido em Flutter.

## 🚀 Começando

### Pré-requisitos

- Flutter SDK (versão 3.0.0 ou superior)
- Dart SDK (incluído no Flutter)
- Android Studio (para desenvolvimento Android)
- Xcode (para desenvolvimento iOS - apenas macOS)
- VS Code ou Android Studio como IDE

### Instalação

1. Clone o repositório

```bash
git clone <url-do-repo>
cd app_freelancer
```

2. Instale as dependências

```bash
flutter pub get
```

3. Configure as variáveis de ambiente

Copie o arquivo `.env.example` para `.env` e preencha com suas credenciais:

```bash
cp .env.example .env
```

Edite o arquivo `.env` com suas chaves:

```env
MAPBOX_ACCESS_TOKEN=pk.seu_token_mapbox_aqui
API_BASE_URL=https://sua-api-backend.com
```

Para obter o token do Mapbox:

- Acesse https://account.mapbox.com/
- Crie uma conta gratuita
- Copie o Access Token

### Rodando o Projeto

#### No Windows (Android ou Web)

**Rodar no emulador Android:**

```bash
flutter run
```

**Rodar no Chrome (Web):**

```bash
flutter run -d chrome
```

**Rodar no Windows Desktop:**

```bash
flutter run -d windows
```

#### No MacBook (iOS)

```bash
flutter run -d ios
```

### Comandos Úteis

```bash
# Listar dispositivos disponíveis
flutter devices

# Instalar dependências
flutter pub get

# Limpar build e cache
flutter clean

# Rodar testes
flutter test

# Gerar build Android (APK)
flutter build apk

# Gerar build Android (App Bundle para Play Store)
flutter build appbundle

# Gerar build iOS (no Mac)
flutter build ios

# Verificar problemas na instalação
flutter doctor -v

# Hot reload durante execução (pressione 'r' no terminal)
# Hot restart (pressione 'R' no terminal)
# Sair (pressione 'q' no terminal)
```

## 📁 Estrutura do Projeto

```
lib/
├── core/               # Código compartilhado
│   ├── constants/      # Constantes da aplicação
│   ├── theme/          # Tema e estilos
│   ├── routes/         # Rotas de navegação
│   └── utils/          # Utilitários
├── data/               # Camada de dados
│   ├── models/         # Models de dados
│   ├── services/       # Serviços de API
│   ├── repositories/   # Repositories
│   └── local/          # Armazenamento local
├── providers/          # State management (Provider)
├── ui/                 # Interface do usuário
│   ├── screens/        # Telas do app
│   └── widgets/        # Widgets reutilizáveis
├── app.dart            # Configuração principal do app
└── main.dart           # Entry point
```

## 🎨 Funcionalidades Principais

- ✅ Autenticação de usuários (Freelancer e Empresa)
- ✅ Mapa interativo com pins de empresas
- ✅ Sistema de vagas e candidaturas
- ✅ Sistema de avaliações e score
- ✅ Perfil de usuário customizável
- ✅ Notificações de novas vagas

## 🛠️ Tecnologias

- **Flutter** - Framework de desenvolvimento
- **Provider** - State management
- **Dio** - Cliente HTTP
- **Mapbox** - Mapas interativos
- **GoRouter** - Navegação
- **SharedPreferences** - Armazenamento local
- **FlutterSecureStorage** - Armazenamento seguro

## 📱 Plataformas Suportadas

- ✅ Android (5.0+)
- ✅ iOS (12.0+)
- ✅ Web
- ✅ Windows Desktop

## 🤝 Contribuindo

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/NovaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/NovaFeature`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está sob a licença MIT.

## 👥 Autores

- Desenvolvedor Principal - [Seu Nome]

## 📞 Suporte

Em caso de dúvidas ou problemas, abra uma issue no repositório.
