import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/helpers.dart';
import '../../../providers/favoritos_provider.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import '../vagas/widgets/vaga_card.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  @override
  void initState() {
    super.initState();
    _loadFavoritos();
  }

  Future<void> _loadFavoritos() async {
    await context.read<FavoritosProvider>().loadFavoritos();
  }

  Future<void> _removeFavorito(String vagaId) async {
    final success =
        await context.read<FavoritosProvider>().removeFavorito(vagaId);

    if (mounted) {
      if (success) {
        Helpers.showSuccessSnackBar(context, 'Removido dos favoritos');
      } else {
        Helpers.showErrorSnackBar(context, 'Erro ao remover favorito');
      }
    }
  }

  void _navigateToVaga(String vagaId) {
    Navigator.of(context).pushNamed('/vaga-detalhes', arguments: vagaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vagas Favoritas'),
      ),
      body: Consumer<FavoritosProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingWidget();
          }

          if (provider.error != null) {
            return CustomErrorWidget(
              message: provider.error!,
              onRetry: _loadFavoritos,
            );
          }

          if (provider.favoritos.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.favorite_border,
              title: 'Nenhum favorito',
              message: 'Adicione vagas aos favoritos para vê-las aqui',
            );
          }

          return RefreshIndicator(
            onRefresh: _loadFavoritos,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.favoritos.length,
              itemBuilder: (context, index) {
                final vaga = provider.favoritos[index];
                return Dismissible(
                  key: Key(vaga.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) => _removeFavorito(vaga.id),
                  child: VagaCard(
                    vaga: vaga,
                    onTap: () => _navigateToVaga(vaga.id),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () => _removeFavorito(vaga.id),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

