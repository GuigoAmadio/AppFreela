# Exemplo de arquivo .env

Crie um arquivo `.env` na raiz do projeto com as seguintes variáveis:

```env
# API Configuration
API_BASE_URL=http://localhost:8080/api

# Mapbox Configuration
MAPBOX_ACCESS_TOKEN=pk.your_mapbox_token_here

# Environment
APP_ENV=development

# Optional: Analytics
# ANALYTICS_KEY=your_analytics_key

# Optional: Sentry (Error Tracking)
# SENTRY_DSN=your_sentry_dsn
```

## Como obter o Mapbox Token:

1. Acesse https://account.mapbox.com/
2. Crie uma conta gratuita
3. Vá em "Access tokens"
4. Copie o token padrão ou crie um novo
5. Cole o token no campo `MAPBOX_ACCESS_TOKEN`

## Configuração da API:

- Para desenvolvimento local: `http://localhost:8080/api`
- Para produção: substitua pela URL da sua API em produção
