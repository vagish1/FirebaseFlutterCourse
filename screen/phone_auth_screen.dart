import 'package:example/screen/firebase_authentication.dart';
import 'package:example/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController countryCode = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Phone Authentication',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body:
          EnterPhoneNumber(countryCode: countryCode, phoneNumber: phoneNumber),
    );
  }
}

class EnterPhoneNumber extends StatelessWidget {
  const EnterPhoneNumber({
    Key? key,
    required this.countryCode,
    required this.phoneNumber,
  }) : super(key: key);

  final TextEditingController countryCode;
  final TextEditingController phoneNumber;

  @override
  Widget build(BuildContext context) {
    final TextEditingController countryCode = TextEditingController();
    final TextEditingController phoneNumber = TextEditingController();
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: countryCode,
              decoration: const InputDecoration(
                labelText: 'Country Code',
                filled: true,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneNumber,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                filled: true,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50)),
              child: const Text('Get Otp'),
              onPressed: () {
                if (countryCode.text.isEmpty) {
                  return;
                }
                if (phoneNumber.text.isEmpty || phoneNumber.text.length <= 9) {
                  return;
                }
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return FutureBuilder<Map<String, dynamic>>(
                          future: FirebaseAuthentication.instance
                              .sendOtpToThePhoneNumber(
                                  "${countryCode.text}${phoneNumber.text}"),
                          builder: (_, snapshot) {
                            if (snapshot.hasData) {
                              return AlertDialog(
                                title: Text("Opt Sent"),
                                content: Text(
                                    "We have successfuly sent opt to the phone number"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(builder: (_) {
                                          return VerifyOtp(
                                              response: snapshot.data!);
                                        }));
                                      },
                                      child: Text("Ok"))
                                ],
                              );
                            }

                            if (snapshot.hasError) {
                              final Map<String, dynamic> error =
                                  snapshot.error as Map<String, dynamic>;
                              return AlertDialog(
                                title: Text(error['title']),
                                content: Text(error['message']),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Ok"))
                                ],
                              );
                            }
                            return const AlertDialog(
                              content: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          });
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class VerifyOtp extends StatelessWidget {
  final Map<String, dynamic> response;
  const VerifyOtp({
    Key? key,
    required this.response,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController otp = TextEditingController();
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: otp,
                decoration:
                    const InputDecoration(filled: true, labelText: "Enter Otp"),
              ),
              const SizedBox(
                height: 24.0,
              ),
              ElevatedButton(
                onPressed: () {
                  if (otp.text.isEmpty) {
                    return;
                  }

                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return FutureBuilder<User>(
                            future: FirebaseAuthentication.instance
                                .verifyOtp(response['result'], otp.text),
                            builder: (_, snapshot) {
                              if (snapshot.hasData) {
                                return AlertDialog(
                                  title: Text("Account Creation Successfull"),
                                  content: Text(
                                      "We have successfuly created account, you can navigate to home screen"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(builder: (_) {
                                            return HomeScreen();
                                          }));
                                        },
                                        child: Text("Ok"))
                                  ],
                                );
                              }

                              if (snapshot.hasError) {
                                return AlertDialog(
                                  title: Text("Unexpected Error"),
                                  content: Text(snapshot.error.toString()),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Ok"))
                                  ],
                                );
                              }
                              return const AlertDialog(
                                content: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            });
                      });
                },
                child: const Text("Verify Otp"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
