import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfilePage extends StatefulWidget {
  final ProfileViewModel viewModel;

  const ProfilePage({super.key, required this.viewModel});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _roleController;
  late TextEditingController _bioController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _roleController = TextEditingController();
    _bioController = TextEditingController();

    // Defer the initialization to the next frame to safely access the provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = context.read<AuthViewModel>();
      final user = authViewModel.currentUser;
      if (user != null) {
        _roleController.text = user.role;
        _bioController.text = user.bio ?? '';
      }
      widget.viewModel.addListener(_onViewModelChange);
    });
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChange);
    _roleController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _onViewModelChange() {
    if (!mounted) return;

    if (widget.viewModel.errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.viewModel.errorMessage), backgroundColor: Theme.of(context).colorScheme.error),
      );
      widget.viewModel.clearMessages();
    } else if (widget.viewModel.successMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.viewModel.successMessage), backgroundColor: Colors.green),
      );
      widget.viewModel.clearMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.currentUser;

    if (user == null) {
      // Show loading while checking auth state or fallback if truly null
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Avatar e Nome)
          Row(
            children: [
              GestureDetector(
                onTap: widget.viewModel.isLoading
                  ? null
                  : () => widget.viewModel.pickAndUploadImage(user.id),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      backgroundImage: user.photoUrl != null && user.photoUrl!.isNotEmpty
                          ? NetworkImage(user.photoUrl!)
                          : null,
                      child: user.photoUrl == null || user.photoUrl!.isEmpty
                          ? Text(
                              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            )
                          : null,
                    ),
                    if (widget.viewModel.isLoading)
                      const CircularProgressIndicator(),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.role,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 48),

          // Formulário de Dados Pessoais
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informações Pessoais',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 24),

                // E-mail (Somente leitura)
                TextFormField(
                  initialValue: user.email,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'E-mail Corporativo',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainer,
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 24),

                // Cargo
                TextFormField(
                  controller: _roleController,
                  readOnly: !_isEditing,
                  decoration: InputDecoration(
                    labelText: 'Cargo',
                    border: const OutlineInputBorder(),
                    filled: !_isEditing,
                    fillColor: !_isEditing ? theme.colorScheme.surfaceContainer : null,
                    prefixIcon: const Icon(Icons.work),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 24),

                // Mini Bio
                TextFormField(
                  controller: _bioController,
                  readOnly: !_isEditing,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Mini Bio',
                    border: const OutlineInputBorder(),
                    filled: !_isEditing,
                    fillColor: !_isEditing ? theme.colorScheme.surfaceContainer : null,
                  ),
                ),

                const SizedBox(height: 24),

                // Botões de Ação para o Formulário
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_isEditing) ...[
                      TextButton(
                        onPressed: widget.viewModel.isLoading ? null : () {
                          setState(() {
                            _isEditing = false;
                            // Reverte os valores
                            _roleController.text = user.role;
                            _bioController.text = user.bio ?? '';
                          });
                        },
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: widget.viewModel.isLoading ? null : () {
                          if (_formKey.currentState!.validate()) {
                            widget.viewModel.updateProfileData(
                              user.id,
                              _roleController.text,
                              _bioController.text,
                            ).then((_) {
                              if (mounted) {
                                setState(() {
                                  _isEditing = false;
                                });
                              }
                            });
                          }
                        },
                        child: widget.viewModel.isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Salvar Alterações'),
                      ),
                    ] else ...[
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar Perfil'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 64),

          // Seção de Segurança
          Text(
            'Segurança',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),

          OutlinedButton.icon(
            onPressed: widget.viewModel.isLoading
              ? null
              : () => widget.viewModel.sendPasswordResetEmail(user.email),
            icon: const Icon(Icons.lock_reset),
            label: const Text('Redefinir Senha'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Um e-mail será enviado com as instruções para redefinir sua senha.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
