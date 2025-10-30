import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/formatters.dart';
import '../../../providers/vagas_provider.dart';
import '../../../data/models/vaga_model.dart';
import '../vagas/detalhe_vaga_screen.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final MapController _mapController = MapController();
  Position? _currentPosition;
  VagaModel? _selectedVaga;

  // Coordenadas padrão (São Paulo)
  final LatLng _defaultCenter = const LatLng(-23.550520, -46.633308);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return;
      }

      final position = await Geolocator.getCurrentPosition();

      if (mounted) {
        setState(() {
          _currentPosition = position;
        });

        // Move câmera para localização atual
        _mapController.move(
          LatLng(position.latitude, position.longitude),
          14.0,
        );

        Helpers.showSuccessSnackBar(
          context,
          'Localização obtida com sucesso!',
        );
      }
    } catch (e) {
      // Silently fail - não é crítico
    }
  }

  List<Marker> _buildMarkers() {
    final provider = context.read<VagasProvider>();
    final markers = <Marker>[];

    // Adicionar marcador da localização do usuário
    if (_currentPosition != null) {
      markers.add(
        Marker(
          point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          width: 40,
          height: 40,
          child: const Icon(
            Icons.my_location,
            color: Colors.blue,
            size: 40,
          ),
        ),
      );
    }

    // Adicionar marcadores das vagas
    for (var i = 0; i < provider.vagas.length; i++) {
      final vaga = provider.vagas[i];

      // Distribuir vagas em um raio de ~2km (mock)
      final latOffset = (i % 3 - 1) * 0.01;
      final lngOffset = ((i ~/ 3) % 3 - 1) * 0.01;

      final lat = _defaultCenter.latitude + latOffset;
      final lng = _defaultCenter.longitude + lngOffset;

      markers.add(
        Marker(
          point: LatLng(lat, lng),
          width: 100,
          height: 80,
          child: GestureDetector(
            onTap: () => _selectVaga(vaga),
            child: Column(
              children: [
                // Badge com preço
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedVaga?.id == vaga.id
                        ? AppColors.primary
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primary,
                      width: _selectedVaga?.id == vaga.id ? 3 : 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _selectedVaga?.id == vaga.id
                            ? AppColors.primary.withOpacity(0.4)
                            : Colors.black.withOpacity(0.2),
                        blurRadius: _selectedVaga?.id == vaga.id ? 8 : 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    Formatters.formatCurrency(vaga.preco),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _selectedVaga?.id == vaga.id
                          ? Colors.white
                          : AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Pin
                AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: _selectedVaga?.id == vaga.id ? 1.2 : 1.0,
                  child: Icon(
                    Icons.location_on,
                    color: _selectedVaga?.id == vaga.id
                        ? AppColors.primary
                        : AppColors.success,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return markers;
  }

  void _selectVaga(VagaModel vaga) {
    setState(() {
      _selectedVaga = _selectedVaga?.id == vaga.id ? null : vaga;
    });
  }

  void _verDetalhes() {
    if (_selectedVaga != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetalheVagaScreen(vaga: _selectedVaga!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Vagas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final filtros = await Navigator.of(context).pushNamed('/filtros');
              if (filtros != null && mounted) {
                context.read<VagasProvider>().carregarVagas();
                setState(() {}); // Reconstruir marcadores
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Mapa OpenStreetMap REAL
          Consumer<VagasProvider>(
            builder: (context, provider, _) {
              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentPosition != null
                      ? LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude)
                      : _defaultCenter,
                  initialZoom: 13.0,
                  minZoom: 5.0,
                  maxZoom: 18.0,
                ),
                children: [
                  // Tiles do CartoDB Positron (estilo minimalista!)
                  TileLayer(
                    urlTemplate:
                        'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c', 'd'],
                    userAgentPackageName: 'com.example.app_freelancer',
                    maxZoom: 19,
                  ),
                  // Marcadores
                  MarkerLayer(
                    markers: _buildMarkers(),
                  ),
                ],
              );
            },
          ),

          // Legenda com animação
          Positioned(
            top: 16,
            left: 16,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Legenda:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.success,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Vaga',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.my_location,
                          color: Colors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Você',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Card de detalhes com animação
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            bottom: _selectedVaga != null ? 0 : -300,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _selectedVaga != null ? 1.0 : 0.0,
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: _selectedVaga != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedVaga!.titulo,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _selectedVaga!.empresaNome,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _selectedVaga = null;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  Formatters.formatCurrency(
                                      _selectedVaga!.preco),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.success,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.people_outline,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${_selectedVaga!.candidatos} candidatos',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: _verDetalhes,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Ver Detalhes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),

          // Botão de localização com animação
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            right: 16,
            bottom: _selectedVaga != null ? 220 : 16,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              heroTag: 'location',
              child: const Icon(Icons.my_location),
            ),
          ),

          // Controles de zoom
          Positioned(
            right: 16,
            top: 100,
            child: Column(
              children: [
                FloatingActionButton.small(
                  onPressed: () {
                    _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom + 1,
                    );
                  },
                  heroTag: 'zoom_in',
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  onPressed: () {
                    _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom - 1,
                    );
                  },
                  heroTag: 'zoom_out',
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
