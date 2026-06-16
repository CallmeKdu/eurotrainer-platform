import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/models/training_model.dart';
import '../viewmodels/course_player_viewmodel.dart';
import 'courseplay_helper.dart';

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
    _iframeId = 'iframe_${widget.training.id}';

    // Configura a comunicação bidirecional com o SCORM
    if (kIsWeb) {
      registerScormCallback(widget.training.id, (status, score) {
        debugPrint(
          'Flutter Web: SCORM Commit recebido - Status: $status, Score: $score',
        );
        widget.viewModel.saveProgress(
          widget.training.id,
          status,
          score,
        );
      });

      // Registra a IFrameElement no Flutter Web
      registerIframeViewFactory(_iframeId, widget.training.scormUrl);
    }
  }

  @override
  void dispose() {
    // Limpa a função global para evitar memory leaks
    if (kIsWeb) {
      cleanupScormCallback();
    }
    super.dispose();
  }

  void _showEvaluationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        double currentRating = 5.0;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Avaliar Curso'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Como você avalia este treinamento?'),
                  const SizedBox(height: 16),
                  Slider(
                    value: currentRating,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: currentRating.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        currentRating = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.viewModel.submitEvaluation(currentRating);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Avaliação enviada com sucesso!'),
                      ),
                    );
                  },
                  child: const Text('Enviar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          widget.training.title,
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.star),
            tooltip: 'Avaliar',
            onPressed: _showEvaluationDialog,
          ),
        ],
      ),
      body: kIsWeb
          ? HtmlElementView(viewType: _iframeId)
          : const Center(
              child: Text(
                'O reprodutor de cursos interativos só está disponível na versão Web.',
                style: TextStyle(fontSize: 16),
              ),
            ),
    );
  }
}
