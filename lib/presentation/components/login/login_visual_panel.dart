import 'package:flutter/material.dart';

class LoginVisualPanel extends StatelessWidget {
  const LoginVisualPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          left: -100,
          bottom: -100,
          child: Opacity(
            opacity: 0.5,
            child: Image.asset('assets/images/vetor.png', width: 600), 
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 280),
            // O texto "Seu futuro em um clique" e o SizedBox foram removidos daqui!
          ],
        ),
      ],
    );
  }
}