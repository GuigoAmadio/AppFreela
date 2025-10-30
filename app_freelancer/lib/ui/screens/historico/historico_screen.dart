import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../widgets/empty_state_widget.dart';

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});

  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  final List<Map<String, dynamic>> _trabalhos = [
    // Dados de exemplo - virão do backend
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Trabalhos'),
      ),
      body: _trabalhos.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.work_history_outlined,
              title: 'Nenhum trabalho concluído',
              message: 'Seu histórico de trabalhos aparecerá aqui',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _trabalhos.length,
              itemBuilder: (context, index) {
                final trabalho = _trabalhos[index];
                return _buildTrabalhoCard(trabalho);
              },
            ),
    );
  }

  Widget _buildTrabalhoCard(Map<String, dynamic> trabalho) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: trabalho['empresa_foto'] != null
                    ? NetworkImage(trabalho['empresa_foto'])
                    : null,
                child: trabalho['empresa_foto'] == null
                    ? const Icon(
                        Icons.business,
                        color: AppColors.primary,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trabalho['cargo'] ?? 'Cargo',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trabalho['empresa_nome'] ?? 'Empresa',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Concluído',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Período
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 8),
              Text(
                '${Formatters.formatDate(DateTime.parse(trabalho['data_inicio']))} - ${Formatters.formatDate(DateTime.parse(trabalho['data_fim']))}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Valor ganho
          Row(
            children: [
              const Icon(Icons.attach_money, size: 16),
              const SizedBox(width: 8),
              Text(
                'Ganho: ${Formatters.formatCurrency(trabalho['valor_total'] ?? 0)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Horas trabalhadas
          Row(
            children: [
              const Icon(Icons.access_time, size: 16),
              const SizedBox(width: 8),
              Text(
                '${trabalho['horas_trabalhadas'] ?? 0}h trabalhadas',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),

          // Avaliação (se houver)
          if (trabalho['avaliacao'] != null) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${trabalho['avaliacao']['nota']}/5',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    trabalho['avaliacao']['comentario'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

