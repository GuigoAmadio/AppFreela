import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../widgets/custom_button.dart';

class FiltrosScreen extends StatefulWidget {
  final Map<String, dynamic>? filtrosAtuais;

  const FiltrosScreen({
    super.key,
    this.filtrosAtuais,
  });

  @override
  State<FiltrosScreen> createState() => _FiltrosScreenState();
}

class _FiltrosScreenState extends State<FiltrosScreen> {
  String? _cargoSelecionado;
  double _raioKm = 10.0;
  RangeValues _faixaSalarial = const RangeValues(15, 50);
  bool _apenasDisp

oniveis = false;
  String? _ordenacao;

  final List<String> _cargos = [
    'Garçom',
    'Cozinheiro',
    'Auxiliar de Cozinha',
    'Bartender',
    'Recepcionista',
    'Gerente',
    'Outros',
  ];

  final List<Map<String, String>> _opcaoesOrdenacao = [
    {'label': 'Mais Recentes', 'value': 'recente'},
    {'label': 'Maior Salário', 'value': 'salario_desc'},
    {'label': 'Menor Salário', 'value': 'salario_asc'},
    {'label': 'Mais Próximas', 'value': 'distancia'},
  ];

  @override
  void initState() {
    super.initState();
    _carregarFiltros();
  }

  void _carregarFiltros() {
    if (widget.filtrosAtuais != null) {
      setState(() {
        _cargoSelecionado = widget.filtrosAtuais!['cargo'];
        _raioKm = widget.filtrosAtuais!['raio'] ?? 10.0;
        _apenasDisponiveis = widget.filtrosAtuais!['apenasDisponiveis'] ?? false;
        _ordenacao = widget.filtrosAtuais!['ordenacao'];
        
        if (widget.filtrosAtuais!['valorMin'] != null) {
          _faixaSalarial = RangeValues(
            widget.filtrosAtuais!['valorMin'],
            widget.filtrosAtuais!['valorMax'] ?? 50,
          );
        }
      });
    }
  }

  void _aplicarFiltros() {
    final filtros = {
      'cargo': _cargoSelecionado,
      'raio': _raioKm,
      'valorMin': _faixaSalarial.start,
      'valorMax': _faixaSalarial.end,
      'apenasDisponiveis': _apenasDisponiveis,
      'ordenacao': _ordenacao,
    };
    
    Navigator.of(context).pop(filtros);
  }

  void _limparFiltros() {
    setState(() {
      _cargoSelecionado = null;
      _raioKm = 10.0;
      _faixaSalarial = const RangeValues(15, 50);
      _apenasDisponiveis = false;
      _ordenacao = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtros'),
        actions: [
          TextButton(
            onPressed: _limparFiltros,
            child: const Text('Limpar'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Cargo
          _buildSecao(
            titulo: 'Cargo',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _cargos.map((cargo) {
                final selecionado = _cargoSelecionado == cargo;
                return FilterChip(
                  label: Text(cargo),
                  selected: selecionado,
                  onSelected: (selected) {
                    setState(() {
                      _cargoSelecionado = selected ? cargo : null;
                    });
                  },
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: selecionado ? Colors.white : AppColors.textPrimary,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Raio de busca
          _buildSecao(
            titulo: 'Raio de Busca',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_raioKm.toStringAsFixed(0)} km',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Slider(
                  value: _raioKm,
                  min: 1,
                  max: 50,
                  divisions: 49,
                  label: '${_raioKm.toStringAsFixed(0)} km',
                  onChanged: (value) {
                    setState(() => _raioKm = value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Faixa salarial
          _buildSecao(
            titulo: 'Valor por Hora',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${Formatters.formatCurrency(_faixaSalarial.start)} - ${Formatters.formatCurrency(_faixaSalarial.end)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                RangeSlider(
                  values: _faixaSalarial,
                  min: 10,
                  max: 100,
                  divisions: 18,
                  labels: RangeLabels(
                    'R\$ ${_faixaSalarial.start.toStringAsFixed(0)}',
                    'R\$ ${_faixaSalarial.end.toStringAsFixed(0)}',
                  ),
                  onChanged: (values) {
                    setState(() => _faixaSalarial = values);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Apenas disponíveis
          _buildSecao(
            titulo: 'Disponibilidade',
            child: SwitchListTile(
              title: const Text('Apenas vagas disponíveis'),
              subtitle: const Text('Mostrar apenas vagas abertas'),
              value: _apenasDisponiveis,
              onChanged: (value) {
                setState(() => _apenasDisponiveis = value);
              },
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 24),

          // Ordenação
          _buildSecao(
            titulo: 'Ordenar por',
            child: Column(
              children: _opcaoesOrdenacao.map((opcao) {
                return RadioListTile<String>(
                  title: Text(opcao['label']!),
                  value: opcao['value']!,
                  groupValue: _ordenacao,
                  onChanged: (value) {
                    setState(() => _ordenacao = value);
                  },
                  contentPadding: EdgeInsets.zero,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 32),

          // Botões
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Limpar',
                  onPressed: _limparFiltros,
                  isOutlined: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: 'Aplicar',
                  onPressed: _aplicarFiltros,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecao({
    required String titulo,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

