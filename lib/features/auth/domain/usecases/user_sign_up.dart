import 'package:clean_bloc_app/core/error/failures.dart';
import 'package:clean_bloc_app/core/usecase/usecase.dart';
import 'package:clean_bloc_app/features/auth/domain/entities/user.dart';
import 'package:clean_bloc_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<User, UserSignupParams> {
  final AuthRepository authRepository;
  UserSignUp({required this.authRepository});

  @override
  Future<Either<Failure, User>> call(UserSignupParams params) async {
    return await authRepository.signupWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignupParams {
  final String email;
  final String password;
  final String name;

  UserSignupParams(
      {required this.email, required this.password, required this.name});
}
