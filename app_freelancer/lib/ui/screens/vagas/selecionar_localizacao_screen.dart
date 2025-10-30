import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../widgets/custom_button.dart';

class SelecionarLocalizacaoScreen extends StatefulWidget {
  final double? latitudeInicial;
  final double? longitudeInicial;

  const SelecionarLocalizacaoScreen({
    super.key,
    this.latitudeInicial,
    this.longitudeInicial,
  });

  @override
  State<SelecionarLocalizacaoScreen> createState() =>
      _SelecionarLocalizacaoScreenState();
}

class _SelecionarLocalizacaoScreenState
    extends State<SelecionarLocalizacaoScreen> {
  double? _latitude;
  double? _longitude;
  String _endereco = '';
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    if (widget.latitudeInicial != null && widget.longitudeInicial != null) {
      _latitude = widget.latitudeInicial;
      _longitude = widget.longitudeInicial;
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permissão de localização negada');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Permissão negada permanentemente. Ative nas configurações.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _endereco = 'Localização Atual';
      });

      if (mounted) {
        Helpers.showSuccessSnackBar(context, 'Localização obtida');
      }
    } catch (e) {
      if (mounted) {
        Helpers.showErrorSnackBar(
          context,
          'Erro ao obter localização: $e',
        );
      }
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _inserirManualmente() async {
    final latController = TextEditingController(
      text: _latitude?.toString() ?? '',
    );
    final lngController = TextEditingController(
      text: _longitude?.toString() ?? '',
    );
    final enderecoController = TextEditingController(text: _endereco);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Inserir Coordenadas'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: latController,
                decoration: const InputDecoration(
                  labelText: 'Latitude',
                  hintText: '-23.550520',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lngController,
                decoration: const InputDecoration(
                  labelText: 'Longitude',
                  hintText: '-46.633308',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: enderecoController,
                decoration: const InputDecoration(
                  labelText: 'Endereço (opcional)',
                  hintText: 'Nome do local',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final lat = double.tryParse(latController.text);
      final lng = double.tryParse(lngController.text);

      if (lat != null && lng != null) {
        setState(() {
          _latitude = lat;
          _longitude = lng;
          _endereco = enderecoController.text.isEmpty
              ? 'Localização Manual'
              : enderecoController.text;
        });
        
        if (mounted) {
          Helpers.showSuccessSnackBar(context, 'Localização definida');
        }
      } else {
        if (mounted) {
          Helpers.showErrorSnackBar(
            context,
            'Coordenadas inválidas',
          );
        }
      }
    }
  }

  void _confirmar() {
    if (_latitude == null || _longitude == null) {
      Helpers.showErrorSnackBar(
        context,
        'Selecione uma localização primeiro',
      );
      return;
    }

    Navigator.of(context).pop({
      'latitude': _latitude,
      'longitude': _longitude,
      'endereco': _endereco,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Localização'),
      ),
      body: Column(
        children: [
          // Mapa placeholder
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Mapa Interativo',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Integração com Mapbox',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                        if (_latitude != null && _longitude != null) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(horizontal: 40),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primary),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: AppColors.primary,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                if (_endereco.isNotEmpty)
                                  Text(
                                    _endereco,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  'Lat: ${_latitude!.toStringAsFixed(6)}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'Lng: ${_longitude!.toStringAsFixed(6)}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Botão de localização atual
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      onPressed:
                          _isLoadingLocation ? null : _getCurrentLocation,
                      child: _isLoadingLocation
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            )
                          : const Icon(Icons.my_location),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Ações
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  CustomButton(
                    text: 'Inserir Coordenadas Manualmente',
                    onPressed: _inserirManualmente,
                    isOutlined: true,
                    icon: Icons.edit_location,
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Confirmar Localização',
                    onPressed: _confirmar,
                    icon: Icons.check,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

