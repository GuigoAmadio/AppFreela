import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/mensagem_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/chat_provider.dart';
import '../../widgets/loading_widget.dart';

class ChatScreen extends StatefulWidget {
  final String conversaId;
  final String outroUsuarioNome;
  final String? outroUsuarioFoto;

  const ChatScreen({
    super.key,
    required this.conversaId,
    required this.outroUsuarioNome,
    this.outroUsuarioFoto,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadMensagens();
    _marcarComoLida();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMensagens() async {
    await context.read<ChatProvider>().loadMensagens(widget.conversaId);
    _scrollToBottom();
  }

  Future<void> _marcarComoLida() async {
    await context.read<ChatProvider>().marcarComoLida(widget.conversaId);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _enviarMensagem() async {
    final texto = _messageController.text.trim();
    if (texto.isEmpty) return;

    setState(() => _isSending = true);

    final success = await context.read<ChatProvider>().enviarMensagem(
          conversaId: widget.conversaId,
          texto: texto,
        );

    if (success) {
      _messageController.clear();
      _scrollToBottom();
    } else if (mounted) {
      Helpers.showErrorSnackBar(
        context,
        'Erro ao enviar mensagem',
      );
    }

    setState(() => _isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthProvider>().usuario?.id;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              backgroundImage: widget.outroUsuarioFoto != null
                  ? NetworkImage(widget.outroUsuarioFoto!)
                  : null,
              child: widget.outroUsuarioFoto == null
                  ? Text(
                      Helpers.getInitials(widget.outroUsuarioNome),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.outroUsuarioNome,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showOptions(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Lista de mensagens
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, provider, child) {
                final mensagens = provider.getMensagens(widget.conversaId);

                if (mensagens.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma mensagem ainda'),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: mensagens.length,
                  itemBuilder: (context, index) {
                    final mensagem = mensagens[index];
                    final isMine = mensagem.remetenteId == currentUserId;
                    
                    return _buildMensagemItem(mensagem, isMine);
                  },
                );
              },
            ),
          ),

          // Campo de entrada
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: _isSending ? null : _anexarArquivo,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Digite uma mensagem...',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      enabled: !_isSending,
                      onSubmitted: (_) => _enviarMensagem(),
                    ),
                  ),
                  IconButton(
                    icon: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                    onPressed: _isSending ? null : _enviarMensagem,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMensagemItem(MensagemModel mensagem, bool isMine) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMine ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMine ? 16 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mensagem.texto,
              style: TextStyle(
                color: isMine ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Formatters.formatTime(mensagem.criadoEm),
                  style: TextStyle(
                    color: isMine ? Colors.white70 : Colors.black54,
                    fontSize: 11,
                  ),
                ),
                if (isMine) ...[
                  const SizedBox(width: 4),
                  Icon(
                    mensagem.lida ? Icons.done_all : Icons.done,
                    size: 14,
                    color: mensagem.lida ? Colors.blue[300] : Colors.white70,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _anexarArquivo() async {
    // Mostra opções de anexo
    final opcao = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeria'),
              onTap: () => Navigator.pop(context, 'galeria'),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Câmera'),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text('Arquivo'),
              onTap: () => Navigator.pop(context, 'arquivo'),
            ),
          ],
        ),
      ),
    );

    if (opcao == null) return;

    try {
      Helpers.showLoadingDialog(context, message: 'Enviando...');

      // Aqui você implementaria o upload real usando image_picker ou file_picker
      // Por enquanto, simula o upload
      await Future.delayed(const Duration(seconds: 1));
      
      final chatProvider = context.read<ChatProvider>();
      // final anexoUrl = await chatProvider.uploadAnexo(filePath);
      
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        // await _enviarMensagem(); // Envia com anexo
        Helpers.showSuccessSnackBar(context, 'Anexo enviado');
      }
    } catch (e) {
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Helpers.showErrorSnackBar(context, 'Erro ao enviar anexo');
      }
    }
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text('Bloquear usuário'),
              onTap: () {
                Navigator.pop(context);
                _bloquearUsuario();
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag, color: Colors.orange),
              title: const Text('Reportar conversa'),
              onTap: () {
                Navigator.pop(context);
                _reportarConversa();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Limpar conversa'),
              onTap: () {
                Navigator.pop(context);
                _limparConversa();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _bloquearUsuario() async {
    final confirm = await Helpers.showConfirmDialog(
      context,
      title: 'Bloquear usuário',
      message: 'Deseja bloquear ${widget.outroUsuarioNome}? Você não receberá mais mensagens desta pessoa.',
      confirmText: 'Bloquear',
      cancelText: 'Cancelar',
    );

    if (!confirm) return;

    try {
      Helpers.showLoadingDialog(context);
      // Implementar bloqueio no backend
      // await context.read<ChatProvider>().bloquearUsuario(widget.outroUsuarioId);
      
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Helpers.showSuccessSnackBar(context, 'Usuário bloqueado');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Helpers.showErrorSnackBar(context, 'Erro ao bloquear usuário');
      }
    }
  }

  Future<void> _reportarConversa() async {
    final motivoController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reportar conversa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Por que você está reportando esta conversa?'),
            const SizedBox(height: 16),
            TextField(
              controller: motivoController,
              decoration: const InputDecoration(
                labelText: 'Motivo',
                hintText: 'Descreva o problema...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
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
            child: const Text('Reportar'),
          ),
        ],
      ),
    );

    if (confirmed != true || motivoController.text.isEmpty) return;

    try {
      Helpers.showLoadingDialog(context);
      // Implementar report no backend
      // await context.read<ChatProvider>().reportarConversa(widget.conversaId, motivoController.text);
      
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Helpers.showSuccessSnackBar(context, 'Conversa reportada. Obrigado!');
      }
    } catch (e) {
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Helpers.showErrorSnackBar(context, 'Erro ao reportar conversa');
      }
    }
  }

  Future<void> _limparConversa() async {
    final confirm = await Helpers.showConfirmDialog(
      context,
      title: 'Limpar conversa',
      message: 'Deseja apagar todas as mensagens desta conversa? Esta ação não pode ser desfeita.',
      confirmText: 'Limpar',
      cancelText: 'Cancelar',
    );

    if (!confirm) return;

    try {
      Helpers.showLoadingDialog(context);
      // Implementar limpeza no backend
      // await context.read<ChatProvider>().limparConversa(widget.conversaId);
      
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Helpers.showSuccessSnackBar(context, 'Conversa limpa');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Helpers.showErrorSnackBar(context, 'Erro ao limpar conversa');
      }
    }
  }
}

