import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? text; // make it nullable
  final Widget? child; // optional custom child
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final double borderRadius;
  final double height;
  final double width;

  const CustomButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.backgroundColor = const Color(0xFF4F85AA),
    this.height = 50,
    this.width = double.infinity,
    this.borderRadius = 8,
  }) : assert(
         text != null || child != null,
         "Either text or child must be provided",
       );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        child:
            child ??
            Text(
              text!,
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
      ),
    );
  }
}
