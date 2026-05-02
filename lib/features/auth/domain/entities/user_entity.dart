class UserEntity {
  final String id;
  final String name;
  final String email;
  final String role; // Ex: 'funcionário', 'gestor', 'ti'

// Construtor para criar uma instância de UserEntity
  UserEntity({
    required this.id, 
    required this.name, 
    required this.email, 
    required this.role,
  });
}