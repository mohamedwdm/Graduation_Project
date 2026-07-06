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

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? name;
  String? email;
  String? password;
  String selectedUserType = 'driver';
  bool hasSpecialNeeds = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
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
          const SizedBox(height: 10),
          Theme(
            data: Theme.of(context).copyWith(
              checkboxTheme: CheckboxThemeData(
                fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color(0xff00A24F);
                  }
                  return null;
                }),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            child: CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: hasSpecialNeeds,
              onChanged: (value) {
                setState(() {
                  hasSpecialNeeds = value ?? false;
                });
              },
              title: const Text(
                "Are you someone with special needs?",
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff525252),
                ),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xff00A24F),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is RegisterSuccess) {
                  showSnackBar(
                    context,
                    "Registered Successfully",
                    backgroundColor: const Color(0xff00A24F),
                  );
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
                        userType: hasSpecialNeeds ? 'handicap' : selectedUserType,
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
