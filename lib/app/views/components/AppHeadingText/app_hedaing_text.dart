import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppHeadingText extends StatelessWidget {
  final String text;

  const AppHeadingText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center, // center alignment
      style: GoogleFonts.poppins(
        color: Color(0xFF333333), // dark gray
        fontSize: 30, // 30px
        fontWeight: FontWeight.bold, // SemiBold
        fontStyle: FontStyle.normal, // normal style
        height: 1.0, // line-height: 100%
        letterSpacing: 0.0, // letter-spacing: 0%
      ),
    );
  }
}
