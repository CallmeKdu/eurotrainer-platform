// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/manager/manager_attendance_viewmodel.dart';
import '../../../core/injection.dart';

class ManagerAttendancePage extends StatelessWidget {
  const ManagerAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ManagerAttendanceViewModel>(
      create: (_) => sl<ManagerAttendanceViewModel>(),
      child: const _ManagerAttendanceContentView(),
    );
  }
}

class _ManagerAttendanceContentView extends StatelessWidget {
  const _ManagerAttendanceContentView();

  void _downloadCsv(BuildContext context) {
    final vm = context.read<ManagerAttendanceViewModel>();
    final csvData = vm.generateCsv();
    
    // Convert String to bytes and encode to base64
    final bytes = utf8.encode(csvData);
    final base64String = base64Encode(bytes);
    
    // Create anchor element to trigger download
    html.AnchorElement(href: 'data:text/csv;charset=utf-8;base64,$base64String')
      ..setAttribute('download', 'lista_chamada_euroacademy.csv')
      ..click();
  }

  Widget _buildStep0(BuildContext context, ManagerAttendanceViewModel vm) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Selecione o Curso', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Escolha o curso para visualizar a lista de chamada.', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 32),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vm.availableCourses.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final course = vm.availableCourses[index];
            return ListTile(
              tileColor: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: theme.colorScheme.surfaceContainerHighest),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              leading: Icon(Icons.school, color: theme.colorScheme.primary),
              title: Text(course, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => vm.selectCourse(course),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStep1(BuildContext context, ManagerAttendanceViewModel vm) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: vm.goBack,
          icon: const Icon(Icons.arrow_back),
          label: const Text('Voltar aos Cursos'),
          style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.surface, foregroundColor: theme.colorScheme.onSurface),
        ),
        const SizedBox(height: 24),
        Text('Selecione a Turma', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Curso selecionado: ${vm.selectedCourse}', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
        const SizedBox(height: 32),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vm.availableClasses.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final className = vm.availableClasses[index];
            return ListTile(
              tileColor: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: theme.colorScheme.surfaceContainerHighest),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              leading: Icon(Icons.class_, color: theme.colorScheme.primary),
              title: Text(className, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => vm.selectClass(className),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStep2(BuildContext context, ManagerAttendanceViewModel vm) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: vm.goBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Voltar às Turmas'),
              style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.surface, foregroundColor: theme.colorScheme.onSurface),
            ),
            ElevatedButton.icon(
              onPressed: () => _downloadCsv(context),
              icon: const Icon(Icons.download),
              label: const Text('Baixar CSV'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Lista de Chamada', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Turma: ${vm.selectedClass} • Curso: ${vm.selectedCourse}', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
        const SizedBox(height: 32),
        TextField(
          onChanged: vm.setSearchQuery,
          decoration: InputDecoration(
            hintText: 'Buscar por nome ou departamento...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.surfaceContainerHighest),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.surfaceContainerHighest),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: vm.filteredAttendances.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: theme.colorScheme.surfaceContainerHighest),
            itemBuilder: (context, index) {
              final t = vm.filteredAttendances[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    t.name.substring(0, 1),
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ),
                title: Text(t.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${t.department} • ${t.course}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(t.progress * 100).toInt()}%',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: t.isCompleted ? Colors.green : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      t.isCompleted ? Icons.check_circle : Icons.timelapse,
                      color: t.isCompleted ? Colors.green : Colors.orange,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ManagerAttendanceViewModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: () {
        if (vm.currentStep == 0) return _buildStep0(context, vm);
        if (vm.currentStep == 1) return _buildStep1(context, vm);
        return _buildStep2(context, vm);
      }(),
    );
  }
}
