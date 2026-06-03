import 'package:flutter/material.dart';

class FptHeader extends StatelessWidget {
  const FptHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/fpt_logo.png',
          width: 96,
        ),
        const SizedBox(height: 20),
        const Text(
          'My FPT School',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFFF5A2F),
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
