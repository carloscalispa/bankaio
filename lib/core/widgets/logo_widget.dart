// lib/core/widgets/logo_widget.dart
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key, this.size = 100.0});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/BankAio.png',
      width: size,
      height: size,
    );
  }
}

