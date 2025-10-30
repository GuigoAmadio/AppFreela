import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/vaga_model.dart';
import '../../../providers/vagas_provider.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_widget.dart';
import '../vagas/widgets/vaga_card.dart';

class BuscaScreen extends StatefulWidget {
  const BuscaScreen({super.key});

  @override
  State<BuscaScreen> createState() => _BuscaScreenState();
}

class _BuscaScreenState extends State<BuscaScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<VagaModel> _resultados = [];
  bool _isSearching = false;
  bool _hasSearched = false;

  final List<String> _historicoB usca = [];
  final List<String> _buscasPopulares = [
    'Garçom',
    'Cozinheiro',
    'Bartender',
    'Recepcionista',
    'Gerente',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _buscar(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
      _hasSearched = true;
    });

    // Adiciona ao histórico
    if (!_historicoBusca.contains(query)) {
      _historicoBusca.insert(0, query);
      if (_historicoBusca.length > 10) {
        _historicoBusca.removeLast();
      }
    }

    try {
      await context.read<VagasProvider>().loadVagas(cargo: query);
      _resultados = context.read<VagasProvider>().vagas;
    } catch (e) {
      if (mounted) {
        Helpers.showErrorSnackBar(
          context,
          Helpers.formatApiError(e),
        );
      }
    } finally {
      setState(() => _isSearching = false);
    }
  }

  void _limparBusca() {
    setState(() {
      _searchController.clear();
      _resultados = [];
      _hasSearched = false;
    });
  }

  void _navigateToVaga(String vagaId) {
    Navigator.of(context).pushNamed('/vaga-detalhes', arguments: vagaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar vagas...',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.grey[400],
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _limparBusca,
                  )
                : null,
          ),
          style: const TextStyle(fontSize: 16),
          textInputAction: TextInputAction.search,
          onSubmitted: _buscar,
          onChanged: (value) => setState(() {}),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _buscar(_searchController.text),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final filtros = await Navigator.of(context).pushNamed('/filtros');
              if (filtros != null) {
                // Aplicar filtros
              }
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (!_hasSearched) {
      return _buildInicial();
    }

    if (_isSearching) {
      return const LoadingWidget();
    }

    if (_resultados.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.search_off,
        title: 'Nenhum resultado',
        message: 'Não encontramos vagas para "${_searchController.text}"',
      );
    }

    return _buildResultados();
  }

  Widget _buildInicial() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Buscas populares
        if (_buscasPopulares.isNotEmpty) ...[
          const Text(
            'Buscas Populares',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _buscasPopulares.map((busca) {
              return ActionChip(
                label: Text(busca),
                onPressed: () {
                  _searchController.text = busca;
                  _buscar(busca);
                },
                backgroundColor: AppColors.primary.withOpacity(0.1),
                labelStyle: const TextStyle(color: AppColors.primary),
              );
            }).toList(),
          ),
        ],

        // Histórico
        if (_historicoBusca.isNotEmpty) ...[
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Buscas Recentes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() => _historicoBusca.clear());
                },
                child: const Text('Limpar'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...List historicoBusca.map((busca) {
            return ListTile(
              leading: const Icon(Icons.history),
              title: Text(busca),
              trailing: IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () {
                  setState(() => _historicoBusca.remove(busca));
                },
              ),
              onTap: () {
                _searchController.text = busca;
                _buscar(busca);
              },
            );
          }).toList(),
        ],
      ],
    );
  }

  Widget _buildResultados() {
    return Column(
      children: [
        // Cabeçalho de resultados
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          child: Row(
            children: [
              Text(
                '${_resultados.length} ${_resultados.length == 1 ? 'resultado' : 'resultados'}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.sort, size: 18),
                label: const Text('Ordenar'),
              ),
            ],
          ),
        ),

        // Lista de resultados
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _resultados.length,
            itemBuilder: (context, index) {
              final vaga = _resultados[index];
              return VagaCard(
                vaga: vaga,
                onTap: () => _navigateToVaga(vaga.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

