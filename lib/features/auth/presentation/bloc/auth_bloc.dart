import 'package:clean_bloc_app/features/auth/domain/entities/user.dart';
import 'package:clean_bloc_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  AuthBloc({
    required UserSignUp userSignUp,
  })  : _userSignUp = userSignUp,
        super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      emit(AuthLoadingState());

      final response = await _userSignUp(UserSignupParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ));

      response.fold(
        (failure) => emit(AuthFailureState(message: failure.message)),
        (user) => emit(AuthSuccessState(user: user)),
      );
    });
  }
}
