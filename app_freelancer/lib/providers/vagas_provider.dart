import 'package:flutter/material.dart';
import '../data/models/vaga_model.dart';

class VagasProvider extends ChangeNotifier {
  List<VagaModel> _vagas = [];
  bool _isLoading = false;
  String? _erro;

  List<VagaModel> get vagas => _vagas;
  bool get isLoading => _isLoading;
  String? get erro => _erro;

  VagasProvider() {
    carregarVagas();
  }

  // Carregar vagas (Mock)
  Future<void> carregarVagas() async {
    _isLoading = true;
    _erro = null;
    notifyListeners();

    try {
      // Simular delay de rede
      await Future.delayed(const Duration(seconds: 1));

      // Dados mock
      _vagas = _gerarVagasMock();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _erro = 'Erro ao carregar vagas: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Gerar dados mock
  List<VagaModel> _gerarVagasMock() {
    return [
      VagaModel(
        id: '1',
        titulo: 'Garçom para Evento',
        descricao: 'Precisamos de garçom experiente para evento corporativo no sábado.',
        empresaId: 'emp1',
        empresaNome: 'Restaurante Sabor & Arte',
        preco: 150.00,
        data: DateTime.now().add(const Duration(days: 2)),
        dataLimite: DateTime.now().add(const Duration(days: 1)),
        status: 'aberta',
        candidatos: 3,
      ),
      VagaModel(
        id: '2',
        titulo: 'Cozinheiro para Final de Semana',
        descricao: 'Vaga para cozinheiro com experiência em comida italiana.',
        empresaId: 'emp2',
        empresaNome: 'Pizzaria Bella Napoli',
        preco: 200.00,
        data: DateTime.now().add(const Duration(days: 5)),
        dataLimite: DateTime.now().add(const Duration(days: 3)),
        status: 'aberta',
        candidatos: 5,
      ),
      VagaModel(
        id: '3',
        titulo: 'Bartender para Festa',
        descricao: 'Procuramos bartender criativo para evento especial.',
        empresaId: 'emp3',
        empresaNome: 'Bar do João',
        preco: 180.00,
        data: DateTime.now().add(const Duration(days: 7)),
        status: 'aberta',
        candidatos: 2,
      ),
      VagaModel(
        id: '4',
        titulo: 'Ajudante de Cozinha',
        descricao: 'Vaga para ajudante de cozinha, não precisa experiência.',
        empresaId: 'emp1',
        empresaNome: 'Restaurante Sabor & Arte',
        preco: 100.00,
        data: DateTime.now().add(const Duration(days: 1)),
        status: 'aberta',
        candidatos: 8,
      ),
      VagaModel(
        id: '5',
        titulo: 'Chef de Cozinha Temporário',
        descricao: 'Substituição temporária de chef por 2 semanas.',
        empresaId: 'emp4',
        empresaNome: 'Bistrô Gourmet',
        preco: 300.00,
        data: DateTime.now().add(const Duration(days: 10)),
        dataLimite: DateTime.now().add(const Duration(days: 5)),
        status: 'aberta',
        candidatos: 1,
      ),
    ];
  }

  // Candidatar-se (Mock)
  Future<bool> candidatar(String vagaId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Encontrar vaga e incrementar candidatos
      final index = _vagas.indexWhere((v) => v.id == vagaId);
      if (index != -1) {
        _vagas[index] = VagaModel(
          id: _vagas[index].id,
          titulo: _vagas[index].titulo,
          descricao: _vagas[index].descricao,
          empresaId: _vagas[index].empresaId,
          empresaNome: _vagas[index].empresaNome,
          preco: _vagas[index].preco,
          data: _vagas[index].data,
          dataLimite: _vagas[index].dataLimite,
          status: _vagas[index].status,
          candidatos: _vagas[index].candidatos + 1,
          empresaLogo: _vagas[index].empresaLogo,
        );
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _erro = 'Erro ao candidatar: $e';
      notifyListeners();
      return false;
    }
  }

  // Buscar vaga por ID
  VagaModel? getVagaById(String id) {
    try {
      return _vagas.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }

  // Filtrar vagas
  List<VagaModel> filtrarVagas({
    double? precoMinimo,
    double? precoMaximo,
    String? status,
  }) {
    return _vagas.where((vaga) {
      if (precoMinimo != null && vaga.preco < precoMinimo) return false;
      if (precoMaximo != null && vaga.preco > precoMaximo) return false;
      if (status != null && vaga.status != status) return false;
      return true;
    }).toList();
  }
}

