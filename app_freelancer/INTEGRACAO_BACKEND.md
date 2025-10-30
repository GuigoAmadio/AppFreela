# 🔌 Guia de Integração Frontend-Backend

## 📋 Checklist de Integração

### 1. Configuração Inicial

- [ ] Criar arquivo `.env` na raiz do projeto
- [ ] Configurar `API_BASE_URL` com a URL do backend
- [ ] Configurar `MAPBOX_ACCESS_TOKEN` para os mapas
- [ ] Executar `flutter pub get` para instalar dependências

### 2. Estrutura de Rotas

As rotas do app já estão configuradas para funcionar com o backend. Certifique-se de que o backend implementa estas rotas:

```
Backend URL: http://localhost:8080/api
```

### 3. Endpoints Necessários

#### 🔐 Autenticação

```
POST   /auth/login              - Login do usuário
POST   /auth/register           - Registro de novo usuário
POST   /auth/logout             - Logout
POST   /auth/refresh            - Refresh token
POST   /auth/forgot-password    - Solicitar reset de senha
POST   /auth/reset-password     - Resetar senha
```

#### 👤 Perfil

```
GET    /perfil                  - Buscar perfil do usuário atual
PUT    /perfil                  - Atualizar perfil
POST   /perfil/foto             - Upload de foto de perfil
```

#### 💼 Vagas

```
GET    /vagas                   - Listar vagas (com filtros)
  Query params:
    - page: número da página
    - limit: itens por página
    - cargo: filtro por cargo
    - latitude: localização
    - longitude: localização
    - raio: raio em km
    - status: status da vaga

GET    /vagas/:id               - Detalhes de uma vaga
POST   /vagas                   - Criar nova vaga (empresa)
PUT    /vagas/:id               - Atualizar vaga (empresa)
DELETE /vagas/:id               - Deletar vaga (empresa)
```

#### 📝 Candidaturas

```
POST   /vagas/:id/candidatar    - Candidatar-se a uma vaga
DELETE /vagas/:id/candidatar    - Cancelar candidatura
GET    /candidaturas            - Minhas candidaturas
GET    /vagas/:id/candidatos    - Candidatos de uma vaga (empresa)
POST   /vagas/:vagaId/candidatos/:userId/aceitar  - Aceitar candidato
POST   /vagas/:vagaId/candidatos/:userId/rejeitar - Rejeitar candidato
```

#### ⭐ Avaliações

```
GET    /avaliacoes/:userId      - Avaliações de um usuário
POST   /avaliacoes              - Criar avaliação
DELETE /avaliacoes/:id          - Deletar avaliação
GET    /avaliacoes/:userId/media - Média de avaliações
POST   /avaliacoes/:id/reportar - Reportar avaliação
```

#### 🏢 Empresas

```
GET    /empresas                - Listar empresas
GET    /empresas/:id            - Detalhes de uma empresa
GET    /empresas/minhas-vagas   - Vagas da minha empresa
```

## 📦 Formato de Dados

### Usuário (UsuarioModel)

