import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
}
