// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import '../../domain/models/training_model.dart';
import '../viewmodels/course_player_viewmodel.dart';

class CoursePlayPage extends StatefulWidget {
  final TrainingModel training;
  final CoursePlayerViewModel viewModel;

  const CoursePlayPage({
    super.key,
    required this.training,
    required this.viewModel,
  });

  @override
  State<CoursePlayPage> createState() => _CoursePlayPageState();
}

class _CoursePlayPageState extends State<CoursePlayPage> {
  late final String _iframeId;

  @override
  void initState() {
    super.initState();
    _iframeId = 'scorm-iframe-${widget.training.id}';

    // 1. Registra a função do Dart no objeto window do JavaScript
    // ignore: undefined_prefixed_name, undefined_function
    js.context['onScormCommit'] = js.allowInterop((dynamic status, dynamic score) {
      widget.viewModel.saveProgress(widget.training.id, status?.toString() ?? 'completed', score?.toString() ?? '100');
    });

    // 2. Constrói o visualizador web (IFrame)
    ui_web.platformViewRegistry.registerViewFactory(_iframeId, (int viewId) {
      final iframe = html.IFrameElement()
        ..src = widget.training.scormUrl
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allowFullscreen = true;

      iframe.onLoad.listen((_) {
        widget.viewModel.setLoaded();
      });

      return iframe;
    });
  }

  @override
  void dispose() {
    // Limpa a função global para evitar vazamento de memória ao sair da tela
    js.context['onScormCommit'] = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9F6),
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Color(0xFF1A1C1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.training.title,
          style: const TextStyle(color: Color(0xFF1A1C1A), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          // Botão manual de conclusão para cursos no formato WEB
          TextButton.icon(
            onPressed: () async {
              await widget.viewModel.saveProgress(widget.training.id, 'completed', '100');
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Treinamento marcado como concluído!'), backgroundColor: Colors.green),
              );
              Navigator.pop(context); // <-- Fecha a tela automaticamente!
            },
            icon: const Icon(Icons.check_circle, color: Color(0xFF02378F)),
            label: const Text('Concluir', style: TextStyle(color: Color(0xFF02378F), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Stack(
        children: [
          HtmlElementView(viewType: _iframeId),
          AnimatedBuilder(
            animation: widget.viewModel,
            builder: (context, _) {
              if (widget.viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF02378F)));
              }
              return const SizedBox.shrink(); // Some com o carregamento quando finalizar!
            },
          ),
        ],
      ),
    );
  }
}