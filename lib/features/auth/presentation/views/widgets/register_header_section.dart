import 'package:flutter/material.dart';
import 'package:go2car/core/utils/styles.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterHeaderSection extends StatelessWidget {
  const RegisterHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text("Create Account", style: GoogleFonts.inter( fontSize: 27,fontWeight: FontWeight.w700,),),
         SizedBox(height: 5,),
         Text("Join Go2Car and start parking smart.", style: GoogleFonts.inter( color: Color(0xff525252)),),
        // Text.rich(
        //   TextSpan(
        //     children: [
        //       const TextSpan(
        //         text: "Enter your Name, Email and Password for sign up.",
        //         style: Styles.textStyle16,
        //       ),
        //       TextSpan(
        //         text: " Already have account?",
        //         style: Styles.textStyle16.copyWith(
        //           color: const Color(0xff52b77d),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
