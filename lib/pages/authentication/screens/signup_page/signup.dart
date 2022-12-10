// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../utils/alert_dialog.dart';
import '../../../../utils/exceptions.dart';
import '../../repo/repo.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool onChanged = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.09,
                  top: MediaQuery.of(context).size.height * 0.07),
              child: const Text(
                'Create\nAccount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.33),
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
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "Email",
                              hintStyle: const TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              label: const Text(
                                'Email',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.028),
                          TextField(
                            controller: _password,
                            keyboardType: TextInputType.visiblePassword,
                            enableSuggestions: false,
                            autocorrect: false,
                            style: const TextStyle(color: Colors.white),
                            obscureText: true,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "Password",
                              hintStyle: const TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              label: const Text(
                                'Password',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.07),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Material(
                                borderRadius:
                                    BorderRadius.circular(onChanged ? 150 : 10),
                                color: onChanged
                                    ? Colors.lightBlueAccent.shade100
                                    : Colors.grey.shade200,
                                child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      onChanged = true;
                                    });
                                    await Future.delayed(
                                        const Duration(milliseconds: 500));
                                    final email = _email.text.trim();
                                    final password = _password.text;
                                    final firebaseUser = FirebaseUser();
                                    // ignore: duplicate_ignore,
                                    try {
                                      await firebaseUser.createUser(
                                          email: email, password: password);
                                      final user =
                                          FirebaseAuth.instance.currentUser;
                                      if (user != null) {
                                        await user.sendEmailVerification();
                                        showEmailVerificationDialog(context,
                                            'Email verification link is sent to your Email');
                                        setState(() {
                                          onChanged = false;
                                        });
                                      }
                                      Navigator.of(context)
                                          .pushNamed('/email_verify/');
                                    } on WeakPasswordAuthException catch (_) {
                                      showErrorDialog(
                                          context, 'Password Is Too Weak');
                                    } on EmailAlreadyInUseAuthException catch (_) {
                                      showErrorDialog(
                                          context, 'Email Already In Use.');
                                    } on InvalidEmailAuthException catch (_) {
                                      showErrorDialog(context, 'Invalid Email');
                                    } on GenericAuthException catch (_) {
                                      showErrorDialog(
                                          context, 'Authentication Error.');
                                    }
                                    setState(() {
                                      onChanged = false;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    // alignment: Alignment.center,
                                    width: onChanged
                                        ? MediaQuery.of(context).size.width *
                                            0.12
                                        : MediaQuery.of(context).size.width *
                                            0.4,
                                    height: MediaQuery.of(context).size.width *
                                        0.14,
                                    duration: const Duration(milliseconds: 500),
                                    child: onChanged
                                        ? const Icon(
                                            Icons.done,
                                            color: Colors.black,
                                            size: 50,
                                          )
                                        : const Center(
                                            child: Text(
                                              'Sign-up',
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
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.06),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/logging/');
                                },
                                style: const ButtonStyle(),
                                child: const Text(
                                  'Login',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          )
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
