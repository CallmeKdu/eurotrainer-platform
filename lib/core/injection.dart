import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/repositories/auth_repository.dart';
import '../presentation/viewmodels/auth_viewmodel.dart';
import '../presentation/viewmodels/home_viewmodel.dart';
import '../presentation/viewmodels/training_viewmodel.dart';
import '../presentation/viewmodels/course_player_viewmodel.dart';
import '../data/services/firebase_auth_service.dart';
import '../data/services/firestore_user_service.dart';
import '../data/services/firebase_storage_service.dart';
import '../presentation/viewmodels/profile_viewmodel.dart';
/*
criando a injeção de dependências para o projeto, usando o get_it (variável sl) para registrar as dependências, como o Dio 
para fazer requisições HTTP. A função initInjection é chamada no início do aplicativo para configurar as dependências necessárias.
*/
final sl = GetIt.instance;

Future<void> initInjection() async {
  // Firebase Auth
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // 1. Camada de rede (Externa)
  sl.registerLazySingleton<Dio>(() => Dio());

  // 2. Quando criarmos as funcionalidades (ex: auth, cursos),
  // viremos aqui registrar os DataSources, Repositories e ViewModels.

  // Services (Usamos LazySingleton para criar uma única instância ao decorrer do app)
  sl.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
  sl.registerLazySingleton<FirestoreUserService>(() => FirestoreUserService());
  sl.registerLazySingleton<FirebaseStorageService>(() => FirebaseStorageService());

  // Repositories (Injetamos automaticamente os services registrados acima através do sl())
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl(), sl()));

  // ViewModels (Usamos Factory pois dependendo do fluxo pode ser recriado se destruído na UI)
  sl.registerFactory<AuthViewModel>(() => AuthViewModel(sl()));
  sl.registerFactory<HomeViewModel>(() => HomeViewModel());
  sl.registerFactory<TrainingViewModel>(() => TrainingViewModel());
  sl.registerFactory<CoursePlayerViewModel>(() => CoursePlayerViewModel());
  sl.registerFactory<ProfileViewModel>(() => ProfileViewModel(sl(), sl(), sl()));
}
