import 'package:flutter/material.dart';
import 'package:mobile_wallet/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_wallet/core/services/auth_service.dart';
import 'package:mobile_wallet/core/services/conn_service.dart';
import 'package:mobile_wallet/core/utils/theme_service.dart';
import 'package:provider/provider.dart';
//import 'package:hive/hive.dart';
//import 'package:hive_flutter/hive_flutter.dart';
//import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyBUJU-ssm2XwRJIG9yrfHsNjM75J0FIINQ",
    appId: "1:379146429007:android:add23d166385d68aa4403a",
    messagingSenderId: "379146429007",
    projectId: "app-madis",
    storageBucket: "app-madis",
  ));

  /*  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  ); */

  Provider.debugCheckInvalidValueType = null; // Disable the check

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<LoginService>(create: (_) => LoginService()),
        ChangeNotifierProvider<ThemeService>(create: (_) => ThemeService()),
      ],
      child: MyApp(),
    ),
  );
}
