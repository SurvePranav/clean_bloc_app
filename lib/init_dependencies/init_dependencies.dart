import 'package:clean_bloc_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:clean_bloc_app/core/network/connection_checker.dart';
import 'package:clean_bloc_app/core/secrets/app_secrets.dart';
import 'package:clean_bloc_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:clean_bloc_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:clean_bloc_app/features/auth/domain/repository/auth_repository.dart';
import 'package:clean_bloc_app/features/auth/domain/usecases/current_user.dart';
import 'package:clean_bloc_app/features/auth/domain/usecases/user_login.dart';
import 'package:clean_bloc_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:clean_bloc_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:clean_bloc_app/features/blogs/data/data_sources/blog_local_datasource.dart';
import 'package:clean_bloc_app/features/blogs/data/data_sources/blog_remote_data_source.dart';
import 'package:clean_bloc_app/features/blogs/data/repositories/blog_repo_impl.dart';
import 'package:clean_bloc_app/features/blogs/domain/repositories/blog_repository.dart';
import 'package:clean_bloc_app/features/blogs/domain/usecases/get_all_blogs.dart';
import 'package:clean_bloc_app/features/blogs/domain/usecases/upload_blog.dart';
import 'package:clean_bloc_app/features/blogs/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabasetUrl,
    anonKey: AppSecrets.supabaseSecretKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);

  // hive
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  serviceLocator.registerLazySingleton<Box>(() => Hive.box(name: 'blogs'));

  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  serviceLocator.registerFactory(() => InternetConnection());

  serviceLocator.registerFactory<ConnectionChecker>(() => ConnectionCheckerImpl(
        internetConnection: serviceLocator<InternetConnection>(),
      ));
}

void _initAuth() {
  // datasource
  serviceLocator
      .registerFactory<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
            supabaseClient: serviceLocator<SupabaseClient>(),
          ));

  // repository
  serviceLocator.registerFactory<AuthRepository>(() => AuthRepoSitoryImpl(
        remoteDataSource: serviceLocator<AuthRemoteDataSource>(),
        connectionChecker: serviceLocator<ConnectionChecker>(),
      ));

  // usecases
  serviceLocator.registerFactory(() => UserSignUp(
        authRepository: serviceLocator<AuthRepository>(),
      ));
  serviceLocator.registerFactory(() => UserLogin(
        authRepository: serviceLocator<AuthRepository>(),
      ));
  serviceLocator.registerFactory(() => CurrentUser(
        authRepository: serviceLocator<AuthRepository>(),
      ));

  serviceLocator.registerLazySingleton(() => AuthBloc(
        userSignUp: serviceLocator<UserSignUp>(),
        userLogin: serviceLocator<UserLogin>(),
        currentUser: serviceLocator<CurrentUser>(),
        appUserCubit: serviceLocator<AppUserCubit>(),
      ));
}

void _initBlog() {
  // datasource
  serviceLocator
      .registerFactory<BlogRemoteDataSource>(() => BlogRemoteDataSourceImpl(
            supabaseClient: serviceLocator<SupabaseClient>(),
          ));
  serviceLocator
      .registerFactory<BlogLocalDataSource>(() => BlogLocalDataSourceImpl(
            box: serviceLocator<Box>(),
          ));

  // repo
  serviceLocator.registerFactory<BlogRepository>(() => BlogRepoImpl(
        blogRemoteDataSource: serviceLocator<BlogRemoteDataSource>(),
        blogLocalDataSource: serviceLocator<BlogLocalDataSource>(),
        connectionChecker: serviceLocator<ConnectionChecker>(),
      ));

  // usecases
  serviceLocator.registerFactory(() => UploadBlog(
        blogRepository: serviceLocator<BlogRepository>(),
      ));
  serviceLocator.registerFactory(() => GetAllBlogs(
        blogRepository: serviceLocator<BlogRepository>(),
      ));

  // bloc
  serviceLocator.registerLazySingleton(() => BlogBloc(
        uploadBlog: serviceLocator<UploadBlog>(),
        getAllBlogs: serviceLocator<GetAllBlogs>(),
      ));
}
