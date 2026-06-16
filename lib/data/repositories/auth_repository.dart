import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_user_service.dart';
import '../../domain/models/user_entity.dart';

class AuthRepository {
  final FirebaseAuthService _authService;
  final FirestoreUserService
  _firestoreService; // Adicionamos o novo service aqui

  // Variáveis de estado do MFA que antes ficavam na ViewModel
  MultiFactorResolver? _resolver;
  TotpSecret? _totpSecret;

  AuthRepository(this._authService, this._firestoreService);

  Future<UserEntity?> login(String email, String password) async {
    try {
      // 1. Loga no Firebase Auth (Pega a Identidade)
      final firebaseUser = await _authService.signInWithEmail(email, password);

      if (firebaseUser != null) {
        // 2. Busca o documento do usuário no Firestore (Pega o Perfil/Role)
        final userData = await _firestoreService.getUserData(firebaseUser.uid);

        // Prepara o Map combinando os dados do Firestore com os fallbacks do Firebase Auth
        final Map<String, dynamic> firestoreData = {
          'name':
              userData?['nomeCompleto'] ??
              userData?['name'] ??
              firebaseUser.displayName ??
              '',
          'email': userData?['email'] ?? firebaseUser.email ?? '',
          'role': userData?['role'] ?? 'aluno',
          'photoUrl': userData?['photoUrl'],
          'bio': userData?['bio'],
        };

        // 3. Utiliza a factory fromFirestore para instanciar a entidade corretamente!
        return UserEntity.fromFirestore(firestoreData, firebaseUser.uid);
      }
      return null;
    } on FirebaseAuthMultiFactorException catch (e) {
      // Quando o Firebase pedir o 2FA, nós capturamos o "resolver" e lançamos um erro
      // amigável para a ViewModel identificar e redirecionar a tela.
      _resolver = e.resolver;
      throw Exception('mfa_required');
    } on FirebaseAuthException {
      // ... seus tratamentos de erro ...
      rethrow;
    }
  }

  Stream<UserEntity?> get currentUserStream {
    return FirebaseAuth.instance.authStateChanges().switchMap((user) {
      if (user == null) return Stream.value(null);

      return _firestoreService.getUserStream(user.uid).map((snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
          // Se o documento não existe no Firestore, criamos um perfil básico fallback
          final fallbackData = {
            'name': user.displayName ?? user.email?.split('@').first ?? 'Usuário',
            'email': user.email ?? '',
            'role': 'aluno',
          };
          return UserEntity.fromFirestore(fallbackData, user.uid);
        }
        final data = snapshot.data()!;
        final firestoreData = {
          'name':
              data['nomeCompleto'] ?? data['name'] ?? user.displayName ?? '',
          'email': data['email'] ?? user.email ?? '',
          'role': data['role'] ?? 'aluno',
          'photoUrl': data['photoUrl'],
          'bio': data['bio'],
        };
        return UserEntity.fromFirestore(firestoreData, user.uid);
      }).onErrorReturnWith((error, stackTrace) {
        // Se houver erro de permissão ou rede no Firestore, retornamos perfil básico baseada no Auth
        final fallbackData = {
          'name': user.displayName ?? user.email?.split('@').first ?? 'Usuário',
          'email': user.email ?? '',
          'role': 'aluno',
        };
        return UserEntity.fromFirestore(fallbackData, user.uid);
      });
    });
  }

  // Verifica se o usuário logado já possui fatores 2FA cadastrados
  Future<bool> isMfaEnrolled() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final enrolledFactors = await user.multiFactor.getEnrolledFactors();
    return enrolledFactors.isNotEmpty;
  }

  // Gera o segredo (TotpSecret) e a URL do QR Code
  Future<String> generate2FaQrCode() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null)
      throw Exception('Usuário não está logado para iniciar 2FA.');

    try {
      final session = await user.multiFactor.getSession().timeout(const Duration(seconds: 10));
      _totpSecret = await TotpMultiFactorGenerator.generateSecret(session).timeout(const Duration(seconds: 10));

      return await _totpSecret!.generateQrCodeUrl(
        accountName: user.email ?? 'Usuario',
        issuer: 'EuroAcademy',
      ).timeout(const Duration(seconds: 5));
    } catch (e) {
      throw Exception('Timeout ou erro ao gerar QR Code: $e');
    }
  }

  // Confirma o código do App Autenticador durante o primeiro setup (Enrollment)
  Future<void> confirm2FASetup(String code) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _totpSecret == null)
      throw Exception('Estado inválido para confirmar 2FA.');

    final assertion = await TotpMultiFactorGenerator.getAssertionForEnrollment(
      _totpSecret!,
      code,
    );
    await user.multiFactor.enroll(assertion, displayName: 'App Autenticador');
  }

  // Verifica o código do App Autenticador em logins subsequentes (Sign-In)
  Future<void> verify2FAToken(String code) async {
    if (_resolver == null)
      throw Exception('Sessão de login expirou. Tente novamente.');

    final hint = _resolver!.hints.firstWhere((info) => info.factorId == 'totp');
    final assertion = await TotpMultiFactorGenerator.getAssertionForSignIn(
      hint.uid,
      code,
    );

    await _resolver!.resolveSignIn(assertion);
  }

  // Faz o logout e limpa o cache do resolver/secret
  Future<void> logout() async {
    _resolver = null;
    _totpSecret = null;
    await FirebaseAuth.instance.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }
}
