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

  factory UserEntity.fromFirestore(Map<String, dynamic> data, String documentId) {
    return UserEntity(
      id: documentId,
      // Pega o valor da chave 'name' do banco e joga no atributo 'name' da classe
      name: data['name'] ?? '', 
      email: data['email'] ?? '',
      role: data['role'] ?? '',
    );
  }
}