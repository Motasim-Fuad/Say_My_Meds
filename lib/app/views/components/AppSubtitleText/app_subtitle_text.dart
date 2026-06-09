import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSubtitleText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const AppSubtitleText(
    this.text, {
    super.key,
    this.textAlign = TextAlign.left, // Default alignment is left
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign, // Apply the text alignment
      style: GoogleFonts.openSans(
        color: Color(0xFF333333),
        fontSize: 24, // 24px
        fontWeight: FontWeight.w600, // SemiBold
        fontStyle: FontStyle.normal, // normal style
        height: 1.0, // line-height: 100%
        letterSpacing: 0.0, // letter-spacing: 0
      ),
    );
  }
}
