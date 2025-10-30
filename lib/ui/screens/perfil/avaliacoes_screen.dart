import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/avaliacao_model.dart';
import '../../../data/repositories/avaliacoes_repository.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import 'widgets/avaliacao_card.dart';
import 'widgets/score_widget.dart';

class AvaliacoesScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const AvaliacoesScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<AvaliacoesScreen> createState() => _AvaliacoesScreenState();
}

class _AvaliacoesScreenState extends State<AvaliacoesScreen> {
  final _repository = AvaliacoesRepository();
  List<AvaliacaoModel>? _avaliacoes;
  bool _isLoading = true;
  String? _error;
  double _mediaAvaliacoes = 0.0;

  @override
  void initState() {
    super.initState();
    _loadAvaliacoes();
  }

  Future<void> _loadAvaliacoes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final avaliacoes = await _repository.getAvaliacoes(widget.userId);
      final media = await _repository.getMediaAvaliacoes(widget.userId);

      setState(() {
        _avaliacoes = avaliacoes;
        _mediaAvaliacoes = media;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = Helpers.formatApiError(e);
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteAvaliacao(String avaliacaoId) async {
    final confirm = await Helpers.showConfirmDialog(
      context,
      title: 'Excluir avaliação',
      message: 'Tem certeza que deseja excluir esta avaliação?',
      confirmText: 'Excluir',
      cancelText: 'Cancelar',
    );

    if (!confirm) return;

    try {
      Helpers.showLoadingDialog(context);
      await _repository.deletarAvaliacao(avaliacaoId);
      
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Helpers.showSuccessSnackBar(context, 'Avaliação excluída com sucesso');
        _loadAvaliacoes();
      }
    } catch (e) {
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Helpers.showErrorSnackBar(context, Helpers.formatApiError(e));
      }
    }
  }

  Future<void> _reportAvaliacao(String avaliacaoId) async {
    final motivoController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reportar avaliação'),
        content: TextField(
          controller: motivoController,
          decoration: const InputDecoration(
            labelText: 'Motivo do reporte',
            hintText: 'Descreva o motivo...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
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
            child: const Text('Reportar'),
          ),
        ],
      ),
    );

    if (confirmed != true || motivoController.text.isEmpty) return;

    try {
      Helpers.showLoadingDialog(context);
      await _repository.reportarAvaliacao(
        avaliacaoId: avaliacaoId,
        motivo: motivoController.text,
      );
      
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Helpers.showSuccessSnackBar(context, 'Avaliação reportada com sucesso');
      }
    } catch (e) {
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Helpers.showErrorSnackBar(context, Helpers.formatApiError(e));
      }
    }
  }

  Map<int, int> _getDistribuicao() {
    if (_avaliacoes == null) return {};
    
    final dist = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final avaliacao in _avaliacoes!) {
      dist[avaliacao.nota] = (dist[avaliacao.nota] ?? 0) + 1;
    }
    return dist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliações de ${widget.userName}'),
      ),
      body: _isLoading
          ? const LoadingWidget()
          : _error != null
              ? CustomErrorWidget(
                  message: _error!,
                  onRetry: _loadAvaliacoes,
                )
              : _avaliacoes == null || _avaliacoes!.isEmpty
                  ? const AvaliacaoListEmptyState()
                  : RefreshIndicator(
                      onRefresh: _loadAvaliacoes,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Resumo de avaliações
                          _buildResumo(),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 16),
                          // Lista de avaliações
                          ..._avaliacoes!.map(
                            (avaliacao) => AvaliacaoCard(
                              avaliacao: avaliacao,
                              onDelete: () => _deleteAvaliacao(avaliacao.id),
                              onReport: () => _reportAvaliacao(avaliacao.id),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildResumo() {
    final total = _avaliacoes?.length ?? 0;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Score principal
            ScoreWidget(
              score: _mediaAvaliacoes,
              totalAvaliacoes: total,
              size: 80,
            ),
            const SizedBox(height: 24),
            // Distribuição por estrelas
            ScoreBarWidget(
              distribuicao: _getDistribuicao(),
              totalAvaliacoes: total,
            ),
          ],
        ),
      ),
    );
  }
}

