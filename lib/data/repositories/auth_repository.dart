import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_user_service.dart';
import '../../domain/models/user_entity.dart';

class AuthRepository {
  final FirebaseAuthService _authService;
  final FirestoreUserService _firestoreService; // Adicionamos o novo service aqui

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
          'name': userData?['name'] ?? firebaseUser.displayName ?? '',
          'email': userData?['email'] ?? firebaseUser.email ?? '',
          'role': userData?['role'] ?? 'aluno',
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
    } on FirebaseAuthException catch (e) {
       // ... seus tratamentos de erro ...
       rethrow;
    }
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
    if (user == null) throw Exception('Usuário não está logado para iniciar 2FA.');

    final session = await user.multiFactor.getSession();
    _totpSecret = await TotpMultiFactorGenerator.generateSecret(session);
    
    return await _totpSecret!.generateQrCodeUrl(
      accountName: user.email ?? 'Usuario',
      issuer: 'EuroAcademy',
    );
  }

  // Confirma o código do App Autenticador durante o primeiro setup (Enrollment)
  Future<void> confirm2FASetup(String code) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _totpSecret == null) throw Exception('Estado inválido para confirmar 2FA.');

    final assertion = await TotpMultiFactorGenerator.getAssertionForEnrollment(_totpSecret!, code);
    await user.multiFactor.enroll(assertion, displayName: 'App Autenticador');
  }

  // Verifica o código do App Autenticador em logins subsequentes (Sign-In)
  Future<void> verify2FAToken(String code) async {
    if (_resolver == null) throw Exception('Sessão de login expirou. Tente novamente.');

    final hint = _resolver!.hints.firstWhere((info) => info.factorId == 'totp');
    final assertion = await TotpMultiFactorGenerator.getAssertionForSignIn(hint.uid, code);
    
    await _resolver!.resolveSignIn(assertion);
  }

  // Faz o logout e limpa o cache do resolver/secret
  Future<void> logout() async {
    _resolver = null;
    _totpSecret = null;
    await FirebaseAuth.instance.signOut();
  }
}