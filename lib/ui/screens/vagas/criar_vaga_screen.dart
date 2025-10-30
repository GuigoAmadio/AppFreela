import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/vaga_model.dart';
import '../../../providers/empresa_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class CriarVagaScreen extends StatefulWidget {
  final VagaModel? vaga; // null se for criar, preenchido se for editar

  const CriarVagaScreen({
    super.key,
    this.vaga,
  });

  @override
  State<CriarVagaScreen> createState() => _CriarVagaScreenState();
}

class _CriarVagaScreenState extends State<CriarVagaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cargoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorHoraController = TextEditingController();
  final _numeroVagasController = TextEditingController();
  final _enderecoController = TextEditingController();

  DateTime? _dataInicio;
  DateTime? _dataFim;
  double? _latitude;
  double? _longitude;
  bool _isLoading = false;

  bool get _isEdit => widget.vaga != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _preencherCampos();
    }
  }

  void _preencherCampos() {
    final vaga = widget.vaga!;
    _cargoController.text = vaga.cargo;
    _descricaoController.text = vaga.descricao;
    _valorHoraController.text = vaga.valorHora.toStringAsFixed(2);
    _numeroVagasController.text = vaga.numeroVagas.toString();
    _enderecoController.text = vaga.endereco;
    _dataInicio = vaga.dataInicio;
    _dataFim = vaga.dataFim;
    _latitude = vaga.latitude;
    _longitude = vaga.longitude;
  }

  @override
  void dispose() {
    _cargoController.dispose();
    _descricaoController.dispose();
    _valorHoraController.dispose();
    _numeroVagasController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData(BuildContext context, bool isInicio) async {
    final initialDate = isInicio
        ? (_dataInicio ?? DateTime.now())
        : (_dataFim ?? DateTime.now().add(const Duration(days: 1)));

    final firstDate = isInicio
        ? DateTime.now()
        : (_dataInicio ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (time != null) {
        setState(() {
          final dateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );

          if (isInicio) {
            _dataInicio = dateTime;
          } else {
            _dataFim = dateTime;
          }
        });
      }
    }
  }

  Future<void> _selecionarLocalizacao() async {
    final result = await Navigator.of(context).pushNamed(
      '/selecionar-localizacao',
      arguments: {
        'latitude': _latitude,
        'longitude': _longitude,
      },
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _latitude = result['latitude'];
        _longitude = result['longitude'];
        if (result['endereco'] != null && result['endereco'].isNotEmpty) {
          _enderecoController.text = result['endereco'];
        }
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_dataInicio == null || _dataFim == null) {
      Helpers.showErrorSnackBar(
        context,
        'Selecione as datas de início e fim',
      );
      return;
    }

    if (_latitude == null || _longitude == null) {
      Helpers.showErrorSnackBar(
        context,
        'Selecione a localização da vaga',
      );
      return;
    }

    setState(() => _isLoading = true);

    final empresaProvider = context.read<EmpresaProvider>();

    bool success;
    if (_isEdit) {
      success = await empresaProvider.atualizarVaga(
        id: widget.vaga!.id,
        data: {
          'cargo': _cargoController.text,
          'descricao': _descricaoController.text,
          'valor_hora': double.parse(_valorHoraController.text),
          'numero_vagas': int.parse(_numeroVagasController.text),
          'endereco': _enderecoController.text,
          'data_inicio': _dataInicio!.toIso8601String(),
          'data_fim': _dataFim!.toIso8601String(),
          'latitude': _latitude,
          'longitude': _longitude,
        },
      );
    } else {
      success = await empresaProvider.criarVaga(
        cargo: _cargoController.text,
        descricao: _descricaoController.text,
        valorHora: double.parse(_valorHoraController.text),
        numeroVagas: int.parse(_numeroVagasController.text),
        endereco: _enderecoController.text,
        dataInicio: _dataInicio!,
        dataFim: _dataFim!,
        latitude: _latitude!,
        longitude: _longitude!,
      );
    }

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        Helpers.showSuccessSnackBar(
          context,
          _isEdit ? 'Vaga atualizada' : 'Vaga criada com sucesso',
        );
        Navigator.of(context).pop(true);
      } else {
        Helpers.showErrorSnackBar(
          context,
          empresaProvider.error ?? 'Erro ao salvar vaga',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Editar Vaga' : 'Criar Nova Vaga'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Cargo
            CustomTextField(
              controller: _cargoController,
              label: 'Cargo',
              hint: 'Ex: Garçom, Cozinheiro, etc.',
              validator: (value) =>
                  Validators.validateRequired(value, fieldName: 'Cargo'),
            ),
            const SizedBox(height: 16),

            // Descrição
            CustomTextField(
              controller: _descricaoController,
              label: 'Descrição',
              hint: 'Descreva as responsabilidades e requisitos...',
              maxLines: 5,
              validator: (value) =>
                  Validators.validateRequired(value, fieldName: 'Descrição'),
            ),
            const SizedBox(height: 16),

            // Valor por hora
            CustomTextField(
              controller: _valorHoraController,
              label: 'Valor por Hora (R\$)',
              hint: '0.00',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) => Validators.validateCurrency(
                value,
                minValue: 10.0,
              ),
            ),
            const SizedBox(height: 16),

            // Número de vagas
            CustomTextField(
              controller: _numeroVagasController,
              label: 'Número de Vagas',
              hint: '1',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) => Validators.validateNumber(
                value,
                min: 1,
                max: 100,
              ),
            ),
            const SizedBox(height: 16),

            // Data de início
            _buildDataField(
              label: 'Data e Hora de Início',
              data: _dataInicio,
              onTap: () => _selecionarData(context, true),
            ),
            const SizedBox(height: 16),

            // Data de fim
            _buildDataField(
              label: 'Data e Hora de Término',
              data: _dataFim,
              onTap: () => _selecionarData(context, false),
            ),
            const SizedBox(height: 16),

            // Endereço
            CustomTextField(
              controller: _enderecoController,
              label: 'Endereço',
              hint: 'Endereço completo do local',
              validator: (value) =>
                  Validators.validateRequired(value, fieldName: 'Endereço'),
            ),
            const SizedBox(height: 16),

            // Localização
            OutlinedButton.icon(
              onPressed: _selecionarLocalizacao,
              icon: const Icon(Icons.location_on),
              label: Text(
                _latitude != null && _longitude != null
                    ? 'Localização selecionada'
                    : 'Selecionar Localização no Mapa',
              ),
            ),
            const SizedBox(height: 32),

            // Botão salvar
            CustomButton(
              text: _isEdit ? 'Atualizar Vaga' : 'Criar Vaga',
              onPressed: _salvar,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataField({
    required String label,
    required DateTime? data,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data != null
                        ? '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} às ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}'
                        : 'Selecione...',
                    style: TextStyle(
                      fontSize: 16,
                      color: data != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

