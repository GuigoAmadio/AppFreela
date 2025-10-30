import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/notifications_provider.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  Map<String, bool>? _preferencesNotificacoes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs =
        await context.read<NotificationsProvider>().getPreferences();
    setState(() {
      _preferencesNotificacoes = prefs?.map(
        (key, value) => MapEntry(key, value as bool),
      );
      _isLoading = false;
    });
  }

  Future<void> _updatePreferences() async {
    if (_preferencesNotificacoes == null) return;

    final success =
        await context.read<NotificationsProvider>().updatePreferences(
              candidaturasAceitas:
                  _preferencesNotificacoes!['candidaturas_aceitas'] ?? true,
              candidaturasRejeitadas:
                  _preferencesNotificacoes!['candidaturas_rejeitadas'] ?? true,
              novasVagas: _preferencesNotificacoes!['novas_vagas'] ?? true,
              mensagens: _preferencesNotificacoes!['mensagens'] ?? true,
              avaliacoes: _preferencesNotificacoes!['avaliacoes'] ?? true,
            );

    if (mounted) {
      if (success) {
        Helpers.showSuccessSnackBar(
          context,
          'Preferências atualizadas',
        );
      } else {
        Helpers.showErrorSnackBar(
          context,
          'Erro ao atualizar preferências',
        );
      }
    }
  }

  Future<void> _logout() async {
    final confirm = await Helpers.showConfirmDialog(
      context,
      title: 'Sair',
      message: 'Deseja realmente sair da sua conta?',
      confirmText: 'Sair',
      cancelText: 'Cancelar',
    );

    if (!confirm) return;

    if (mounted) {
      Helpers.showLoadingDialog(context);
      await context.read<AuthProvider>().logout();
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      }
    }
  }

  Future<void> _deleteAccount() async {
    // Primeira confirmação
    final confirm1 = await Helpers.showConfirmDialog(
      context,
      title: 'Excluir Conta',
      message:
          'Tem certeza? Esta ação é irreversível e todos os seus dados serão perdidos.',
      confirmText: 'Continuar',
      cancelText: 'Cancelar',
    );

    if (!confirm1) return;

    // Segunda confirmação com senha
    final senhaController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirme sua senha'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Para excluir sua conta, digite sua senha:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: senhaController,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Excluir Conta'),
          ),
        ],
      ),
    );

    if (confirmed != true || senhaController.text.isEmpty) return;

    try {
      Helpers.showLoadingDialog(context, message: 'Excluindo conta...');
      
      // Implementar exclusão no backend
      // await context.read<AuthProvider>().deleteAccount(senhaController.text);
      
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        
        // Mostra mensagem final
        await Helpers.showInfoDialog(
          context,
          title: 'Conta Excluída',
          message: 'Sua conta foi excluída com sucesso. Esperamos vê-lo novamente!',
        );
        
        // Vai para tela de login
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Helpers.showErrorSnackBar(
          context,
          'Erro ao excluir conta: ${Helpers.formatApiError(e)}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        children: [
          // Notificações
          _buildSecao('Notificações'),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else ...[
            _buildNotificationTile(
              'Candidaturas aceitas',
              'candidaturas_aceitas',
            ),
            _buildNotificationTile(
              'Candidaturas rejeitadas',
              'candidaturas_rejeitadas',
            ),
            _buildNotificationTile(
              'Novas vagas',
              'novas_vagas',
            ),
            _buildNotificationTile(
              'Mensagens',
              'mensagens',
            ),
            _buildNotificationTile(
              'Avaliações',
              'avaliacoes',
            ),
          ],

          const Divider(height: 32),

          // Conta
          _buildSecao('Conta'),
          _buildTile(
            icon: Icons.person_outline,
            title: 'Editar Perfil',
            onTap: () => Navigator.of(context).pushNamed('/editar-perfil'),
          ),
          _buildTile(
            icon: Icons.lock_outline,
            title: 'Alterar Senha',
            onTap: () => Navigator.of(context).pushNamed('/alterar-senha'),
          ),
          _buildTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacidade',
            onTap: () {},
          ),

          const Divider(height: 32),

          // Sobre
          _buildSecao('Sobre'),
          _buildTile(
            icon: Icons.info_outline,
            title: 'Sobre o App',
            trailing: const Text('v1.0.0'),
            onTap: () {},
          ),
          _buildTile(
            icon: Icons.description_outlined,
            title: 'Termos de Uso',
            onTap: () {},
          ),
          _buildTile(
            icon: Icons.shield_outlined,
            title: 'Política de Privacidade',
            onTap: () {},
          ),
          _buildTile(
            icon: Icons.help_outline,
            title: 'Central de Ajuda',
            onTap: () {},
          ),

          const Divider(height: 32),

          // Ações
          _buildSecao('Ações'),
          _buildTile(
            icon: Icons.logout,
            title: 'Sair',
            color: Colors.orange,
            onTap: _logout,
          ),
          _buildTile(
            icon: Icons.delete_outline,
            title: 'Excluir Conta',
            color: Colors.red,
            onTap: _deleteAccount,
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSecao(String titulo) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        titulo,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    Color? color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primary),
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildNotificationTile(String title, String key) {
    final value = _preferencesNotificacoes?[key] ?? true;

    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: (newValue) {
        setState(() {
          _preferencesNotificacoes![key] = newValue;
        });
        _updatePreferences();
      },
    );
  }
}

