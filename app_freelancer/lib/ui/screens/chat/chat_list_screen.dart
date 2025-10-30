import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/mensagem_model.dart';
import '../../../providers/chat_provider.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    _loadConversas();
  }

  Future<void> _loadConversas() async {
    await context.read<ChatProvider>().loadConversas();
  }

  void _openConversa(ConversaModel conversa) {
    Navigator.of(context).pushNamed(
      '/chat',
      arguments: {
        'conversaId': conversa.id,
        'outroUsuarioNome': conversa.outroUsuarioNome,
        'outroUsuarioFoto': conversa.outroUsuarioFoto,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensagens'),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingWidget();
          }

          if (provider.error != null) {
            return CustomErrorWidget(
              message: provider.error!,
              onRetry: _loadConversas,
            );
          }

          if (provider.conversas.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.chat_bubble_outline,
              title: 'Nenhuma conversa',
              message: 'Suas conversas aparecerão aqui',
            );
          }

          return RefreshIndicator(
            onRefresh: _loadConversas,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: provider.conversas.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final conversa = provider.conversas[index];
                return _buildConversaItem(conversa);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildConversaItem(ConversaModel conversa) {
    return ListTile(
      onTap: () => _openConversa(conversa),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: conversa.outroUsuarioFoto != null
                ? NetworkImage(conversa.outroUsuarioFoto!)
                : null,
            child: conversa.outroUsuarioFoto == null
                ? Text(
                    Helpers.getInitials(conversa.outroUsuarioNome),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          if (conversa.naoLidas > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Text(
                  conversa.naoLidas > 9 ? '9+' : '${conversa.naoLidas}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              conversa.outroUsuarioNome,
              style: TextStyle(
                fontWeight: conversa.naoLidas > 0
                    ? FontWeight.bold
                    : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (conversa.ultimaMensagem != null)
            Text(
              Formatters.formatRelativeTime(
                conversa.ultimaMensagem!.criadoEm,
              ),
              style: TextStyle(
                fontSize: 12,
                color: conversa.naoLidas > 0
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (conversa.vagaTitulo != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.work_outline,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    conversa.vagaTitulo!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          if (conversa.ultimaMensagem != null) ...[
            const SizedBox(height: 4),
            Text(
              conversa.ultimaMensagem!.texto,
              style: TextStyle(
                fontSize: 14,
                color: conversa.naoLidas > 0
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: conversa.naoLidas > 0
                    ? FontWeight.w500
                    : FontWeight.normal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

