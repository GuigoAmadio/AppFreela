# Script para testar o App Freelancer
# Uso: .\testar-app.ps1

Write-Host "🚀 Iniciando App Freelancer..." -ForegroundColor Cyan
Write-Host ""

# Verificar se está no diretório correto
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "❌ Erro: Execute este script na pasta app_freelancer" -ForegroundColor Red
    exit 1
}

Write-Host "📦 Instalando dependências..." -ForegroundColor Yellow
flutter pub get

Write-Host ""
Write-Host "✨ Escolha uma opção:" -ForegroundColor Green
Write-Host "1. Chrome (Recomendado - mais rápido)" -ForegroundColor White
Write-Host "2. Windows Desktop" -ForegroundColor White
Write-Host "3. Listar dispositivos disponíveis" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Digite sua escolha (1-3)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "🌐 Iniciando no Chrome..." -ForegroundColor Cyan
        Write-Host ""
        Write-Host "📝 Login de teste:" -ForegroundColor Yellow
        Write-Host "   Email: joao@email.com" -ForegroundColor White
        Write-Host "   Senha: 123456" -ForegroundColor White
        Write-Host ""
        flutter run -d chrome
    }
    "2" {
        Write-Host ""
        Write-Host "💻 Iniciando no Windows..." -ForegroundColor Cyan
        Write-Host ""
        Write-Host "📝 Login de teste:" -ForegroundColor Yellow
        Write-Host "   Email: joao@email.com" -ForegroundColor White
        Write-Host "   Senha: 123456" -ForegroundColor White
        Write-Host ""
        flutter run -d windows
    }
    "3" {
        Write-Host ""
        Write-Host "📱 Dispositivos disponíveis:" -ForegroundColor Cyan
        flutter devices
        Write-Host ""
        Write-Host "💡 Dica: Use 'flutter run -d <device-id>' para rodar" -ForegroundColor Yellow
    }
    default {
        Write-Host ""
        Write-Host "❌ Opção inválida!" -ForegroundColor Red
        Write-Host "💡 Execute o script novamente" -ForegroundColor Yellow
    }
}

