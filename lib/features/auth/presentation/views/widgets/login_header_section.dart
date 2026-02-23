import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginHeaderSection extends StatelessWidget {
  const LoginHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/images/car_logo.svg', width: 65, height: 65),
        SizedBox(height: 10,),
        Text("Welcome to Go2Car", style: GoogleFonts.inter( fontSize: 24,fontWeight: FontWeight.w700,),),
        SizedBox(height: 5,),
        Text("Find your spot, hassle-free.", style: GoogleFonts.inter( fontSize: 14,color: Color(0xff525252))),
      ],
    );
  }
}