```json
{
  "id": "string",
  "nome": "string",
  "email": "string",
  "telefone": "string",
  "tipo": "freelancer | empresa",
  "foto_url": "string?",
  "media_avaliacoes": "number",
  "total_avaliacoes": "number",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

### Vaga (VagaModel)

```json
{
  "id": "string",
  "cargo": "string",
  "descricao": "string",
  "valor_hora": "number",
  "data_inicio": "datetime",
  "data_fim": "datetime",
  "numero_vagas": "number",
  "endereco": "string",
  "latitude": "number",
  "longitude": "number",
  "empresa_id": "string",
  "empresa_nome": "string",
  "empresa_foto": "string?",
  "status": "aberta | fechada | cancelada",
  "status_candidatura": "pendente | aceito | rejeitado"?,
  "distancia_km": "number?",
  "created_at": "datetime"
}
```

### Avaliação (AvaliacaoModel)

```json
{
  "id": "string",
  "avaliador_id": "string",
  "avaliador_nome": "string",
  "avaliador_foto": "string?",
  "usuario_avaliado_id": "string",
  "nota": "number (1-5)",
  "comentario": "string",
  "vaga_id": "string?",
  "vaga_titulo": "string?",
  "created_at": "datetime"
}
```

### Candidatura

```json
{
  "id": "string",
  "usuario": {
    "id": "string",
    "nome": "string",
    "email": "string",
    "telefone": "string",
    "foto_url": "string?",
    "media_avaliacoes": "number",
    "total_avaliacoes": "number"
  },
  "vaga": "VagaModel",
  "status": "pendente | aceito | rejeitado",
  "created_at": "datetime"
}
```

### Resposta de Login/Register

```json
{
  "access_token": "string",
  "refresh_token": "string",
  "user": "UsuarioModel"
}
```

## 🔒 Autenticação

### Headers

O app envia automaticamente o token de autenticação em todas as requisições:

```
Authorization: Bearer <token>
Content-Type: application/json
Accept: application/json
```

### Refresh Token

O sistema faz refresh automático do token quando recebe 401. O backend deve implementar:

```
POST /auth/refresh
Body: { "refresh_token": "string" }
Response: { "access_token": "string", "refresh_token": "string" }
```

## 🗺️ Localização

### Filtros de Localização

Quando o usuário busca vagas por localização, o app envia:

```
GET /vagas?latitude=-23.5505&longitude=-46.6333&raio=10
```

O backend deve retornar vagas dentro do raio especificado (em km) e incluir a distância:

```json
{
  "vagas": [
    {
      ...vaga,
      "distancia_km": 5.2
    }
  ]
}
```

## 🔔 Códigos de Status HTTP

O app trata os seguintes códigos:

- **200/201** - Sucesso
- **400** - Dados inválidos (mostra mensagem do backend)
- **401** - Não autenticado (tenta refresh token)
- **403** - Sem permissão
- **404** - Não encontrado
- **409** - Conflito (ex: email já cadastrado)
- **500** - Erro interno do servidor

## ⚠️ Tratamento de Erros

### Formato de Erro Esperado

```json
{
  "message": "Mensagem de erro amigável",
  "error": "CÓDIGO_DO_ERRO",
  "details": {}
}
```

O app mostra automaticamente a mensagem de erro para o usuário.

## 🧪 Testando a Integração

### 1. Configurar ambiente de desenvolvimento

```bash
# No arquivo .env
API_BASE_URL=http://localhost:8080/api
```

### 2. Testar autenticação

```dart
// O app já está configurado para usar o AuthService
// Basta registrar um usuário e fazer login
```

### 3. Testar vagas

```dart
// Use o VagasProvider para buscar vagas
final vagasProvider = context.read<VagasProvider>();
await vagasProvider.loadVagas();
```

### 4. Logs

O app usa o package `logger` e registra todas as requisições:

```
[REQUEST][POST] => PATH: /auth/login
[RESPONSE][200] => PATH: /auth/login
[ERROR][401] => PATH: /perfil
```

## 📱 Fluxo de Uso

### Freelancer

1. Login/Registro
2. Ver vagas disponíveis (lista ou mapa)
3. Candidatar-se a vagas
4. Ver minhas candidaturas
5. Ver perfil e avaliações

### Empresa

1. Login/Registro
2. Criar vagas
3. Ver minhas vagas
4. Ver candidatos
5. Aceitar/rejeitar candidatos
6. Ver perfil

## 🚀 Deploy

### Android

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

### Configuração de produção

No arquivo `.env`:

```
API_BASE_URL=https://api.seuapp.com
APP_ENV=production
```

## 📞 Suporte

Se encontrar problemas de integração:

1. Verifique os logs do Flutter: `flutter logs`
2. Verifique o formato dos dados retornados pelo backend
3. Certifique-se de que todas as rotas estão implementadas
4. Verifique se o CORS está configurado corretamente no backend

---

**Status de Integração:** 🟢 Pronto para integrar
