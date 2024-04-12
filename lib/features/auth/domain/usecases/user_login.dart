import 'package:clean_bloc_app/core/error/failures.dart';
import 'package:clean_bloc_app/core/usecase/usecase.dart';
import 'package:clean_bloc_app/core/entities/user.dart';
import 'package:clean_bloc_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogin implements UseCase<User, UserLoginParams> {
  final AuthRepository authRepository;

  UserLogin({required this.authRepository});

  @override
  Future<Either<Failure, User>> call(params) async {
    return await authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({required this.email, required this.password});
}
