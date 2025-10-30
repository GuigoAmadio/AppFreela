import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/validators.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key});

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    final usuario = context.read<AuthProvider>().usuario;
    if (usuario != null) {
      _nomeController.text = usuario.nome;
      _telefoneController.text = usuario.telefone ?? '';
      // _bioController.text = usuario.bio ?? '';
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await context.read<AuthProvider>().updateProfile({
        'nome': _nomeController.text,
        'telefone': _telefoneController.text,
        'bio': _bioController.text,
      });

      if (mounted) {
        Helpers.showSuccessSnackBar(context, 'Perfil atualizado com sucesso');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        Helpers.showErrorSnackBar(
          context,
          Helpers.formatApiError(e),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _alterarFoto() async {
    final opcao = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Escolher da galeria'),
              onTap: () => Navigator.pop(context, 'galeria'),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tirar foto'),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            if (context.read<AuthProvider>().usuario?.fotoUrl != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remover foto'),
                onTap: () => Navigator.pop(context, 'remover'),
              ),
          ],
        ),
      ),
    );

    if (opcao == null) return;

    try {
      Helpers.showLoadingDialog(context, message: 'Atualizando foto...');
      
      // Implementar upload real de foto
      // final filePath = await pickImage(opcao);
      // await context.read<AuthProvider>().updateProfilePhoto(filePath);
      
      await Future.delayed(const Duration(seconds: 1)); // Simula upload
      
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Helpers.showSuccessSnackBar(context, 'Foto atualizada');
      }
    } catch (e) {
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Helpers.showErrorSnackBar(context, 'Erro ao atualizar foto');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthProvider>().usuario;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Foto
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: usuario?.fotoUrl != null
                        ? NetworkImage(usuario!.fotoUrl!)
                        : null,
                    child: usuario?.fotoUrl == null
                        ? Text(
                            Helpers.getInitials(usuario?.nome ?? ''),
                            style: const TextStyle(fontSize: 32),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 20),
                        color: Colors.white,
                        onPressed: _alterarFoto,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Nome
            CustomTextField(
              controller: _nomeController,
              label: 'Nome',
              validator: Validators.validateName,
            ),
            const SizedBox(height: 16),

            // Telefone
            CustomTextField(
              controller: _telefoneController,
              label: 'Telefone',
              keyboardType: TextInputType.phone,
              validator: Validators.validatePhone,
            ),
            const SizedBox(height: 16),

            // Bio
            CustomTextField(
              controller: _bioController,
              label: 'Biografia',
              hint: 'Conte um pouco sobre você...',
              maxLines: 4,
            ),
            const SizedBox(height: 32),

            // Botões
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Cancelar',
                    onPressed: () => Navigator.of(context).pop(),
                    isOutlined: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: 'Salvar',
                    onPressed: _salvar,
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

