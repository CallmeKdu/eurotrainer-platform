import 'package:flutter_test/flutter_test.dart';
import 'package:eurotrainer_platform/presentation/viewmodels/home_viewmodel.dart';
import 'package:eurotrainer_platform/domain/models/user_entity.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeViewModel Tests', () {
    late HomeViewModel homeViewModel;

    setUp(() {
      homeViewModel = HomeViewModel();
    });

    test('nomeFormatado should return empty string when user is null', () {
      homeViewModel.updateUser(null);
      expect(homeViewModel.nomeFormatado, "");
    });

    test('nomeFormatado should return single name if user has only one name', () {
      final user = UserEntity(id: '1', name: 'Carlos', email: 'carlos@test.com', role: 'aluno');
      homeViewModel.updateUser(user);
      expect(homeViewModel.nomeFormatado, "Carlos");
    });

    test('nomeFormatado should return first and last name', () {
      final user = UserEntity(id: '1', name: 'Carlos Eduardo Silva', email: 'carlos@test.com', role: 'aluno');
      homeViewModel.updateUser(user);
      expect(homeViewModel.nomeFormatado, "Carlos Silva");
    });

    test('nomeFormatado should handle names with extra spaces', () {
      final user = UserEntity(id: '1', name: '  Carlos   Eduardo   Silva  ', email: 'carlos@test.com', role: 'aluno');
      homeViewModel.updateUser(user);
      expect(homeViewModel.nomeFormatado, "Carlos Silva");
    });

    test('nomeFormatado should return empty string when name is empty', () {
      final user = UserEntity(id: '1', name: '', email: 'empty@test.com', role: 'aluno');
      homeViewModel.updateUser(user);
      expect(homeViewModel.nomeFormatado, "");
    });
  });
}
