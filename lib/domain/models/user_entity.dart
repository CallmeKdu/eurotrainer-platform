class UserEntity {
  final String id;
  final String name;
  final String email;
  final String role; // Ex: 'funcionário', 'gestor', 'ti'
  final String? photoUrl;
  final String? bio;

// Construtor para criar uma instância de UserEntity
  UserEntity({
    required this.id, 
    required this.name, 
    required this.email, 
    required this.role,
    this.photoUrl,
    this.bio,
  });

  factory UserEntity.fromFirestore(Map<String, dynamic> data, String documentId) {
    return UserEntity(
      id: documentId,
      // Tenta pegar 'nomeCompleto' primeiro, depois 'name', e por fim uma string vazia
      name: data['nomeCompleto'] ?? data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      photoUrl: data['photoUrl'],
      bio: data['bio'],
    );
  }
}