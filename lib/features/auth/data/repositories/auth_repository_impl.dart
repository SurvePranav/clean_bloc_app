import 'package:clean_bloc_app/core/error/exceptions.dart';
import 'package:clean_bloc_app/core/error/failures.dart';
import 'package:clean_bloc_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:clean_bloc_app/features/auth/domain/entities/user.dart';
import 'package:clean_bloc_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepoSitoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepoSitoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> loginWithEmailPassword(
      {required String email, required String password}) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signupWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
