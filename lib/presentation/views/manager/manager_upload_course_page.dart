import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/manager/manager_upload_viewmodel.dart';
import '../../../core/injection.dart';

class ManagerUploadCoursePage extends StatelessWidget {
  const ManagerUploadCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ManagerUploadViewModel>(
      create: (_) => sl<ManagerUploadViewModel>(),
      child: const _ManagerUploadContentView(),
    );
  }
}

class _ManagerUploadContentView extends StatelessWidget {
  const _ManagerUploadContentView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vm = context.watch<ManagerUploadViewModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suba novos pacotes SCORM (.zip) para a plataforma.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Título do Curso', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  onChanged: vm.setCourseTitle,
                  decoration: InputDecoration(
                    hintText: 'Ex: Treinamento de Vendas 2026',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                  ),
                ),
                const SizedBox(height: 24),
                Text('Descrição', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  onChanged: vm.setCourseDescription,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Descreva os objetivos deste curso...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
                style: BorderStyle.solid,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.cloud_upload, size: 80, color: theme.colorScheme.primary),
                const SizedBox(height: 24),
                Text(
                  'Selecione um pacote SCORM (.zip)',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tamanho máximo: 50MB',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 32),
                if (!vm.isUploading && vm.selectedFileName == null)
                  ElevatedButton.icon(
                    onPressed: vm.canUpload ? vm.pickAndUploadScorm : null,
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Procurar Arquivo'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                if (!vm.canUpload && !vm.isUploading && vm.selectedFileName == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'Preencha o título e a descrição para habilitar o upload.',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                if (vm.isUploading || vm.selectedFileName != null)
                  Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.insert_drive_file, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(vm.selectedFileName ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (vm.isUploading)
                        SizedBox(
                          width: 300,
                          child: Column(
                            children: [
                              LinearProgressIndicator(
                                value: vm.uploadProgress,
                                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(height: 8),
                              Text('${(vm.uploadProgress * 100).toInt()}% concluído...'),
                            ],
                          ),
                        ),
                      if (!vm.isUploading && vm.selectedFileName != null)
                        const Column(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 48),
                            SizedBox(height: 8),
                            Text('Upload concluído com sucesso e adicionado à lista de cursos!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          ],
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
