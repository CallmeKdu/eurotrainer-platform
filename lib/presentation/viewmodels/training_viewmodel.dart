import 'package:flutter/material.dart';
import '../../domain/models/training_model.dart';

class TrainingViewModel extends ChangeNotifier {
  List<TrainingModel> _trainings = [];
  bool _isLoading = true;

  List<TrainingModel> get trainings => _trainings;
  bool get isLoading => _isLoading;

  Future<void> loadTrainings() async {
    _isLoading = true;
    notifyListeners();

    // Simulação de requisição ao banco
    await Future.delayed(const Duration(milliseconds: 800));

    _trainings = [
      TrainingModel(
        id: 'welcome_1',
        title: 'EuroAcademy: Bem-vindo!',
        description:
            'Curso de integração e boas-vindas à plataforma Euro Academy. Conheça os recursos e a navegação.',
        deadline: 'Sem prazo',
        scormUrl: 'https://eurotrainer-platform.web.app/index.html',
        tagText: 'EA',
        tagColorHex: 0xFFE5EDFF, // Cor de fundo (azul)
      ),
      TrainingModel(
        id: '2',
        title: 'Conformidade LGPD',
        description:
            'Revisão das diretrizes da seção 4.2 referentes a retenção de dados e privacidade dos colaboradores.',
        deadline: '12 Out, 2026',
        scormUrl: '',
        tagText: 'GD',
        tagColorHex: 0xFFE5EDFF, // Cor de fundo (azul)
      ),
      TrainingModel(
        id: '3',
        title: 'Segurança da Informação',
        description:
            'Módulo básico focado em prevenção de phishing, engenharia social e uso seguro de dispositivos corporativos.',
        deadline: '20 Out, 2026',
        scormUrl: '',
        tagText: 'TR',
        tagColorHex: 0xFF82B2FE,
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }
}
