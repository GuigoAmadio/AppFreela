import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/repositories/vagas_repository.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';

class CandidatosScreen extends StatefulWidget {
  final String vagaId;
  final String vagaTitulo;

  const CandidatosScreen({
    super.key,
    required this.vagaId,
    required this.vagaTitulo,
  });

  @override
  State<CandidatosScreen> createState() => _CandidatosScreenState();
}

class _CandidatosScreenState extends State<CandidatosScreen> {
  final _repository = VagasRepository();
  List<dynamic>? _candidatos;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCandidatos();
  }

  Future<void> _loadCandidatos() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final candidatos = await _repository.getCandidatos(widget.vagaId);

      setState(() {
        _candidatos = candidatos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = Helpers.formatApiError(e);
        _isLoading = false;
      });
    }
  }

  Future<void> _aceitarCandidato(String usuarioId) async {
    final confirm = await Helpers.showConfirmDialog(
      context,
      title: 'Aceitar candidato',
      message: 'Deseja aceitar este candidato para a vaga?',
      confirmText: 'Aceitar',
      cancelText: 'Cancelar',
    );

    if (!confirm) return;

    try {
      Helpers.showLoadingDialog(context);
      await _repository.aceitarCandidato(
        vagaId: widget.vagaId,
        usuarioId: usuarioId,
      );
      
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Helpers.showSuccessSnackBar(context, 'Candidato aceito com sucesso');
        _loadCandidatos();
      }
    } catch (e) {
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Helpers.showErrorSnackBar(context, Helpers.formatApiError(e));
      }
    }
  }

  Future<void> _rejeitarCandidato(String usuarioId) async {
    final confirm = await Helpers.showConfirmDialog(
      context,
      title: 'Rejeitar candidato',
      message: 'Deseja rejeitar este candidato?',
      confirmText: 'Rejeitar',
      cancelText: 'Cancelar',
    );

    if (!confirm) return;

    try {
      Helpers.showLoadingDialog(context);
      await _repository.rejeitarCandidato(
        vagaId: widget.vagaId,
        usuarioId: usuarioId,
      );
      
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Helpers.showSuccessSnackBar(context, 'Candidato rejeitado');
        _loadCandidatos();
      }
    } catch (e) {
      if (mounted) {
        Helpers.hideLoadingDialog(context);
        Helpers.showErrorSnackBar(context, Helpers.formatApiError(e));
      }
    }
  }

  void _viewProfile(String usuarioId) {
    Navigator.of(context).pushNamed('/perfil', arguments: usuarioId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Candidatos'),
            Text(
              widget.vagaTitulo,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const LoadingWidget()
          : _error != null
              ? CustomErrorWidget(
                  message: _error!,
                  onRetry: _loadCandidatos,
                )
              : _candidatos == null || _candidatos!.isEmpty
                  ? const EmptyStateWidget(
                      icon: Icons.person_off_outlined,
                      title: 'Nenhum candidato',
                      message: 'Ainda não há candidatos para esta vaga',
                    )
                  : RefreshIndicator(
                      onRefresh: _loadCandidatos,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _candidatos!.length,
                        itemBuilder: (context, index) {
                          final candidato = _candidatos![index];
                          return _buildCandidatoCard(candidato);
                        },
                      ),
                    ),
    );
  }

  Widget _buildCandidatoCard(Map<String, dynamic> candidato) {
    final usuario = candidato['usuario'];
    final status = candidato['status'] ?? 'pendente';
    final dataCandidatura = DateTime.parse(candidato['created_at']);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _viewProfile(usuario['id']),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com foto e informações
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    backgroundImage: usuario['foto_url'] != null
                        ? NetworkImage(usuario['foto_url'])
                        : null,
                    child: usuario['foto_url'] == null
                        ? Text(
                            Helpers.getInitials(usuario['nome']),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  // Nome e avaliação
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          usuario['nome'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${usuario['media_avaliacoes'] ?? 0.0} (${usuario['total_avaliacoes'] ?? 0})',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Candidatura: ${Formatters.formatRelativeTime(dataCandidatura)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status badge
                  _buildStatusBadge(status),
                ],
              ),
              
              // Informações adicionais
              if (usuario['telefone'] != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      Formatters.formatPhone(usuario['telefone']),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
              
              if (usuario['email'] != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.email,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        usuario['email'],
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              
              // Botões de ação (apenas para candidaturas pendentes)
              if (status == 'pendente') ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _rejeitarCandidato(usuario['id']),
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('Rejeitar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _aceitarCandidato(usuario['id']),
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Aceitar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status.toLowerCase()) {
      case 'pendente':
        color = Colors.orange;
        label = 'Pendente';
        break;
      case 'aceito':
        color = Colors.green;
        label = 'Aceito';
        break;
      case 'rejeitado':
        color = Colors.red;
        label = 'Rejeitado';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

