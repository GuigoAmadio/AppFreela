# 🔧 Resolver Erro de Symlink no Windows

## ⚠️ Erro que você recebeu:

```
Building with plugins requires symlink support.
Please enable Developer Mode in your system settings.
```

---

## ✅ SOLUÇÃO RÁPIDA (30 segundos)

### Método 1: Via Comando (RECOMENDADO)

1. **Execute este comando** no PowerShell:

```powershell
start ms-settings:developers
```

2. Na janela que abrir:
   - Ative o botão **"Modo de Desenvolvedor"**
   - Aguarde a instalação (alguns segundos)
   - Pronto! ✅

### Método 2: Manualmente

1. Pressione **Win + I** (abre Configurações)
2. Vá em **Privacidade e Segurança** → **Para desenvolvedores**
3. Ative **"Modo de Desenvolvedor"**
4. Aguarde a instalação
5. Pronto! ✅

---

## 🚀 DEPOIS DE ATIVAR

Execute novamente:

```powershell
flutter run -d chrome
```

**OU** se preferir Windows desktop:

```powershell
flutter run -d windows
```

---

## 📝 SOBRE AS ATUALIZAÇÕES DE PACOTES

Você viu esta mensagem:

```
39 packages have newer versions incompatible with dependency constraints.
```

**Isso é NORMAL!** ✅

- Os pacotes atuais funcionam perfeitamente
- As versões mais novas podem ter breaking changes
- Não precisa atualizar agora

**Se quiser atualizar depois:**

```powershell
flutter pub outdated       # Ver quais estão desatualizados
flutter pub upgrade        # Atualizar (cuidado com breaking changes)
```

---

## 🎯 PRÓXIMOS PASSOS

1. ✅ Ative o Modo Desenvolvedor (acima)
2. ✅ Execute: `flutter run -d chrome`
3. ✅ Faça login com: `joao@email.com` / `123456`
4. ✅ Teste todas as funcionalidades!

---

## 🐛 SE DER OUTRO ERRO

### Erro: "No devices found"

```powershell
# Para web (Chrome)
flutter run -d chrome

# Para Windows desktop
flutter run -d windows

# Listar dispositivos disponíveis
flutter devices
```

### Erro: "Gradle build failed"

```powershell
flutter clean
flutter pub get
flutter run
```

### Erro: "Cannot find Chrome"

```powershell
# Rode no Windows desktop ao invés
flutter run -d windows
```

---

## 💡 DICA

**Melhor opção para testar agora:** Chrome

```powershell
flutter run -d chrome
```

Por quê?

- ✅ Não precisa de emulador Android
- ✅ Mais rápido para testar
- ✅ DevTools integrado
- ✅ Hot reload instantâneo

---

## 🎉 TUDO PRONTO!

Após ativar o Modo Desenvolvedor, você está pronto para testar o app completo! 🚀
