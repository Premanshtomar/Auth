// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/alert_dialog.dart';
import '../../../../utils/exceptions.dart';
import '../../repo/repo.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool onChanged = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.09, top: MediaQuery.of(context).size.height * 0.18),
              child: const Text(
                'Welcome\nBack',
                style: TextStyle(color: Colors.white, fontSize: 33,
                fontWeight: FontWeight.w700),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(CupertinoIcons.at_circle),
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              label: const Text(
                                'Email',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: _password,
                            keyboardType: TextInputType.visiblePassword,
                            enableSuggestions: false,
                            autocorrect: false,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(CupertinoIcons.lock_circle),
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              label: const Text(
                                'Password',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Material(
                                borderRadius: BorderRadius.circular(onChanged ? 150 : 10),
                                color: onChanged
                                    ? Colors.lightBlueAccent.shade200
                                    : Colors.grey.shade200,
                                child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      onChanged = true;
                                    });
                                    await Future.delayed(const Duration(milliseconds: 500));
                                    final email = _email.text.trim();
                                    final password = _password.text;
                                    final firebaseUser = FirebaseUser();
                                    // ignore: duplicate_ignore,
                                    try {
                                      await firebaseUser.logInUser(
                                          email: email, password: password);
                                      final user = FirebaseAuth.instance.currentUser;
                                      if (user != null && user.emailVerified) {
                                        Navigator.of(context).pushNamedAndRemoveUntil(
                                            '/homepage/', (route) => false);
                                      } else {
                                        user?.sendEmailVerification();
                                        showEmailVerificationDialog(context,
                                            'Email verification link is sent to your email address');
                                      }
                                    } on UserNotFoundAuthException catch (_) {
                                      showErrorDialog(context, 'User Not Found.');
                                    } on WrongPasswordAuthException catch (_) {
                                      showErrorDialog(context, 'Wrong Password.');
                                    } on InvalidEmailAuthException catch (_) {
                                      showErrorDialog(context, 'Invalid Email');
                                    } on GenericAuthException catch (_) {
                                      showErrorDialog(context, 'Authentication Error.');
                                    }
                                    setState(() {
                                      onChanged = false;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    // alignment: Alignment.center,
                                    width: onChanged
                                        ? MediaQuery.of(context).size.width * 0.12
                                        : MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.width * 0.14,
                                    duration: const Duration(milliseconds: 500),
                                    child: onChanged
                                        ? const Icon(
                                      Icons.done,
                                      color: Colors.black,
                                      size: 50,
                                    )
                                        : const Center(
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textScaleFactor: 3,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(context, '/signing/', (route) => false);
                                },
                                style: const ButtonStyle(),
                                child: const Text(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                        '/reset_pass/', (route) => false);
                                  },
                                  child: const Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18,
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
