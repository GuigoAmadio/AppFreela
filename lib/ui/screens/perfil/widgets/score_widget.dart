import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ScoreWidget extends StatelessWidget {
  final double score;
  final int totalAvaliacoes;
  final bool showDetails;
  final double size;

  const ScoreWidget({
    super.key,
    required this.score,
    required this.totalAvaliacoes,
    this.showDetails = true,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Círculo com score
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: _getGradientColors(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: _getScoreColor().withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  score.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: size * 0.35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.star,
                  size: size * 0.25,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        
        // Detalhes
        if (showDetails) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star,
                size: 16,
                color: _getScoreColor(),
              ),
              const SizedBox(width: 4),
              Text(
                score.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _getScoreColor(),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '($totalAvaliacoes ${totalAvaliacoes == 1 ? 'avaliação' : 'avaliações'})',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Color _getScoreColor() {
    if (score >= 4.5) return Colors.green;
    if (score >= 4.0) return Colors.lightGreen;
    if (score >= 3.5) return Colors.orange;
    if (score >= 3.0) return Colors.deepOrange;
    return Colors.red;
  }

  List<Color> _getGradientColors() {
    final baseColor = _getScoreColor();
    return [
      baseColor,
      baseColor.withOpacity(0.7),
    ];
  }
}

class ScoreBarWidget extends StatelessWidget {
  final Map<int, int> distribuicao; // {nota: quantidade}
  final int totalAvaliacoes;

  const ScoreBarWidget({
    super.key,
    required this.distribuicao,
    required this.totalAvaliacoes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 5; i >= 1; i--)
          _buildScoreLine(i, distribuicao[i] ?? 0),
      ],
    );
  }

  Widget _buildScoreLine(int stars, int count) {
    final percentage = totalAvaliacoes > 0 ? count / totalAvaliacoes : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Número de estrelas
          Text(
            '$stars',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star, size: 12, color: Colors.amber),
          const SizedBox(width: 8),
          // Barra de progresso
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 8,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getColorForStars(stars),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Contagem
          SizedBox(
            width: 30,
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForStars(int stars) {
    if (stars >= 4) return Colors.green;
    if (stars == 3) return Colors.orange;
    return Colors.red;
  }
}

