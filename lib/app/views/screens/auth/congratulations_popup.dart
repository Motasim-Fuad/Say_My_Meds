import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CongratulationsPopup extends StatelessWidget {
  const CongratulationsPopup({super.key});

  // Function to show the congratulations popup
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // user can tap outside to close
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 1,
          child: SizedBox(
            width: 400,
            height: 343,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Check icon inside a circle
                      Center(
                        child: Container(
                          height: 98,
                          width: 98,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF4F85AA,
                            ), // hex color from CSS

                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(20),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Congratulations!",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600, // SemiBold
                          fontStyle:
                              FontStyle.normal, // Bold is handled by FontWeight
                          fontSize: 28.0,
                          height: 1.0, // line-height: 100%
                          letterSpacing: 0.0, // 0% letter-spacing
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Password Changed",
                        textAlign: TextAlign
                            .center, // aligns like CSS `text-align: center`
                        style: GoogleFonts.openSans(
                          fontSize: 16, // font-size: 16px
                          fontWeight: FontWeight.w400, // font-weight: 400
                          fontStyle: FontStyle.normal, // font-style: Regular
                          letterSpacing: 0, // letter-spacing: 0px
                          height: 1.0, // line-height: 100%
                          color: Colors.grey, // optional: matches your design
                        ),
                      ),
                    ],
                  ),
                ),
                // Close button on top right
                Positioned(
                  top: 5.25,
                  right: 5.25,
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 1, // border width
                      ),
                      // boxShadow: [
                      //   BoxShadow(blurRadius: 4, offset: Offset(0, 2)),
                      // ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: const Color(0xFF848484),
                      ),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // ✅ return empty widget safely
  }
}
