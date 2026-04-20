import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go2car/core/config/app_router.dart';
import 'package:go2car/core/widgets/custom_button.dart';
import 'package:go2car/core/widgets/show_snackbar.dart';
import 'package:go2car/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:go2car/features/auth/presentation/views/register_view.dart';
import 'package:go2car/features/auth/presentation/views/widgets/custom_text_field.dart';
import 'package:go2car/features/layout/presentation/views/main_layout.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? email;
  String? password;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: autovalidateMode,
      key: formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailController,
            hintText: "Email",
            prefixIcon: const Icon(
              Icons.person_outline,
              color: Color(0xff525252),
              size: 22,
            ),
            onChanged: (value) {
              email = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email is required";
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return "Enter a valid email";
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _passwordController,
            prefixIcon: const Icon(
              Icons.lock_outline,
              size: 22,
              color: Color(0xff525252),
            ),
            hintText: "Password",
            isPassword: true,
            onChanged: (value) {
              password = value;
            },
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return MainLayout(user: state.user);
                  //     },
                  //   ),
                  // );
                  context.go(
                    AppRouter.homePath,
                    extra: state.user,
                  );
                  _emailController.clear();
                  _passwordController.clear();
                  showSnackBar(context, "Logged Successfully");
                } else if (state is AuthFailureState) {
                  showSnackBar(context, state.message);
                }
              },
              builder: (context, state) {
                return CustomButton(
                  isLoading: state is AuthLoading,
                  backgroundcolor: const Color(0xff00A24F),
                  textcolor: Colors.white,
                  text: 'SIGN IN',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<AuthCubit>().login(
                            email: email!,
                            password: password!,
                          );
                    } else {
                      setState(() {
                        autovalidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              backgroundcolor: const Color(0xffE5E5E5),
              textcolor: Colors.black,
              text: 'Create Acccount',
              fontsize: 16,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const RegisterView();
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          const Align(
            alignment: Alignment.center,
            child:
                Text("Forget Password?", style: TextStyle(color: Colors.red)),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              context.read<AuthCubit>().loginAsGuest();
            },
            child: const Text(
              "Continue as Guest",
              style: TextStyle(
                color: Color(0xff00A24F),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
