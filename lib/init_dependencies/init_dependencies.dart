import 'package:clean_bloc_app/core/secrets/app_secrets.dart';
import 'package:clean_bloc_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:clean_bloc_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:clean_bloc_app/features/auth/domain/repository/auth_repository.dart';
import 'package:clean_bloc_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:clean_bloc_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabasetUrl,
    anonKey: AppSecrets.supabaseSecretKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  serviceLocator
      .registerFactory<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
            supabaseClient: serviceLocator<SupabaseClient>(),
          ));

  serviceLocator.registerFactory<AuthRepository>(() => AuthRepoSitoryImpl(
        remoteDataSource: serviceLocator<AuthRemoteDataSource>(),
      ));

  serviceLocator.registerFactory(() => UserSignUp(
        authRepository: serviceLocator<AuthRepository>(),
      ));

  serviceLocator.registerLazySingleton(() => AuthBloc(
        userSignUp: serviceLocator<UserSignUp>(),
      ));
}
