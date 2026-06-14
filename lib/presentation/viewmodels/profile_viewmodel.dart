import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/services/firebase_storage_service.dart';
import '../../data/services/firestore_user_service.dart';
import '../../data/repositories/auth_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final FirebaseStorageService _storageService;
  final FirestoreUserService _firestoreService;
  final AuthRepository _authRepository;

  final ImagePicker _picker = ImagePicker();

  ProfileViewModel(this._storageService, this._firestoreService, this._authRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _successMessage = '';
  String get successMessage => _successMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    if (value) {
      _errorMessage = '';
      _successMessage = '';
    }
    notifyListeners();
  }

  Future<void> pickAndUploadImage(String uid) async {
    _setLoading(true);
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image == null) {
        _setLoading(false);
        return;
      }

      final Uint8List bytes = await image.readAsBytes();
      final String extension = image.name.split('.').last.toLowerCase();

      final String validExtension = ['jpg', 'jpeg', 'png', 'webp'].contains(extension) ? extension : 'jpg';

      final downloadUrl = await _storageService.uploadProfilePicture(uid, bytes, validExtension);

      await _firestoreService.updateUser(uid, {'photoUrl': downloadUrl});

      _successMessage = 'Foto de perfil atualizada com sucesso!';
    } catch (e) {
      _errorMessage = 'Erro ao atualizar foto: $e';
      debugPrint('Erro no upload de imagem: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProfileData(String uid, String role, String bio) async {
    _setLoading(true);
    try {
      await _firestoreService.updateUser(uid, {
        'role': role,
        'bio': bio,
      });
      _successMessage = 'Perfil atualizado com sucesso!';
    } catch (e) {
      _errorMessage = 'Erro ao atualizar perfil.';
      debugPrint('Erro ao atualizar dados do perfil: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    try {
      await _authRepository.resetPassword(email);
      _successMessage = 'E-mail de redefinição de senha enviado!';
    } catch (e) {
      _errorMessage = 'Erro ao enviar e-mail de redefinição.';
      debugPrint('Erro ao redefinir senha: $e');
    } finally {
      _setLoading(false);
    }
  }

  void clearMessages() {
    _errorMessage = '';
    _successMessage = '';
    notifyListeners();
  }
}
