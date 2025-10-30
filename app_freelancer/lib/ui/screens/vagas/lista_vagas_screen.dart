import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/vagas_provider.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/empty_state_widget.dart';
import 'widgets/vaga_card.dart';
import 'detalhe_vaga_screen.dart';

class ListaVagasScreen extends StatelessWidget {
  const ListaVagasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vagas Disponíveis'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final filtros = await Navigator.of(context).pushNamed('/filtros');
              if (filtros != null && filtros is Map<String, dynamic>) {
                // Aplicar filtros
                context.read<VagasProvider>().carregarVagas();
              }
            },
          ),
        ],
      ),
      body: Consumer<VagasProvider>(
        builder: (context, provider, _) {
          // Loading
          if (provider.isLoading) {
            return const LoadingWidget(
              message: 'Carregando vagas...',
            );
          }

          // Erro
          if (provider.erro != null) {
            return ErrorDisplayWidget(
              message: provider.erro!,
              onRetry: () => provider.carregarVagas(),
            );
          }

          // Lista vazia
          if (provider.vagas.isEmpty) {
            return const EmptyStateWidget(
              title: 'Nenhuma vaga encontrada',
              message: 'Ainda não há vagas disponíveis no momento',
              icon: Icons.work_off_outlined,
            );
          }

          // Lista de vagas
          return RefreshIndicator(
            onRefresh: () => provider.carregarVagas(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.vagas.length,
              itemBuilder: (context, index) {
                final vaga = provider.vagas[index];
                return VagaCard(
                  vaga: vaga,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetalheVagaScreen(vaga: vaga),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Criar vaga em breve (para empresas)'),
              backgroundColor: AppColors.info,
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova Vaga'),
      ),
    );
  }
}

