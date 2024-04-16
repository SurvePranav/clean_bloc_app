part of 'init_dependencies.dart';

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
