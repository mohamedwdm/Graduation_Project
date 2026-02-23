import 'package:flutter/material.dart';
import 'package:go2car/core/utils/styles.dart';
import 'package:go2car/features/auth/presentation/views/login_view.dart';
import 'package:go2car/features/auth/presentation/views/widgets/register_form.dart';
import 'package:go2car/features/auth/presentation/views/widgets/register_header_section.dart';


class RegisterViewBody extends StatelessWidget {
  const RegisterViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ListView(
        children: [
          const RegisterHeaderSection(),
          const SizedBox(height: 30),

          const RegisterForm(),

          const SizedBox(height: 25),

         
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?  ", style: TextStyle(fontSize: 13,color: Color(0xff525252))),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const LoginView();
                      },
                    ),
                  );
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(color:Colors.red, fontSize: 13,fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 30,),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("By signing up, you agree to our ", style: TextStyle(fontSize: 12,color: Color(0xff525252))),
              GestureDetector(
                onTap: () {
                 
                },
                child: const Text(
                  'Terms of Service',
                  style: TextStyle(color: Color(0xff525252), fontSize: 12,decoration:TextDecoration.underline, decorationThickness: 0.8),
                ),
              ),
              Text(' and',style: TextStyle(fontSize: 12,color: Color(0xff525252))),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Text("Privacy Policy",style: TextStyle(color: Color(0xff525252), fontSize: 12,decoration:TextDecoration.underline , decorationThickness: 0.8)),
          ),
          const SizedBox(height: 15),
          Text(
            'Or',
            style: Styles.textStyle18.copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
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
