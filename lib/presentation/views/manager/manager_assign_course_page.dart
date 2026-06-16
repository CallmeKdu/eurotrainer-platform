import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/manager/manager_assign_viewmodel.dart';
import '../../../core/injection.dart';

class ManagerAssignCoursePage extends StatelessWidget {
  const ManagerAssignCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ManagerAssignContentView();
  }
}

class _ManagerAssignContentView extends StatelessWidget {
  const _ManagerAssignContentView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vm = context.watch<ManagerAssignViewModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            'Selecione um curso e os colaboradores que deverão realizá-lo.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.surfaceContainerHighest),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('1. Selecione o Curso', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                DropdownButtonFormField<CourseData>(
                  value: vm.selectedCourse,
                  hint: const Text('Selecione um curso disponível'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                  ),
                  items: vm.allCourses.map((c) => DropdownMenuItem(value: c, child: Text(c.title))).toList(),
                  onChanged: vm.selectCourse,
                ),
                const SizedBox(height: 32),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('2. Selecione os Colaboradores', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: () => vm.selectAllUsers(!vm.isAllSelected),
                      icon: Icon(vm.isAllSelected ? Icons.deselect : Icons.select_all),
                      label: Text(vm.isAllSelected ? 'Desmarcar Todos' : 'Selecionar Todos'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vm.allUsers.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final u = vm.allUsers[index];
                    return CheckboxListTile(
                      value: vm.isUserSelected(u.id),
                      onChanged: (_) => vm.toggleUserSelection(u.id),
                      title: Text(u.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${u.department} • ${u.email}'),
                      secondary: CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(u.name.substring(0, 1), style: TextStyle(color: theme.colorScheme.primary)),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: (vm.selectedCourse == null || vm.selectedUsers.isEmpty) ? null : () async {
                      await vm.assignCourse();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Curso atribuído com sucesso!')),
                        );
                      }
                    },
                    icon: const Icon(Icons.send),
                    label: const Text('Atribuir aos Selecionados'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
