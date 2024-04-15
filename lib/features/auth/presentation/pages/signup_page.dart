import 'package:clean_bloc_app/core/common/widgets/loader.dart';
import 'package:clean_bloc_app/core/theme/app_palette.dart';
import 'package:clean_bloc_app/core/utils/show_snackbar.dart';
import 'package:clean_bloc_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:clean_bloc_app/features/auth/presentation/pages/login_page.dart';
import 'package:clean_bloc_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:clean_bloc_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:clean_bloc_app/features/blogs/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignupPage(),
      );
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: MediaQuery.of(context).size.height - 200,
          width: double.maxFinite,
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (BuildContext context, Object? state) {
              if (state is AuthFailureState) {
                showSnackBar(context, state.message);
              } else if (state is AuthSuccessState) {
                Navigator.pushAndRemoveUntil(
                  context,
                  HomePage.route(),
                  (route) => false,
                );
              }
            },
            builder: (BuildContext context, state) {
              if (state is AuthLoadingState) {
                return const Loader();
              } else {
                return Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign Up',
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      AuthField(
                        hintText: 'Name',
                        controller: nameController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      AuthField(
                        hintText: 'Email',
                        controller: emailController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      AuthField(
                        hintText: 'Password',
                        controller: passwordController,
                        isObscureText: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthButton(
                        childText: 'Sign Up',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(AuthSignUp(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  name: nameController.text.trim(),
                                ));
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context, LoginPage.route()),
                        child: RichText(
                          text: TextSpan(
                              text: 'Already have an account? ',
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                                TextSpan(
                                  text: 'Sign In',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: AppPallete.gradient2,
                                      ),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
