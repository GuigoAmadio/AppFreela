import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/vaga_model.dart';
import '../../../data/repositories/vagas_repository.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import '../vagas/widgets/vaga_card.dart';

class CandidaturasScreen extends StatefulWidget {
  const CandidaturasScreen({super.key});

  @override
  State<CandidaturasScreen> createState() => _CandidaturasScreenState();
}

class _CandidaturasScreenState extends State<CandidaturasScreen>
    with SingleTickerProviderStateMixin {
  final _repository = VagasRepository();
  List<VagaModel>? _candidaturas;
  bool _isLoading = true;
  String? _error;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCandidaturas();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCandidaturas() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final candidaturas = await _repository.getMinhasCandidaturas();

      setState(() {
        _candidaturas = candidaturas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = Helpers.formatApiError(e);
        _isLoading = false;
      });
    }
  }

  Future<void> _cancelarCandidatura(String vagaId) async {
    final confirm = await Helpers.showConfirmDialog(
      context,
      title: 'Cancelar candidatura',
      message: 'Tem certeza que deseja cancelar sua candidatura?',
      confirmText: 'Cancelar candidatura',
      cancelText: 'Voltar',
    );

    if (!confirm) return;

    try {
      Helpers.showLoadingDialog(context, message: 'Cancelando...');
      await _repository.removerCandidatura(vagaId);
      
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Helpers.showSuccessSnackBar(context, 'Candidatura cancelada');
        _loadCandidaturas();
      }
    } catch (e) {
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Helpers.showErrorSnackBar(context, Helpers.formatApiError(e));
      }
    }
  }

  void _navigateToVagaDetalhes(String vagaId) {
    Navigator.of(context).pushNamed('/vaga-detalhes', arguments: vagaId);
  }

  List<VagaModel> _filterByStatus(String status) {
    if (_candidaturas == null) return [];
    return _candidaturas!
        .where((vaga) => vaga.statusCandidatura == status)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Candidaturas'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pendentes'),
            Tab(text: 'Aceitas'),
            Tab(text: 'Recusadas'),
          ],
        ),
      ),
      body: _isLoading
          ? const LoadingWidget()
          : _error != null
              ? CustomErrorWidget(
                  message: _error!,
                  onRetry: _loadCandidaturas,
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildCandidaturasList('pendente'),
                    _buildCandidaturasList('aceito'),
                    _buildCandidaturasList('rejeitado'),
                  ],
                ),
    );
  }

  Widget _buildCandidaturasList(String status) {
    final candidaturas = _filterByStatus(status);

    if (candidaturas.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.work_off_outlined,
        title: 'Nenhuma candidatura $status',
        message: 'Você não tem candidaturas com este status',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCandidaturas,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: candidaturas.length,
        itemBuilder: (context, index) {
          final vaga = candidaturas[index];
          return Column(
            children: [
              VagaCard(
                vaga: vaga,
                onTap: () => _navigateToVagaDetalhes(vaga.id),
                trailing: _buildStatusChip(vaga.statusCandidatura ?? status),
              ),
              if (status == 'pendente')
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: OutlinedButton.icon(
                    onPressed: () => _cancelarCandidatura(vaga.id),
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: const Text('Cancelar Candidatura'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              if (status != 'pendente') const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'pendente':
        color = Colors.orange;
        label = 'Pendente';
        icon = Icons.schedule;
        break;
      case 'aceito':
      case 'aceita':
        color = Colors.green;
        label = 'Aceita';
        icon = Icons.check_circle;
        break;
      case 'rejeitado':
      case 'rejeitada':
        color = Colors.red;
        label = 'Recusada';
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        label = status;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

