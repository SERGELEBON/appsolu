import 'package:flutter/material.dart';
import 'package:mobile_wallet/library/common_widgets/app_logo.dart';


class LogoWithSplash extends StatelessWidget {
  const LogoWithSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppLogo(),
        const SizedBox(height: 20),
        Image.asset(
          'assets/images/splash.png',
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
