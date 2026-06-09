import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTitleText extends StatelessWidget {
  final String text;

  const AppTitleText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center, // text-align: center
      style: GoogleFonts.poppins(
        fontSize: 32, // font-size: 32px
        fontWeight: FontWeight.w600, // SemiBold
        fontStyle: FontStyle.normal,
        height: 1.0, // line-height: 100%
        letterSpacing: 0, // letter-spacing: 0%
      ),
    );
  }
}
