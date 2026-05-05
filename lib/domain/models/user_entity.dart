class UserEntity {
  final String id;
  final String nome;
  final String email;
  final String role; // Ex: 'funcionário', 'gestor', 'ti'

// Construtor para criar uma instância de UserEntity
  UserEntity({
    required this.id, 
    required this.nome, 
    required this.email, 
    required this.role,
  });
}