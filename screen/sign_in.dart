import 'dart:math';

import 'package:example/screen/firebase_authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SingIn extends StatefulWidget {
  const SingIn({Key? key}) : super(key: key);

  @override
  State<SingIn> createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
  bool emailValid = false;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/jpg/yellow-and-white-cartoon-stars-on-blue-background-seamless-vector-pattern.jpg',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              padding: const EdgeInsets.all(36.0),
              width: double.infinity,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.blueAccent.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.network(
                        "https://firebase.google.com/downloads/brand-guidelines/SVG/logo-logomark.svg",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "Hello Again",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc rhoncus tristique iaculis. Donec molestie lacus lacus, a fermentum justo ultrices vitae.",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  TextField(
                    onSubmitted: (e) {
                      String pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp exp = RegExp(pattern);
                      if (exp.hasMatch(e)) {
                        emailValid = true;
                      } else {
                        emailValid = false;
                      }
                      setState(() {});
                    },
                    controller: email,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      label: const Text("@example.com"),
                      suffixIcon: emailValid
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  TextField(
                    controller: password,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        label: const Text("Password"),
                        suffixIcon: InkWell(
                          borderRadius: BorderRadius.circular(30.0),
                          onTap: () {
                            generateAndUpdatePassword(password);
                          },
                          child: const Icon(Icons.password_rounded),
                        )),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text("Privacy Policy"),
                      ),
                      TextButton(
                        child: const Text("I already have account"),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () {
                      //Todo : implement onClick;

                      if (!emailValid) {
                        return;
                      }
                      if (password.text.length < 8) {
                        return;
                      }

                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return FutureBuilder<User>(
                              future: FirebaseAuthentication.instance
                                  .createAccountWithEmailAndPAssword(
                                      email.text, password.text),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return const Success();
                                }
                                if (snapshot.hasError) {
                                  return ErrorOccured(snapshot: snapshot);
                                }

                                return const InProgress();
                              },
                            );
                          });
                    },
                    child: const Text("Create Account"),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.grey.shade100,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/24px-Google_%22G%22_Logo.svg.png"),
                          const SizedBox(
                            width: 12.0,
                          ),
                          const Text("Continue with Google"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void generateAndUpdatePassword(TextEditingController password) {
    String capitalLetter = "ABVDEFGHIJKKLMNOPQRSTUVWXYZ";
    String smallLetter = "abcdefghijklmnopqrstuvwxyz";
    String specialCharacter = "`/.,><;[]{}@#\$^&*()-=+-.~";
    String number = "0123456789";

    String passwordString =
        "$capitalLetter-$smallLetter-$specialCharacter-$number";

    password.text = List.generate(20, (index) {
      int randomIndex = Random.secure().nextInt(passwordString.length);
      return passwordString[randomIndex];
    }).join("");
  }
}

class ErrorOccured extends StatelessWidget {
  final AsyncSnapshot<User> snapshot;
  const ErrorOccured({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.red,
            radius: 28.0,
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            "Failed to create an account",
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(snapshot.error.toString()),
          const SizedBox(
            height: 16.0,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(
                double.infinity,
                50,
              ),
              primary: Colors.red,
            ),
            child: const Text("Close"),
          ),
          const SizedBox(
            height: 16.0,
          ),
        ],
      ),
    );
  }
}

class Success extends StatelessWidget {
  const Success({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.green,
            radius: 28.0,
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            "Account Creation Successful",
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(
            height: 8.0,
          ),
          const Text("We successfully created an account with us."),
          const SizedBox(
            height: 16.0,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(
                double.infinity,
                50,
              ),
              primary: Colors.green,
            ),
            child: const Text("Continue"),
          ),
          const SizedBox(
            height: 16.0,
          ),
        ],
      ),
    );
  }
}

class InProgress extends StatelessWidget {
  const InProgress({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            "Account creation in Progress",
            style: Theme.of(context).textTheme.headline6,
          )
        ],
      ),
    );
  }
}
