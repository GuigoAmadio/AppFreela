import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapConstants {
  // Token do Mapbox (vem do .env)
  static String get mapboxToken => dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';
  
  // Coordenadas padrão (São Paulo - centro)
  static const double defaultLatitude = -23.5505;
  static const double defaultLongitude = -46.6333;
  
  // Configurações de zoom
  static const double defaultZoom = 12.0;
  static const double minZoom = 8.0;
  static const double maxZoom = 18.0;
  static const double markerZoom = 15.0;
  
  // Estilo do mapa Mapbox
  // Você pode escolher entre: streets, outdoors, light, dark, satellite, satellite-streets
  static const String mapStyle = 'mapbox://styles/mapbox/streets-v12';
  
  // Cores dos markers
  static const String markerColorEmpresa = '#8B5CF6'; // Roxo
  static const String markerColorVagaAberta = '#EF4444'; // Vermelho
  
  // Raio de busca padrão (em km)
  static const double defaultSearchRadius = 10.0;
  
  // Configurações de localização
  static const double locationAccuracy = 100.0; // metros
  static const int locationTimeoutSeconds = 30;
}

