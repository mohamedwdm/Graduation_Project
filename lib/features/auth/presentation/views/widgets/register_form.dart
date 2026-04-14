import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go2car/core/widgets/custom_button.dart';
import 'package:go2car/core/widgets/show_snackbar.dart';
import 'package:go2car/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:go2car/features/auth/presentation/views/login_view.dart';
import 'package:go2car/features/auth/presentation/views/widgets/custom_text_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? name;
  String? email;
  String? password;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
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
            prefixIcon: const Icon(
              Icons.person_outline,
              color: Color(0xff525252),
              size: 21,
            ),
            controller: _nameController,
            hintText: "Full Name",
            onChanged: (value) {
              name = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Full Name is required";
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _emailController,
            prefixIcon: const Icon(
              Icons.mail_outline,
              color: Color(0xff525252),
              size: 21,
            ),
            hintText: "Email Address",
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
            controller: _phoneController,
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: Color(0xff525252),
              size: 21,
            ),
            hintText: "Phone Number (Optional)",
            onChanged: (value) {
              // Phone logic not yet implemented in Cubit
            },
          ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _passwordController,
            prefixIcon: const Icon(
              Icons.lock_outline,
              size: 21,
              color: Color(0xff525252),
            ),
            hintText: "Password",
            isPassword: true,
            onChanged: (value) {
              password = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password is required";
              }
              if (value.length < 6) {
                return "Password must be at least 6 characters";
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is RegisterSuccess) {
                  showSnackBar(context, "Registered Successfully");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const LoginView();
                      },
                    ),
                  );
                } else if (state is AuthFailureState) {
                  showSnackBar(context, state.message);
                }
              },
              builder: (context, state) {
                return CustomButton(
                  isLoading: state is AuthLoading,
                  backgroundcolor: const Color(0xff00A24F),
                  textcolor: Colors.white,
                  text: 'Create Account',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.read<AuthCubit>().register(
                        email: email!,
                        password: password!,
                        name: name!,
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
        ],
      ),
    );
  }
}
