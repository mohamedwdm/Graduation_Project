import 'package:flutter/material.dart';
import 'package:go2car/core/utils/styles.dart';
import 'package:go2car/features/auth/presentation/views/register_view.dart';
import 'package:go2car/features/auth/presentation/views/widgets/login_form.dart';
import 'package:go2car/features/auth/presentation/views/widgets/login_header_section.dart';


class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ListView(
        children: [
          const LoginHeaderSection(),
          const SizedBox(height: 40),
          const LoginForm(),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("By continuing, you agree to our ", style: TextStyle(fontSize: 12,color: Color(0xff525252))),
              GestureDetector(
                onTap: () {
                 
                },
                child: const Text(
                  'Terms of Service',
                  style: TextStyle(color: Color(0xff525252), fontSize: 12,decoration:TextDecoration.underline),
                ),
              ),
            ],
          ),
          // const SizedBox(height: 15),
          // Text(
          //   'Or',
          //   style: Styles.textStyle18.copyWith(color: Colors.grey.shade600),
          //   textAlign: TextAlign.center,
          // ),
          // const CustomButtonForSocialMediaConnection(
          //   icon: FontAwesomeIcons.facebookF,
          //   backgroundcolor: Color(0xff395998),
          //   textcolor: Colors.white,
          //   text: 'CONNECT WITH FACEBOOK',
          // ),
          // const SizedBox(height: 10),
          // const CustomButtonForSocialMediaConnection(
          //   icon: FontAwesomeIcons.google,
          //   backgroundcolor: Color(0xff4285f4),
          //   textcolor: Colors.white,
          //   text: 'CONNECT WITH GOOGLE',
          // ),
        ],
      ),
    );
  }
}
