import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../data/models/avaliacao_model.dart';

class AvaliacaoCard extends StatelessWidget {
  final AvaliacaoModel avaliacao;
  final VoidCallback? onDelete;
  final VoidCallback? onReport;

  const AvaliacaoCard({
    super.key,
    required this.avaliacao,
    this.onDelete,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com foto, nome e rating
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  backgroundImage: avaliacao.avaliadorFoto != null
                      ? NetworkImage(avaliacao.avaliadorFoto!)
                      : null,
                  child: avaliacao.avaliadorFoto == null
                      ? Text(
                          _getInitials(avaliacao.avaliadorNome),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                // Nome e data
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        avaliacao.avaliadorNome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Formatters.formatRelativeTime(avaliacao.criadoEm),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Menu de opções
                if (onDelete != null || onReport != null)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete' && onDelete != null) {
                        onDelete!();
                      } else if (value == 'report' && onReport != null) {
                        onReport!();
                      }
                    },
                    itemBuilder: (context) => [
                      if (onDelete != null)
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Excluir'),
                            ],
                          ),
                        ),
                      if (onReport != null)
                        const PopupMenuItem(
                          value: 'report',
                          child: Row(
                            children: [
                              Icon(Icons.flag, size: 20, color: Colors.orange),
                              SizedBox(width: 8),
                              Text('Reportar'),
                            ],
                          ),
                        ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Rating
            RatingBarIndicator(
              rating: avaliacao.nota.toDouble(),
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 20,
            ),
            const SizedBox(height: 12),
            // Comentário
            Text(
              avaliacao.comentario,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
            // Vaga relacionada (se houver)
            if (avaliacao.vagaTitulo != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.work_outline,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        avaliacao.vagaTitulo!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}

class AvaliacaoListEmptyState extends StatelessWidget {
  const AvaliacaoListEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_border,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma avaliação ainda',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'As avaliações aparecerão aqui',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

