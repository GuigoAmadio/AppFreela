import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/vaga_model.dart';
import '../../../providers/vagas_provider.dart';
import '../../widgets/custom_button.dart';

class DetalheVagaScreen extends StatelessWidget {
  final VagaModel vaga;

  const DetalheVagaScreen({
    super.key,
    required this.vaga,
  });

  Future<void> _compartilharVaga(BuildContext context, VagaModel vaga) async {
    final texto = '''
🚀 Vaga Disponível!

📌 ${vaga.titulo}
💰 ${Formatters.formatCurrency(vaga.preco)}
🏢 ${vaga.empresaNome}
📅 ${Formatters.formatDate(vaga.data)}

Baixe o app FreeLancer para se candidatar!
''';

    await Helpers.copyToClipboard(
      context,
      texto,
      successMessage: 'Link da vaga copiado!',
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final formatoData = DateFormat('dd/MM/yyyy \'às\' HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Vaga'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header com foto da empresa
            Container(
              height: 200,
              color: AppColors.primary.withOpacity(0.1),
              child: const Center(
                child: Icon(
                  Icons.business,
                  size: 80,
                  color: AppColors.primary,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome da empresa
                  Text(
                    vaga.empresaNome,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Título
                  Text(
                    vaga.titulo,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Informações rápidas
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: Icons.calendar_today,
                        label: formatoData.format(vaga.data),
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        icon: Icons.people_outline,
                        label: '${vaga.candidatos} candidatos',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Preço em destaque
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Valor oferecido:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          formatoMoeda.format(vaga.preco),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Descrição
                  const Text(
                    'Descrição',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    vaga.descricao,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Status
                  const Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: vaga.isAberta
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.textLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      vaga.isAberta ? 'Vaga Aberta' : 'Vaga Fechada',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: vaga.isAberta
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Botão de candidatura
                  CustomButton(
                    text: 'Candidatar-se',
                    onPressed: () => _handleCandidatura(context),
                    icon: Icons.check_circle_outline,
                  ),
                  const SizedBox(height: 12),

                  // Botão de compartilhar
                  CustomButton(
                    text: 'Compartilhar Vaga',
                      onPressed: () async {
                        await _compartilharVaga(context, vaga);
                      },
                    isOutlined: true,
                    icon: Icons.share,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCandidatura(BuildContext context) async {
    final provider = context.read<VagasProvider>();
    
    final success = await provider.candidatar(vaga.id);
    
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Candidatura enviada com sucesso!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Voltar para lista
      Navigator.of(context).pop();
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.erro ?? 'Erro ao candidatar'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

