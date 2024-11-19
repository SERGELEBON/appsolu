import 'package:flutter/material.dart';
import 'package:mobile_wallet/app/pages/home/home_page.dart';
import 'package:mobile_wallet/app/pages/login/forgot_password_page.dart';
import 'package:mobile_wallet/app/pages/login/resetpassord/ResetPasswordPage.dart';
//import 'package:mobile_wallet/app/pages/login/resetpassord/forgot_password_page.dart';
import 'package:mobile_wallet/app/pages/login/login_page.dart';
import 'package:mobile_wallet/app/pages/landing_page.dart';
import 'package:mobile_wallet/app/pages/login/login_password.dart';
import 'package:mobile_wallet/app/pages/login/resetpassord/otp_reset.dart';
import 'package:mobile_wallet/app/pages/reload_account/reload_page.dart';
import 'package:mobile_wallet/app/pages/sending_account/sending_money_page.dart';
import 'package:mobile_wallet/app/pages/sign_up/register/register_page.dart';
import 'package:mobile_wallet/app/pages/wrapper_page.dart';
import 'package:mobile_wallet/app/pages/sign_up/otp_verification_page.dart';
import 'package:mobile_wallet/app/pages/sign_up/phone_input_page.dart';
import 'package:mobile_wallet/app/pages/sign_up/register_form.dart';
import 'package:mobile_wallet/app/pages/sign_up/terms_conditions_page.dart';
import 'package:mobile_wallet/app/pages/sign_up/welcome_page.dart';
import 'package:mobile_wallet/core/services/auth_service.dart';
import 'package:mobile_wallet/core/services/conn_service.dart';
import 'package:mobile_wallet/core/utils/theme_service.dart';
import 'package:provider/provider.dart';

import '../core/services/firestore/firestore_service.dart';
import 'pages/login/resetpassord/ModifyPasswordPage.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeService _themeService = ThemeService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<UserService>(create: (_) => UserService()),
        Provider<LoginService>(
          create: (_) => LoginService(),
        ),

        //ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Madis Finance',
        //theme: themeService.isDarkMode ?
        // ThemeData.dark() : ThemeData.light(),// Utiliser le mode système par défaut
        initialRoute: '/',
        routes: {
          '/': (context) => const WrapperPage(),
          '/landing_page': (context) => LandingPage(),
          '/sign_up/phone_input': (context) => const PhoneInputPage(),
          '/sign_up/otp_verification': (context) => const OTPVerificationPage(),
          '/sign_up/register_form': (context) => const RegisterForm(),
          '/sign_up/welcome': (context) => const WelcomePage(),
          '/login/login_page': (context) => LoginPage(),
          '/login/forgot_password_page': (context) =>
              const ForgotPasswordPage(),
          '/login/otp_reset_page': (context) => const OtpResetPage(),
          '/login/login_password_page': (context) => const LoginPasswordPage(),
          '/sign_up/terms_conditions_page.dart': (context) =>
              TermsConditionsPage(),
          '/home/HomePage': (context) => HomePage(
                idNumber: '',
              ),
          '/login/reset_password_page': (context) => const ResetPasswordPage(),
          '/login/modify_password_page': (context) =>
              const Modifypasswordpage(),
          '/reload_account/relad_page': (context) =>  ReloadPage(),
          '/sending_account/sending_account_page': (context) =>  SendingMoneyPage(),
        },
      ),
    );
  }
}
