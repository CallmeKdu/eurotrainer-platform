import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/models/user_entity.dart';

class HomeViewModel extends ChangeNotifier {
  UserEntity? _currentUser;
  late final String _fraseMotivacional;

  HomeViewModel() {
    _gerarFraseMotivacional();
  }

  // Atualiza a entidade de usuário e notifica a View
  void updateUser(UserEntity? user) {
    if (_currentUser != user) {
      _currentUser = user;
      // O uso do addPostFrameCallback ou delay é boa prática caso seja atualizado via build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void _gerarFraseMotivacional() {
    final frases = [
      "Pronto para mergulhar no universo Eurofarma e subir de nível? Mostre do que você é capaz!",
      "Dizem que conhecimento é poder. Mostre o quão fantástico você será no treinamento de hoje!",
      "Sua jornada de desenvolvimento não para. Que tal destravar novas habilidades e mostrar seu potencial agora?",
      "O aprendizado contínuo transforma. Preparado para conquistar mais uma etapa e ir além hoje?",
      "Cada módulo concluído é um passo rumo à excelência. Vamos ver o quão longe você consegue chegar no universo Eurofarma!",
      "Um novo dia traz novas oportunidades de evolução. Pronto para aceitar o desafio e dar o seu melhor?",
    ];
    _fraseMotivacional = frases[Random().nextInt(frases.length)];
  }

  String get saudacaoTempo {
    final hora = DateTime.now().hour;
    if (hora >= 5 && hora < 12) return "Bom dia";
    if (hora >= 12 && hora < 18) return "Boa tarde";
    return "Boa noite";
  }

  String get nomeFormatado {
    if (_currentUser == null || _currentUser!.nome.trim().isEmpty) return "";
    final partes = _currentUser!.nome.trim().split(RegExp(r'\s+'));
    if (partes.length == 1) return partes.first;
    return "${partes.first} ${partes.last}";
  }

  String get fraseMotivacional => _fraseMotivacional;
}