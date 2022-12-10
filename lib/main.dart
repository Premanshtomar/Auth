import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/pages/authentication/screens/forgot_password/forgot_password.dart';
import 'package:notes/pages/authentication/screens/login_page/login.dart';
import 'package:notes/pages/authentication/screens/signup_page/signup.dart';
import 'package:notes/pages/home_page/screen/home.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null
          ? const HomePage()
          : const LogIn(),
      routes: {
        '/homepage/': (context) => const HomePage(),
        '/logging/': (context) => const LogIn(),
        '/signing/': (context) => const SignUp(),
        '/reset_pass/': (context) => const ForgetPassword(),
      });
  }
}
